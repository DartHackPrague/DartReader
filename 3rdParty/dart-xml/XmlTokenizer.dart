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
* Returns tokenized parts of Xml document.
*/
class XmlTokenizer {
  static final int TAB = 9;
  static final int NEW_LINE = 10;
  static final int CARRIAGE_RETURN = 13;
  static final int SPACE = 32;
  static final int QUOTE = 34;
  static final int SQUOTE = 39;
  static final int SLASH = 47;
  static final int COLON = 58;
  static final int LT = 60; //<
  static final int GT = 62; //>
  static final int EQ = 61; //=
  static final int Q = 63;  //?
  static final int B = 33;  //!
  static final int DASH = 45; //-
  static final int RBRACK = 93; //]

  static final List _reserved = const [LT, GT, Q, B, COLON, SLASH, QUOTE,
                                      SQUOTE, EQ, DASH, RBRACK];

  final Queue<_XmlToken> _tq;
  final String _xml;
  int _length;
  int _i = 0;

  XmlTokenizer(this._xml)
  :
    _i = 0,
    _tq = new Queue<_XmlToken>()
  {
    _length = _xml.length;
  }


  _XmlToken next()
  {
    void addToQueue(_XmlToken token){
      token._location = _i;
      _tq.addLast(token);
    }

    _XmlToken getNextToken() {
//      if (!_tq.isEmpty()){
//        print('token: ${_tq.first()}');
//      }
      return _tq.isEmpty() ? null : _tq.removeFirst();
    }


    // Returns the first char in the list that appears ahead.
    int peekUntil(List chars){
      int z = _i;

      while (z < _length && chars.indexOf(_xml.charCodeAt(z)) == -1){
        z++;
      }

      return _xml.charCodeAt(z);
    }

    // Returns the index of the last char of a given word, if found from
    // the current index onward; otherwise returns -1;
    int matchWord(String word){
      int z = _i;

      for(int ii = 0; ii < word.length; ii++){
        if(_xml.charCodeAt(z) != word.charCodeAt(ii)) return -1;
        z++;
      }

      return z - 1;
    }

    int nextNonWhitespace(int from){

      while(isWhitespace(_xml.charCodeAt(from))){
        from++;
      }
      return from;
    }

    int nextWhitespace(int from){
      while(!isWhitespace(_xml.charCodeAt(from))){
        from++;
      }
      return from;
    }

    // Peel off and return a token if there are any in the queue.
    if (!_tq.isEmpty()) return getNextToken();

    while(_i < _length && isWhitespace(_xml.charCodeAt(_i)))
      {
        _i++;
      }

    if (_i == _length) return null;
  //print('char: $_i code: ${_xml.charCodeAt(_i)} ' + _xml.substring(_i, _i+1));
    final int char = _xml.charCodeAt(_i);

    switch(char){
      case RBRACK:
        var m = matchWord(']]>');
        if (m != -1){
          addToQueue(new _XmlToken(_XmlToken.END_CDATA));
          _i = m + 1;
        }
        break;
      case DASH:
        var m = matchWord('-->');
        if (m != -1){
          addToQueue(new _XmlToken(_XmlToken.END_COMMENT));
          _i = m + 1;
        }
        break;
      case Q:
        var m = matchWord('?>');
        if (m != -1){
          addToQueue(new _XmlToken(_XmlToken.END_PI));
          _i = m + 1;
        }else{
          _i++;
          addToQueue(new _XmlToken(_XmlToken.QUESTION));
        }
        break;
      case B:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.BANG));
        break;
      case COLON:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.COLON));
        break;
      case SLASH:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.SLASH));
        break;
      case LT:
        final specialTags = const ['<!--', '<![CDATA[', '<?', '</'];
        var found = '';
        var endIndex = -1;

        for(final tag in specialTags){
          var m = matchWord(tag);
          if (m != -1){
            found = tag;
            endIndex = m;
            break;
          }
        }

        switch(found)
        {
          case specialTags[0]:
            addToQueue(new _XmlToken(_XmlToken.START_COMMENT));
            _i = endIndex + 1;
            break;
          case specialTags[1]:
            addToQueue(new _XmlToken(_XmlToken.START_CDATA));
            _i = endIndex + 1;
            break;
          case specialTags[2]:
            addToQueue(new _XmlToken(_XmlToken.START_PI));
            _i = endIndex + 1;
            break;
          case specialTags[3]:
            addToQueue(new _XmlToken(_XmlToken.LT));
            addToQueue(new _XmlToken(_XmlToken.SLASH));
            _i = endIndex + 1;
            break;
          default:
            //standard start tag
            _i++;
            addToQueue(new _XmlToken(_XmlToken.LT));
            _i = nextNonWhitespace(_i);
            int c = peekUntil([SPACE, COLON, GT]);
            if (c == SPACE){
              var _ii = _i;
              _i = nextWhitespace(_ii);
              addToQueue(new _XmlToken.string(_xml.substring(_ii, _i)));
              _i = nextNonWhitespace(_i);
            }else if (c == COLON){
              var _ii = _i;
              _i = _xml.indexOf(':', _ii) + 1;
              addToQueue(new _XmlToken.string(_xml.substring(_ii, _i - 1)));
              addToQueue(new _XmlToken(_XmlToken.COLON));
              _ii = nextWhitespace(_i);
              addToQueue(new _XmlToken.string(_xml.substring(_i, _ii)));
              _i = nextNonWhitespace(_ii);
            }
            break;
        }
        break;
      case GT:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.GT));
        break;
      case EQ:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.EQ));
        break;
      case QUOTE:
        _i++;
        addToQueue(new _XmlToken.quote(QUOTE));
        break;
      case SQUOTE:
        _i++;
        addToQueue(new _XmlToken.quote(SQUOTE));
        break;
      default:
        var m = matchWord('xmlns:');
        if (m != -1){
          _i = m + 1;
          addToQueue(new _XmlToken(_XmlToken.NAMESPACE));
        }else{
          StringBuffer s = new StringBuffer();

          while(_i < _length && !isReserved(_xml.charCodeAt(_i))){
            s.add(_xml.substring(_i, _i + 1));
            _i++;
          }
          addToQueue(new _XmlToken.string(s.toString().trim()));
        }
        break;
    }
    return getNextToken();
  }

  /**
  * Returns true if the charCode is one of the special reserved
  * charCodes
  */
  static bool isReserved(int c) => _reserved.indexOf(c) > -1;

  /**
  * Returns true if the charCode is considered to be whitespace.
  */
  static bool isWhitespace(int c) {
    return c == SPACE || c == TAB || c == NEW_LINE || c == CARRIAGE_RETURN;
  }

}

