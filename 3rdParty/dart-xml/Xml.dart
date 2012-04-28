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


// A lightweight, XML parser and emitter.
// See README.md for more info on features and limitations.

#library('Xml');
#source('XmlElement.dart');
#source('XmlParser.dart');
#source('XmlTokenizer.dart');
#source('XmlNode.dart');
#source('XmlNodeType.dart');
#source('XmlText.dart');
#source('XmlAttribute.dart');
#source('XmlException.dart');
#source('XmlCDATA.dart');
#source('XmlProcessingInstruction.dart');
#source('XmlCollection.dart');
#source('XmlNamespace.dart');

/**
* Utility class to work with XML data.
*/
class XML
{

  /**
  * Returns a [XmlElement] tree representing the raw XML fragment [String].
  *
  * Optional parameter [withQuirks] will allow the following when set to true:
  *
  * * Optional quotes for simple attribute values (no spaces).
  */
  static XmlElement parse(String xml, [withQuirks = false]) =>
      XmlParser._parse(xml.trim(), withQuirks);

  /**
  * Returns a stringified version of an [XmlElement] tree.
  * You can also call .toString() on any [XmlElement].
  */
  static String stringify(XmlElement element) => element.toString();

}


