/** in-memory storage implementation
*/
class InMemoryStorage implements Storage {
  
  Map _feedById;
  Map _itemsByFeedIdByGuid;
  int _idCounter;
  
  InMemoryStorage() {
    _idCounter = 0;
    _feedById = new Map();
    _itemsByFeedIdByGuid = new Map();
  }
  

  Collection getFeeds()  {
    return _feedById.getValues();
  }
  
  
  void saveFeed(var feed) {
    if (feed.id == null) feed.id = (++_idCounter).toString();
    _feedById[feed.id] = feed;
  }
  
  
  Collection getFeedItems(String feedId) {
    return _itemsByFeedIdByGuid[feedId].getValues();
  }
  

  void addFeedItems(String feedId, Collection feedItems) {
    _itemsByFeedIdByGuid.putIfAbsent(feedId, () => new Map());
    
    Map itemByGuid = _itemsByFeedIdByGuid[feedId];
    for (var item in feedItems) itemByGuid[item.guid] = item;
  }
}
