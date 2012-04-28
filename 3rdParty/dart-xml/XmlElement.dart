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
* Represents an element node of XML.
*/
class XmlElement extends XmlNode {
  final String name;
  final XmlCollection<XmlNode> _children;
  final Map<String, String> _attributes;
  final Map<String, String> _namespaces;

  //final String namespace; //future

  XmlElement(this.name, [List<XmlNode> elements = const []])
  :
    _children = new XmlCollection<XmlNode>._internal(),
    _attributes = {},
    _namespaces = {},
    super(XmlNodeType.Element)
  {
    addChildren(elements);
  }

  /**
  * Gets a [String] of any text within this [XmlElement].
  */
  String get text() {
    var tNodes = _children.filter((el) => el is XmlText);
    if (tNodes.isEmpty()) return '';

    var s = new StringBuffer();
    tNodes.forEach((n) => s.add(n.text));
    return s.toString();
  }

  /**
  * Gets a map of name/uri namespace pairs associated with
  * this [XmlElement].
  */
  Map<String, String> get namespaces() => _namespaces;

  /**
  * Gets a map of name/value attributue pairs associated with
  * this [XmlElement].
  */
  Map<String, String> get attributes() => _attributes;

  /**
  * Gets a collection of children under this [XmlElement].
  */
  Collection<XmlNode> get children() => _children;

  /**
  * Gets a collection of siblings related to this [XmlElement].
  */
  Collection<XmlNode> get siblings() => parent.children;

  /**
  * Gets a collection of [XmlNamespace]s that are in scope to this
  * [XmlElement].
  */
  Collection<XmlNamespace> get namespacesInScope() {
    List<XmlNamespace> l = [];

    _namespaces.forEach((nname, uri){
      l.add(new XmlNamespace(nname, uri));
    });

    if (parent != null && parent is XmlElement){
      l.addAll(parent.namespacesInScope);
    }

    return l;
  }

  /**
  * Returns true if the given [namespace] name is found in the current
  * scope of namespaces.
  */
  bool isNamespaceInScope(String namespace) =>
      namespacesInScope.some((ns) => ns.name == namespace);

  /**
  * Gets the previous sibling to the this [XmlElement], or null if none exists.
  */
  XmlNode get previousSibling() {
    var i = parent._children.indexOf(this);

    if (i <= 0) return null;

    return parent._children[i - 1];
  }

  /**
  * Gets the next sibling adjacent to this [XmlElement], or null if none
  * exists.
  */
  XmlNode get nextSibling() {
    if (parent._children.last() == this) return null;

    var i = parent._children.indexOf(this);

    return parent._children[i + 1];
  }

  /**
  * Gets a boolean indicating of this [XmlElement] has any child elements.
  */
  bool get hasChildren() => !_children.isEmpty();

  /**
  * Adds a child [XmlNode] to this [XmlElement].
  */
  void addChild(XmlNode element){
    //shunt any XmlAttributes into the map
    if (element is XmlAttribute){
      attributes[element.dynamic.name] = element.dynamic.value;
      return;
    }

    //shunt any XmlNamespaces into the map
    if (element is XmlNamespace){
      namespaces[element.dynamic.name] = element.dynamic.uri;
      return;
    }

    element.parent = this;
    _children._add(element);
  }

  /**
  * Adds a collection of [XmlNode]s to this [XmlElement].
  */
  void addChildren(Collection<XmlNode> elements){
    if (!elements.isEmpty()){
      elements.forEach((XmlNode e) => addChild(e));
    }
  }

  /**
  * Returns the first node in the tree that matches the given [queryOn]
  * parameter.
  *
  * ## Usage ##
  * * query('tagName') // returns first occurance matching tag name.
  * * query(XmlNodeType.CDATA) // returns first occurance of element matching
  * the given node type (CDATA node in this example).
  * * query({'attributeName':'attributeValue'}) // returns the first occurance
  * of any [XmlElement] where the given attributes/values are found.
  */
  XmlCollection<XmlNode> query(queryOn){
    XmlCollection<XmlNode> list = new XmlCollection._internal();

    if (queryOn is String){
      _queryNameInternal(queryOn, list);
    }else if (queryOn is XmlNodeType){
      _queryNodeTypeInternal(queryOn, list);
    }else if (queryOn is Map){
      _queryAttributeInternal(queryOn, list);
    }

    return list;
  }


