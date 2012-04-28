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
    window.on.message.add(dataReceived);
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

  //data loaders
  void dataReceived(MessageEvent e) {
    var data = JSON.parse(e.data);
    print(data['responseData']);
    List s =  data['responseData']['results'] ;
    
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
}

void main() {
  new DartReader().run();
}
