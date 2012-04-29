class ParserController {
  
  String get(var tempParsed) {
    var t = Convert.feedToDO(tempParsed, new JsonObject());
    t.items = new List<JsonObject>();
    
    for (FeedItem fi in tempParsed.feedItems) {
      var ti = Convert.feedItemToDO(fi, new JsonObject());
      t.items.add(ti);
    }
    
    return JSON.stringify(t);
  }
}