  void _queryAttributeInternal(Map aMap, XmlCollection<XmlNode> list){
    bool checkAttribs(){
      var succeed = true;

      //TODO needs better implementation to
      //break out on first false
      aMap.forEach((k, v){
        if (succeed && attributes.containsKey(k)) {
          if (attributes[k] != v) succeed = false;
        }else{
          succeed = false;
        }
      });

      return succeed;
    }

    if (checkAttribs()){
      list._add(this);
      return;
    }else{
      if (hasChildren){
        children
        .filter((el) => el is XmlElement)
        .forEach((el){
          if (!list.isEmpty()) return;
          el._queryAttributeInternal(aMap, list);
        });
      }
    }
  }

  void _queryNodeTypeInternal(XmlNodeType nodeType,
                              XmlCollection<XmlNode> list){
    if (type == nodeType){
      list._add(this);
      return;
    }else{
      if (hasChildren){
        children
          .forEach((el){
            if (!list.isEmpty()) return;
            if (el is XmlElement){
              el._queryNodeTypeInternal(nodeType, list);
            }else{
              if (el.type == nodeType){
                list._add(el);
                return;
              }
            }
          });
      }
    }
  }

  void _queryNameInternal(String tagName, XmlCollection<XmlNode> list){

    if (this.name == tagName){
      list._add(this);
      return;
    }else{
      if (hasChildren){
        children
          .filter((el) => el is XmlElement)
          .forEach((el){
            if (!list.isEmpty()) return;
            el._queryNameInternal(tagName, list);
          });
      }
    }
  }

  /**
  * Returns a list of nodes in the tree that match the given [queryOn]
  * parameter.
  *
  * ## Usage ##
  * * query('tagName') = returns first occurance matching tag name.
  * * query(XmlNodeType.CDATA) // returns first occurance of element matching
  * the given node type (CDATA node in this example).
  */
  XmlCollection<XmlNode> queryAll(queryOn){
    var list = new XmlCollection<XmlNode>._internal();

    if (queryOn is String){
      _queryAllNamesInternal(queryOn, list);
    }else if (queryOn is XmlNodeType){
      _queryAllNodeTypesInternal(queryOn, list);
    }else if (queryOn is Map){
      _queryAllAttributesInternal(queryOn, list);
    }

    return list;
  }

  void _queryAllAttributesInternal(Map aMap, XmlCollection<XmlNode> list){
    bool checkAttribs(){
      var succeed = true;

      //TODO needs better implementation to
      //break out on first false
      aMap.forEach((k, v){
        if (succeed && attributes.containsKey(k)) {
          if (attributes[k] != v) succeed = false;
        }else{
          succeed = false;
        }
      });

      return succeed;
    }

    if (checkAttribs()){
      list._add(this);
    }else{
      if (hasChildren){
        children
        .filter((el) => el is XmlElement)
        .forEach((el){
          el._queryAttributeInternal(aMap, list);
        });
      }
    }
  }

  void _queryAllNodeTypesInternal(XmlNodeType nodeType, XmlCollection<XmlNode> list){
    if (type == nodeType){
      list._add(this);
    }else{
      if (hasChildren){
        children
          .forEach((el){
            if (el is XmlElement){
              el._queryAllNodeTypesInternal(nodeType, list);
            }else{
              if (el.type == nodeType){
                list._add(el);
              }
            }
          });
      }
    }
  }

  _queryAllNamesInternal(String tagName, XmlCollection<XmlNode> list){
    if (this.name == tagName){
      list._add(this);
    }

    if (hasChildren){
      children
      .filter((el) => el is XmlElement)
      .forEach((el){
        el._queryAllNamesInternal(tagName, list);
      });
    }
  }
}






