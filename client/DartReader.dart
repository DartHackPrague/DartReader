#import('dart:html');
#import('dart:uri');
#import('dart:json');
#source('utils/SourceItem.dart');
#source('utils/FeedItem.dart');
#source ('templates/Source_list.dart');

class DartReader {
  final SOURCE_FEED_URL="http://127.0.0.1:8080/feeds";
  final SOURCE_FEED_ITEM_URL="http://127.0.0.1:8080/feeditems?fid=";
  final WINDOW_MESSAGE_GET_FEED_ITEM="get_feed_item_";
  
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
  
  void messageHandler(MessageEvent e) {
    String message = e.data.toString();
    
    print(message);
    
    if (message.startsWith(WINDOW_MESSAGE_GET_FEED_ITEM)){
      var feedId = message.substring(WINDOW_MESSAGE_GET_FEED_ITEM.length);
      download_feed_item(feedId);
      
      return;
    }
    
    process_downloaded_data(e.data);
  }
  
  void download_feed_item(id){
    load_data(SOURCE_FEED_ITEM_URL+id);
    
    //Element script = new Element.tag("script");
    //script.src = SOURCE_FEED_ITEM_URL+id;
    //document.body.elements.add(script);
  }
  //data loaders
  void process_downloaded_data(data){
    var f = JSON.parse(data);
    print(f);
    List s;
    if (f['responseData']['sourceData'] !=null){
      s=f['responseData']['sourceData'];
      process_source_data(s);
    }else{
      s=f['responseData']['itemData'];
      process_feed_data(s);
    }
  }
  
  void process_source_data(List data){
    print('Processing source feed');
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
  
  void process_feed_data(List data){
    print('Processing item feed');
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
