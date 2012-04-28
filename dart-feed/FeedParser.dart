#library('FeedParser');

#import('dart:io');
#import('dart:uri');
#import('../3rdParty/dart-xml/Xml.dart');

#source('Feed.dart');
#source('FeedItem.dart');


class FeedParser
{
  static Future<Feed> loadAndParse(String fileName)
  {
    print('parsing ${fileName}');
    
    Completer compl = new Completer();
    
    File file = new File(fileName);
    InputStream stream = file.openInputStream();
    
    stream.onData = () {
      print('stream.onData');
      List content = stream.read();
      String xmlString = new String.fromCharCodes(content);
      print('xml len = ${xmlString.length}');
      XmlElement xml = XML.parse(xmlString);
      
      Feed f = new Feed();
      f.feedItems = new List<FeedItem>();
      for (var item in xml.query('item'))
      {
        FeedItem fi = new FeedItem();
        fi.title = "test";
      }
      
      compl.complete(f);
    };
    
    return compl.future;
  }
}
