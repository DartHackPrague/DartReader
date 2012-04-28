#library('FeedParser');

#import('dart:io');
#import('dart:uri');
#import('../3rdParty/dart-xml/Xml.dart');

#source('Feed.dart');
#source('FeedItem.dart');


class FeedParser
{
  static Feed loadAndParse(String fileName)
  {
    File file = new File(fileName);
    InputStream stream = file.openInputStream();
    List content = stream.read();
    String xmlString = new String.fromCharCodes(content);
    print('test');
    stream.close();
    
    print('file read');
    
    XmlElement xml = XML.parse(xmlString);
    
    Feed f = new Feed();
    f.feedItems = new List<FeedItem>();
    for (var item in xml.query('item'))
    {
      FeedItem fi = new FeedItem();
      fi.title = "test";
    }
    
    return f;
  }
}
