#import('dart:html');
#import('dart:uri');
#import('dart:json');
#source ('client/templates/Source_list.dart');

class DartReader {
  final SOURCE_FEED_URL="http://127.0.0.1:8080/feeds";
  
  DartReader() {
    
  }
  
  void run() {
    window.on.message.add(dataReceived);
    init_source();
  }

  void init_source(){
    List source_list = get_fake_source_list();
     
    loadSourceData(SOURCE_FEED_URL);
  }
 
  
  void display_source_list(List source_list){
    SourceList source_tmp = new SourceList(source_list);
    document.body.elements.add(source_tmp.root);
  }
  
  List get_fake_source_list(){
    List list = ['cnn', 'bbc'];
    return list;
  }

  //data loaders
  void dataReceived(MessageEvent e) {
    var data = JSON.parse(e.data);
    print(data['responseData']);
    List s =  data['responseData']['results'] ;
    
    List source_list = new List();
    for (var item in s){
      print(item['title']);
      source_list.add(item['title']);
      
    }
    
    display_source_list(source_list);
  }
  
  void loadSourceData(String feedURL){
    Element script = new Element.tag("script");
    script.src = feedURL;
    document.body.elements.add(script);
  }
}

void main() {
  new DartReader().run();
}
