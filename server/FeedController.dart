class FeedController {
  
  Storage _storage;
  
  FeedController(this._storage) {}
  
  String get() {
    var feeds = _storage.getFeeds();
    
    String response = JSON.stringify(feeds);
    return response;
  }
}
