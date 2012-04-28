#library ('FeedProvider'); 
#import ('Storage/Storage.dart');
#import ('../dart-feed/FeedParser.dart');


//Provides all feets in the world -
//this is very simple implementation 
class FeedProvider {
    
    List<Feed> GetAll()    {
        Storage repo= new Storage();
        return repo.GetAll();
    }
   
  

}
