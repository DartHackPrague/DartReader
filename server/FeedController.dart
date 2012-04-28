class FeedController
{
  String get() {
    Storage repo = new Storage();
    List<Feed> feeds = repo.getAll();
    
    var allDtos = feeds.map(toDto);
    String response = JSON.stringify(allDtos);
    return response;
  }
  
  // Converts domain object to Data-transfer-object
  String toDto(Feed domainObject) {
    var dto = new JsonObject();  //default constructor sets isExtendable to true
    dto.id = domainObject.id;
    dto.title = domainObject.title;
    dto.url = domainObject.url;
    return dto; 
  }
}
