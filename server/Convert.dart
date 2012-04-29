class Convert {
  
  static feedToDO(Feed feed, var feedDataObject) {
    feedDataObject.title = feed.title;
    feedDataObject.url = feed.url;
    feedDataObject.description = feed.description;
    feedDataObject.imageUrl = feed.imageUrl;
    
    return feedDataObject;
  }
  
  static feedItemToDO(FeedItem item, var itemDataObject) {
    itemDataObject.guid = item.guid;
    itemDataObject.title = item.title;
    itemDataObject.description = item.description;
    itemDataObject.url = item.url;
    itemDataObject.pubDate = item.pubDate;
    
    return itemDataObject;
  }
}