class _XmlToken {
  static final int LT = 1;
  static final int GT = 2;
  static final int QUESTION = 3;
  static final int STRING = 4;
  static final int BANG = 5;
  static final int COLON = 6;
  static final int SLASH = 7;
  static final int EQ = 8;
  static final int QUOTE = 9;
  static final int IGNORE = 10;
  static final int DASH = 11;
  static final int START_COMMENT = 12;
  static final int END_COMMENT = 13;
  static final int START_CDATA = 14;
  static final int END_CDATA = 15;
  static final int START_PI = 16;
  static final int END_PI = 17;
  static final int NAMESPACE = 18;

  final int kind;
  final int quoteKind;
  final String _str;
  int _location;

  _XmlToken._internal(this.kind, this._str, this.quoteKind);


  factory _XmlToken.string(String s) {
    return new _XmlToken._internal(STRING, s, -1);
  }

  factory _XmlToken.quote(int quoteKind){
    return new _XmlToken._internal(QUOTE, '', quoteKind);
  }


  factory _XmlToken(int kind) {
    return new _XmlToken._internal(kind, '', -1);
  }


  String toString() {
    switch(kind){
      case START_PI:
        return "(<?)";
      case END_PI:
        return "(?>)";
      case DASH:
        return "(-)";
      case LT:
        return "(<)";
      case GT:
        return "(>)";
      case QUESTION:
        return "(?)";
      case STRING:
        return 'STRING($_str)';
      case BANG:
        return "(!)";
      case COLON:
        return "(:)";
      case SLASH:
        return "(/)";
      case EQ:
        return "(=)";
      case QUOTE:
        return '(")';
      case START_COMMENT:
        return '(<!--)';
      case END_COMMENT:
        return '(-->)';
      case START_CDATA:
        return ('(<![CDATA[)');
      case END_CDATA:
        return ('(]]>)');
      case NAMESPACE:
        return ('xmlns:');
      case IGNORE:
        return 'INVALID()';

    }
  }

  String toStringLiteral() {
    switch(kind){
      case NAMESPACE:
        return "xmlns:";
      case GT:
        return ">";
      case LT:
        return "<";
      case QUESTION:
        return "?";
      case STRING:
        return _str;
      case BANG:
        return "!";
      case COLON:
        return ":";
      case SLASH:
        return "/";
      case EQ:
        return "=";
      case QUOTE:
        return quoteKind == XmlTokenizer.QUOTE ? '"' : "'";
      case IGNORE:
        return 'INVALID()';
      default:
        throw new XmlException('String literal unavailable for $this');

    }
  }
}