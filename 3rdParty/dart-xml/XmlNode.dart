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
* Represents a base class for XML nodes.  This node is essentially
* read-only.  Use [XmlElement] for manipulating attributes
* and heirarchies.
*/
class XmlNode {
  final XmlNodeType type;
  XmlElement parent;

  XmlNode(this.type);

  void remove(){
    if (parent == null) return;

    var i = parent._children.indexOf(this);
    if (i == -1){
      throw const XmlException('Element not found.');
    }

    parent._children._removeRange(i, 1);
  }

  /// Returns a text representation of the XmlNode tree.
  String toString() {
    StringBuffer s = new StringBuffer();
    _stringifyInternal(s, this, 0);
    return s.toString();
  }

  static void _stringifyInternal(StringBuffer b, XmlNode n, int indent){
    switch(n.type){
      case XmlNodeType.Element:
        b.add('\r${_space(indent)}<${n.dynamic.name}');

        if (n.dynamic.namespaces.length > 0){
          n.dynamic.namespaces.forEach((k, v) =>
              b.add(new XmlNamespace(k, v).toString()));
        }

        if (n.dynamic.attributes.length > 0){
          n.dynamic.attributes.forEach((k, v) =>
              b.add(new XmlAttribute(k, v).toString()));
        }

        b.add('>');

        if (n.dynamic.hasChildren){
          n.dynamic.children.forEach((e) =>
              _stringifyInternal(b, e, indent + 3));
        }

        if (n.dynamic.children.length > 0){
          b.add('\r${_space(indent)}</${n.dynamic.name}>');
        }else{
          b.add('</${n.dynamic.name}>');
        }

        break;
      case XmlNodeType.Namespace:
      case XmlNodeType.Attribute:
        b.add(n.toString());
        break;
      case XmlNodeType.Text:
        b.add('\r${_space(indent)}$n');
        break;
      case XmlNodeType.PI:
      case XmlNodeType.CDATA:
        b.add('\r$n');
        break;
    }
  }

  static String _space(int amount) {
    StringBuffer s = new StringBuffer();
    for (int i = 0; i < amount; i++){
      s.add(' ');
    }
    return s.toString();
   }
}