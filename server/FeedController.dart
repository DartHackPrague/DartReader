class FeedController {
  
  Storage _storage;
  
  FeedController(this._storage) {}
  
  String get() {
    var feeds = _storage.getFeeds();
    var res = new JsonObject();
    res.sourceData = feeds;
    
    String response = JSON.stringify(res);
    return response;
  }
}
