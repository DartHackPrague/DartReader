## Dart Xml ##
Dart Xml is a lightweight library for parsing and emitting xml.

## What "Lightweight" Means ##
Many programmatic scenarios concerning XML deal with serialization and
deserialization of data, usually for transmission between services). 
The querying of said data in object form is also important.  Typically 
these data are XML fragments and not fully formed XML documents. 

This project focuses the most common scenarios and does not concern itself with 
parsing of fully formed XML documents (with prologues, DOCTYPEs, etc). With the 
exception of comments, the parser expects a single node in the root of the XML
string (see **Limitations** below for more info).

Dart Developers who require more robust XML handling are encouraged to fork the
project and expand as needed.  Pull requests will certainly be welcomed.

## API ##
    #import('Xml.dart');

### Parsing ###
    // Returns a strongly-typed XmlNode tree
    XmlElement myXmlTree = XML.parse(myXmlString);
	
### Serialization ###
	// Returns a stringified xml document from a given XmlNode tree
	String myXmlString = XML.stringify(myXmlNode);
	
	// or...
	String myXmlString = myXmlNode.toString();

### Creating XML in Code ###
XML trees can be created manually in code:

    XmlElement test = new XmlElement('StackPanel',
        [new XmlElement('TextBlock',
           [
            new XmlAttribute('text', 'hello world!'),
            new XmlAttribute('fontSize', '12')
           ]),
         new XmlElement('Border',
           [
            new XmlElement('Image',
              [
               new XmlText('The quick brown fox jumped over the lazy dog.')
              ])
           ])
    ]);

... or you can let the parser do the work for you:

    XmlElement test = 
    XML.parse(
    ''' <stackpanel>
    		<textblock text='Hello World!' fontSize='12'></textblock>
    		<border>
    			<image>
    				The quick brown fox jumped over the lazy dog.
    			</image>
    		</border>
   		</stackpanel>
	'''
	);

### Queries ###
Any XmlElement can be queried a number of ways.  All queries return 
XmlCollection&lt;XmlElement&gt;, even the first-occurance queries. 
Query functions support these parameter types:

* String (match tag name)
* XmlNodeType (match XmlNodeType)
* Map (match one or more attribute/value pairs)

#### Example Queries ####
    // By tag name
    // returns the first occurance of any XmlElement matching the given tagName
    myXmlElement.query('div');
    myXmlElement.queryAll('div'); //returns all matches
    
    // By xml node type
    // returns the first occurance of any XmlElement matching the XmlNodeType
    myXmlElement.query(XmlNodeType.CDATA);
    myXmlElement.queryAll(XmlNodeType.CDATA); //returns all matches

    // By attribute
    // returns the first occurance of any XmlElement that contains all of
    // the provided attributes and matching values
    myXmlElement.query({'id':'foo', 'style':'bar'});
    myXmlElement.queryAll({'id':'foo', 'style':'bar'}); //returns all matches	

    
All queries are case-sensitive.

### Quirks Mode ###
Quirks mode is off by default, but can be enabled like so:

    XML.parse('<foo></foo>', withQuirks:true);

Currently quirks mode allows:

* Optional quotes around attribute values where a single word is the value.

#### Example ####
    // this is ok in quirks mode
    <foo bar=bloo></foo>
    
    // otherwise it would have to be
    <foo bar='bloo'></foo>
    
    // multiple words must be in quotes
    <foo bar='blee bloo'></foo>
    
## Supports ##
* Standard well-formed XML
* Comment nodes
* CDATA nodes
* Text nodes
* Namespace declarations and usage
* Processing Instruction (PI) nodes
* Querying of XML nodes by tagName, attribute(s), or XmlNodeType (combinators
soon hopefully)

## Limitations ##
* Doesn't enforce DTD
* Doesn't enforce any local schema declarations

## License ##
Apache 2.0