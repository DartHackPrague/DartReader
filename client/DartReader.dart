#import('dart:html');
#import('dart:uri');
#import('dart:json');
#source('utils/SourceItem.dart');
#source ('templates/Source_list.dart');

class DartReader {
  final SOURCE_FEED_URL="http://127.0.0.1:8080/feeds";
  
  DartReader() {
    
  }
  
  void run() {
    window.on.message.add(messageHandler);

    init_data();
  }

  void init_data(){
    load_data(SOURCE_FEED_URL);
  }
 
  
  void display_source_list(List source_list){
    SourceList source_tmp = new SourceList(source_list);
    document.body.elements.add(source_tmp.root);
  }
  
  List get_fake_source_list(){
    List list = ['cnn', 'bbc'];
    return list;
  }
  
  void messageHandler(MessageEvent e) {
    String message = e.data.toString();
    
    print(e.data);
    
    process_downloaded_data(e.data);
  }
  
  //data loaders
  void process_downloaded_data(data){
    var f = JSON.parse(data);
    List s =  f['responseData']['results'] ;
    process_source_data(s);
  }
  
  void process_source_data(List data){
    List result = new List();
    for (var item in data){
      SourceItem s = new SourceItem();
      
      s.id = item['id'];
      s.title = item['title'];
      s.imageUrl = item['imageUrl'];
      result.add(s);
    }
    
    display_source_list(result);
  }
  
  void load_data(String feedURL){
    Element script = new Element.tag("script");
    script.src = feedURL;
    document.body.elements.add(script);
  }
  
  void update_feed(){
    print('1');
  }
}

void main() {
  new DartReader().run();
}
