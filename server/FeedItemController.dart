class FeedItemController {
  
  Storage _storage;
  
  FeedItemController(this._storage) {}
  
  
  String get(String feedId) {
    var items = _storage.getFeedItems(feedId);
    var res = new JsonObject();
    res.itemData = items;

    String response = JSON.stringify(res);
    return response;
  }
}
