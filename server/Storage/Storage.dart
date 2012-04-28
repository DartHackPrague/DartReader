/*fake implementation
 of Repository pattern
*/
class Storage {
  Map _feedById;
  
  Storage() {
    _feedById = new Map();
    FeedItem i;
    
    Feed one = new Feed();
    one.title = "BBC News - Home";
    one.imageUrl = "http://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif";
    one.id="1";
    one.feedItems = new List<FeedItem>();
    _feedById[one.id] = one;
    
    i = new FeedItem();
    i.title = 'Item 11';
    one.feedItems.add(i);
    i = new FeedItem();
    i.title = 'Item 12';
    one.feedItems.add(i);
    
    Feed second = new Feed();
    second.title = "any rss feed...";
    second.imageUrl = "http://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif";
    second.id="2";
    second.feedItems = new List<FeedItem>();
    _feedById[second.id] = second;
    
    i = new FeedItem();
    i.title = 'Item 21';
    second.feedItems.add(i);
    i = new FeedItem();
    i.title = 'Item 22';
    second.feedItems.add(i);
  }

  
  Collection<Feed> getAll()  {
    return _feedById.getValues();
  }
  
  
  Collection<FeedItem> getFeedItems(String feedId) {
    return _feedById[feedId].feedItems;
  }
}
