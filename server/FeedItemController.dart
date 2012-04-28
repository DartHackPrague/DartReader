class FeedItemController {
  
  Storage _storage;
  
  FeedItemController(this._storage) {}
  
  
  String get(String feedId) {
    var items = _storage.getFeedItems(feedId);

    String response = JSON.stringify(items);
    return response;
  }
}
