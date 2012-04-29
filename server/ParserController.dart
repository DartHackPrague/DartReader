class ParserController {
  
  String get(var tempParsed) {
    print('${tempParsed}');
    var t = new JsonObject();
    t.title = tempParsed.title;
    t.description = tempParsed.description;
    t.url = tempParsed.url;
    t.imageUrl = tempParsed.imageUrl;
    t.items = new List<JsonObject>();
    
    for (FeedItem fi in tempParsed.feedItems) {
      var ti = new JsonObject();
      ti.guid = fi.guid;
      ti.title = fi.title;
      ti.description = fi.description;
      ti.url = fi.url;
      ti.pubDate = fi.pubDate;
      
      t.items.add(ti);
    }
    
    return JSON.stringify(t);
  }
}
