class FeedItemController {
  
  String get(String id) {
    Storage repo = new InMemoryStorage();
    List<FeedItem> items = repo.getFeedItems(id);

    var allDtos = items.map(toDto);
    String response = JSON.stringify(allDtos);
    return response;
  }
  
  
  // Converts domain object to Data-transfer-object
  String toDto(FeedItem item) {
    var dto = new JsonObject();  //default constructor sets isExtendable to true
    dto.id = item.id;
    dto.title = item.title;
    dto.url = item.url;
    dto.description = item.description;
    return dto; 
  }
}
