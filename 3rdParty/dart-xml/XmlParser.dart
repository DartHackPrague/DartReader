//   Copyright (c) 2012, John Evans
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

/**
* ## XML Parser ##
*
* ### When _withQuirks == true: ###
* * Allows optional attribute quotes for single string values
*/
class XmlParser {
  final String _xml;
  final Queue<XmlElement> _scopes;
  final bool _withQuirks;
  XmlElement _root;

  static XmlElement _parse(String xml, [withQuirks = false])
  {
    if (xml.isEmpty()){
      throw const XmlException('Nothing to parse.');
    }
    XmlParser p = new XmlParser._internal(xml, withQuirks);

    final XmlTokenizer t = new XmlTokenizer(p._xml);

    p._parseElement(t);

    return p._root;
  }

  XmlParser._internal(this._xml, this._withQuirks)
  :
    _scopes = new Queue<XmlElement>()
  ;

  void _parseElement(XmlTokenizer t){

    _XmlToken tok = t.next();

    while(tok != null){

      switch(tok.kind){
        case _XmlToken.START_COMMENT:
          _parseComment(t);
          break;
        case _XmlToken.START_CDATA:
          _parseCDATA(t);
          break;
        case _XmlToken.START_PI:
          _parsePI(t);
          break;
        case _XmlToken.LT:
          _parseTag(t);
          break;
        case _XmlToken.STRING:
          if (_scopes.isEmpty()){
            throw const XmlException('Text not allowed in root level.'
              ' Use comments instead.');
          }else{
            _parseTextNode(t, tok._str);
            _parseTag(t);
          }
          break;
      }
      tok = t.next();
    }

    if (!_scopes.isEmpty()){
      throw const XmlException('Unexpected end of file.  Not all tags were'
        ' closed.');
    }
  }

  _parsePI(XmlTokenizer t){
    //in CDATA node all tokens until ']]>' are joined to a single string
    StringBuffer s = new StringBuffer();

    _XmlToken next = t.next();

    while(next.kind != _XmlToken.END_PI){

      s.add(next.toStringLiteral());

      next = t.next();

      if (next == null){
        throw const XmlException('Unexpected end of file.');
      }
    }

    if (_scopes.isEmpty()){
      throw const XmlException('PI nodes are not supported in the top'
        ' level.');
    }

    _peek().addChild(new XmlProcessingInstruction(s.toString()));
  }

  _parseCDATA(XmlTokenizer t){
    //in CDATA node all tokens until ']]>' are joined to a single string
    StringBuffer s = new StringBuffer();

    _XmlToken next = t.next();

    while(next.kind != _XmlToken.END_CDATA){

      s.add(next.toStringLiteral());

      next = t.next();

      if (next == null){
        throw const XmlException('Unexpected end of file.');
      }
    }

    if (_scopes.isEmpty()){
      throw const XmlException('CDATA nodes are not supported in the top'
        ' level.');
    }

    _peek().addChild(new XmlCDATA(s.toString()));
  }

  //TODO create and XMLComment object instead of just ignoring?
  _parseComment(XmlTokenizer t){
    _XmlToken next = t.next();

    while (next.kind != _XmlToken.END_COMMENT){

      if (next.kind == _XmlToken.START_COMMENT){
        throw new XmlException.withDebug('Nested comments not allowed.',
          _xml, next._location);
      }
      next = t.next();

      if (next == null){
        throw const XmlException('Unexpected end of file.');
      }
    }
  }

  _parseTag(XmlTokenizer t){
    _XmlToken next = t.next();

    if (next.kind == _XmlToken.SLASH){
      // this is a close tag

      next = t.next();
      _assertKind(next, _XmlToken.STRING);

      var name = next._str;

      next = t.next();

      if (next.kind == _XmlToken.COLON){
        //process as namespace
        next = t.next();

        _assertKind(next, _XmlToken.STRING, 'Namespace prefix must pair with'
        ' an tag name: (<myNamespace:tagName ...)');

        name = '${name}:${next._str}';
        next = t.next();
      }


      if (_peek().name != name){
        throw new XmlException.withDebug(
        'Expected closing tag "${_peek().name}"'
        ' but found "${name}" instead.', _xml, next._location);
      }

      _assertKind(next, _XmlToken.GT);

      _pop();

      return;
    }

    //otherwise this is an open tag

    _assertKind(next, _XmlToken.STRING);

    //TODO check tag name for invalid chars

    var name = next._str;

    next = t.next();

    if (next.kind == _XmlToken.COLON){
      //process as namespace
      next = t.next();

      _assertKind(next, _XmlToken.STRING, 'Namespace prefix must pair with'
      ' an tag name: (<myNamespace:tagName ...)');

      name = '${name}:${next._str}';
    }

    XmlElement newElement = new XmlElement(name);

    if (_root == null){
      //set to root and push
      _root = newElement;
      _push(_root);
    } else{
      //add child to current scope
      _peek().addChild(newElement);
      _push(newElement);
    }

    if (_peek().name.contains(':')){
      var ns = _peek().name.split(':')[0];

      if (!_peek().isNamespaceInScope(ns)){
        throw new XmlException.withDebug('Namespace "${ns}" is'
          ' not declared in scope.', _xml, next._location);
      }
      next = t.next();
    }

    while(next != null){

      switch(next.kind){
        case _XmlToken.NAMESPACE:
          _parseNamespace(t);
          break;
        case _XmlToken.STRING:
          _parseAttribute(t, next._str);
          break;
        case _XmlToken.GT:
          _parseElement(t);
          return;
        case _XmlToken.SLASH:
          next = t.next();
          _assertKind(next, _XmlToken.GT);
          _pop();
          return;
        default:
          throw new XmlException.withDebug(
            'Invalid xml ${next} found at this location.',
            _xml,
            next._location);
      }

      next = t.next();

      if (next == null){
        throw const Exception('Unexpected end of file.');
      }
    }
  }

