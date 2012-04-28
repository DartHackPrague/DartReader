#import('dart:html');
#import('dart:uri');
#import('dart:io');
#import('dart:json');
#source ('client/templates/Source_list.dart');

class DartReader {
  final SOURCE_FEED_URL="http://127.0.0.1:8080/";
  
  DartReader() {
    
  }

  void run() {
    init_source();
  }

  void init_source(){
    List source_list = get_fake_source_list();

    SourceList source_tmp = new SourceList(source_list);
    document.body.elements.add(source_tmp.root);
    
    loadSourceData(SOURCE_FEED_URL);
  }
  
  List get_fake_source_list(){
    List list = ['cnn', 'bbc'];
    return list;
  }
  
  void loadSourceData(String feedURL)
  {
    XMLHttpRequest req =
        new XMLHttpRequest.getTEMPNAME(feedURL,
               (result) {
                   List posts = JSON.parse(result.responseText);
               });   
    
    //HttpClient httpClient = new HttpClient();
    
    //HttpClientConnection conn = httpClient.getUrl(new Uri.fromString(feedURL));
    //conn.onResponse =
    //  (HttpClientResponse resp)
    //  {
    //    Object data = JSON.parse(resp.inputStream.read().toString());
    //  };
    //httpClient.shutdown();
  }
}

void main() {
  new DartReader().run();
}
