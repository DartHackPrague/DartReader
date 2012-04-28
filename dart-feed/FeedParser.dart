#library('FeedParser');

#import('dart:io');
#import('dart:uri');
#import('../3rdParty/dart-xml/Xml.dart');

#source('Feed.dart');
#source('FeedItem.dart');


class FeedParser
{
  static Future<Feed> loadAndParse(String feedUrl)
  {
    Completer completer = new Completer();
    
    HttpClient httpClient = new HttpClient();
    
    HttpClientConnection conn = httpClient.getUrl(new Uri.fromString(feedUrl));
    conn.onResponse =
      (HttpClientResponse resp)
      {
        List content = resp.inputStream.read();
        String xmlString = new String.fromCharCodes(content);
        XmlElement xml = XML.parse(xmlString);
        
        Feed f = new Feed();
        f.feedItems = new List<FeedItem>();
        for (var item in xml.query('item'))
        {
          FeedItem fi = new FeedItem();
          fi.title = "test";
        }
        
        completer.complete(f);
      };
    httpClient.shutdown();
    
    return completer.future;
  }
}
