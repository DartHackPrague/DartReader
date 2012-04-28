#import('dart:html');
#source ('client/templates/Source_list.dart');

class DartReader {

  DartReader() {
    
  }

  void run() {
    init_source();
  }

  void init_source(){
    List source_list = get_source_list();

    SourceList source_tmp = new SourceList(source_list);
    document.body.elements.add(source_tmp.root);
  }
  
  List get_source_list(){
    List list = ['cnn', 'bbc'];
    return list;
  }
}

void main() {
  new DartReader().run();
}
