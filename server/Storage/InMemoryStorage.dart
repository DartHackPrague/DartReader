/** in-memory storage implementation
*/
class InMemoryStorage implements Storage {
  
  Map _feedById;
  int _idCounter;
  
  InMemoryStorage() {
    _feedById = new Map();
    FeedItem i;
    
    Feed one = new Feed();
    one.title = "BBC News - Home";
    one.imageUrl = "http://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif";
    one.id="1";
    one.feedItems = new List<FeedItem>();
    _feedById[one.id] = one;
    
    i = new FeedItem();
    i.id = '1';
    i.title = 'Item 11';
    i.url = 'http://www.dartlang.org';
    i.description = 'Item description text.';
    one.feedItems.add(i);
    
    i = new FeedItem();
    i.id = '2';
    i.title = 'Item 12';
    i.url = 'http://www.dartlang.org';
    i.description = 'Item description text.';
    one.feedItems.add(i);
    
    Feed second = new Feed();
    second.title = "any rss feed...";
    second.imageUrl = "http://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif";
    second.id="2";
    second.feedItems = new List<FeedItem>();
    _feedById[second.id] = second;
    
    i = new FeedItem();
    i.id = '3';
    i.title = 'Item 21';
    i.url = 'http://www.dartlang.org';
    i.description = 'Item description text.';
    second.feedItems.add(i);
    
    i = new FeedItem();
    i.id = '4';
    i.title = 'Item 22';
    i.url = 'http://www.dartlang.org';
    i.description = 'Item description text.';
    second.feedItems.add(i);
  }
  

  Collection getFeeds()  {
    return _feedById.getValues();
  }
  
  
  void addFeed(var feed) {
    
  }
  
  
  Collection getFeedItems(String feedId) {
    return _feedById[feedId].feedItems;
  }
  

  void addFeedItems(String feedId, Collection feedItems) {
    
  }
}
