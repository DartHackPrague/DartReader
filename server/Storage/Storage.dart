#library ('Storage'); 
#import ('../../dart-feed/FeedParser.dart');



/*fake implementation
 of Repository pattern
*/
class Storage {

  List<Feed> GetAll()  {
    
    List<Feed> all = new List<Feed>();

    //hardcoded fake list:
    
    Feed one = new Feed();
    one.title = "BBC News - Home";
    one.imageUrl = "http://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif";
    one.id="1";
    all.add(one); 
    
    Feed second = new Feed();
    second.title = "any rss feed...";
    second.imageUrl = "http://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif";
    second.id="2";
    all.add(second);
    
    return all;
  }

}