  void _parseTextNode(XmlTokenizer t, String text){

    //in text node all tokens until < are joined to a single string
    StringBuffer s = new StringBuffer();

    writeStringNode(){
      var string = s.toString();
      if (!string.isEmpty())
        _peek().addChild(new XmlText(s.toString()));
    }

    s.add(text);

    _XmlToken next = t.next();

    while(next.kind != _XmlToken.LT){
      switch(next.kind){
        case _XmlToken.START_COMMENT:
          writeStringNode();
          _parseComment(t);
          s = new StringBuffer();
          break;
        case _XmlToken.START_CDATA:
          writeStringNode();
          _parseCDATA(t);
          s = new StringBuffer();
          break;
        case _XmlToken.START_PI:
          writeStringNode();
          _parsePI(t);
          s = new StringBuffer();
          break;
        default:
          s.add(next.toStringLiteral());
          break;
      }

      next = t.next();

      if (next == null){
        throw const XmlException('Unexpected end of file.');
      }
    }

    writeStringNode();
  }

  void _parseNamespace(XmlTokenizer t){
    XmlElement el = _peek();

    void setNamespace(String name, String uri){
      el.namespaces[name] = uri;
    }

    _XmlToken next = t.next();
    _assertKind(next, _XmlToken.STRING, "Must declare namespace name.");
    var name = next._str;

    next = t.next();
    _assertKind(next, _XmlToken.EQ, "Must have an = after a"
      " namespace name.");

    next = t.next();

    void quotesRequired(){
      //require quotes

      _assertKind(next, _XmlToken.QUOTE, "Quotes are required around"
        " attribute values.");

      StringBuffer s = new StringBuffer();

      int qkind = next.quoteKind;

      do {
        next = t.next();

        if (next == null){
          throw const XmlException('Unexpected end of file.');
        }

        if (next.kind != _XmlToken.QUOTE){
          s.add(next.toStringLiteral());
        }else{
          if (next.quoteKind != qkind){
            s.add(next.toStringLiteral());
          }else{
            qkind = -1;
          }
        }

      } while (qkind != -1);


      setNamespace(name, s.toString());
    }


    if (_withQuirks){
      if (next.kind == _XmlToken.STRING){
        setNamespace(name, next._str);
      }else if (next.kind == _XmlToken.QUOTE){
        quotesRequired();
      }
    }else{
      quotesRequired();
    }
  }

  void _parseAttribute(XmlTokenizer t, String attributeName){
    XmlElement el = _peek();

    void setAttribute(String name, String value){
      //TODO validate well-formed attribute names
      el.attributes[name] = value;
    }

    _XmlToken next = t.next();

    if (next.kind == _XmlToken.COLON){
      //process as namespace
      next = t.next();

      _assertKind(next, _XmlToken.STRING, 'Namespace prefix must pair with'
      ' an attribute name: (myNamespace:myattribute="...")');

      if (!el.isNamespaceInScope(attributeName)){
        throw new XmlException.withDebug('Namespace "$attributeName" is'
          ' not declared in scope.', _xml, next._location);
      }

      attributeName = '${attributeName}:${next._str}';
      next = t.next();
    }

    _assertKind(next, _XmlToken.EQ, "Must have an = after an"
      " attribute name.");

    next = t.next();

    void quotesRequired(){
      //require quotes

      _assertKind(next, _XmlToken.QUOTE, "Quotes are required around"
        " attribute values.");

      StringBuffer s = new StringBuffer();

      int qkind = next.quoteKind;

      do {
        next = t.next();

        if (next == null){
          throw const XmlException('Unexpected end of file.');
        }

        if (next.kind != _XmlToken.QUOTE){
          s.add(next.toStringLiteral());
        }else{
          if (next.quoteKind != qkind){
            s.add(next.toStringLiteral());
          }else{
            qkind = -1;
          }
        }

      } while (qkind != -1);


      setAttribute(attributeName, s.toString());
    }


    if (_withQuirks){
      if (next.kind == _XmlToken.STRING){
        setAttribute(attributeName, next._str);
      }else if (next.kind == _XmlToken.QUOTE){
        quotesRequired();
      }
    }else{
      quotesRequired();
    }
  }


  void _push(XmlElement element){
  //  print('pushing element ${element.tagName}');
    _scopes.addFirst(element);
  }
  XmlElement _pop(){
  //  print('popping element ${_peek().tagName}');
    _scopes.removeFirst();
  }
  XmlElement _peek() => _scopes.first();

  void _assertKind(_XmlToken tok, int matchID, [String info = null]){
    _XmlToken match = new _XmlToken(matchID);

    var msg = 'Expected ${match}, but found ${tok}. ${info == null ? "" :
      "\r$info"}';

    if (tok.kind != match.kind) {
      throw new XmlException.withDebug(msg, _xml, tok._location);
    }
  }
}
