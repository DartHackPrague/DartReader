#library Storage;


#import ('../dart-feed/FeedParser.dart');
//#source "../dart-feed/FeedParser.dart";


class Storage {

  List<Feed> GetAll()  {
    
    List<Feed> all = new List<Feed>();

    //hardcoded fake list:
    
    Feed one = new Feed();
    one.title = "Titulek1";
    one.imageUrl = "any.gif";
    one.id="1";
    all.add(one); 
    
    Feed second = new Feed();
    second.title = "Titulek2";
    second.imageUrl = "any2.gif";
    second.id="2";
    all.add(second);
    
    return all;
  }

}
