#library('FeedParser');

#import('dart:io');
#import('dart:uri');

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
      };
    httpClient.shutdown();
    
    return completer.future;
  }
}
