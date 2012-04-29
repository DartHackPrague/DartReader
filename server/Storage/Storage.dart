#library('Storage');

#import ('../../dart-feed/FeedParser.dart');

#source('InMemoryStorage.dart');


/** interface of storage of feeds and feed items
*/
interface Storage {
  Collection getFeeds();
  
  void saveFeed(var feed);
  
  Collection getFeedItems(String feedId);
  
  void addFeedItems(String feedId, Collection feedItems);
}
