// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#library("Controller");

#import('dart:io');
#import('dart:json');
#import('../3rdParty/jsonObject.dart');
#import ('../dart-feed/FeedParser.dart');

#import('Storage/Storage.dart');

#source('FeedController.dart');
#source('FeedItemController.dart');
#source('ParserController.dart');
#source('Convert.dart');


class Server {
  final HOST = "127.0.0.1";
  final PORT = 8080;
  final TIMERMS = 3 * 1000;

  final LOG_REQUESTS = true;

  FeedController _feedController;
  FeedItemController _feedItemController;
  ParserController _parserController;
  Storage _storage;
  
  Server() {
    _storage = new InMemoryStorage();
    _feedController = new FeedController(_storage);
    _feedItemController = new FeedItemController(_storage);
    _parserController = new ParserController();
  }
  
  
  void run() {
    initTestData();
    
    new Timer.repeating(TIMERMS, (Timer t) => updateAllFeeds());
    
    HttpServer server = new HttpServer();
    server.addRequestHandler((HttpRequest request) => true, requestReceivedHandler);
    server.listen(HOST, PORT);
    
    print("Serving the current time on http://${HOST}:${PORT}."); 
  }
  
  
  void requestReceivedHandler(HttpRequest request, HttpResponse response) {
    if (LOG_REQUESTS) {
      print("Request: ${request.method} ${request.uri}");
    }
    
    String result;
    if (request.path.startsWith('/feeds')) {
      result = _feedController.get();
    } else if (request.path.startsWith('/feeditems')) {
      result = _feedItemController.get(request.queryParameters['fid']);
    } else if (request.path.startsWith('/parsed')) {
      result = _parserController.get(null); // TODO
    } else {
      result = ''; // TODO 404
    }
    
    respond(response, result);
  }
  
  
  void respond(HttpResponse response, String data) {
    response.headers.set(HttpHeaders.CONTENT_TYPE, "text/html; charset=UTF-8");
    response.outputStream.writeString(wrapJson(data));
    response.outputStream.close();
  }
  
  
  String wrapJson(String jsonString) {
    StringBuffer sb = new StringBuffer();
    sb.add('callbackForJsonpApi({"responseData":');
    sb.add(jsonString);
    sb.add('})');
    
    return sb.toString();
  }
  
  
  void updateAllFeeds() {
    List feeds = _storage.getFeeds();
    
    for (var feedDO in feeds) {
      FeedParser.loadAndParse(feedDO.sourceUrl).then(
        (Feed f) {
          var updatedFeedDO = Convert.feedToDO(f, feedDO);
          _storage.saveFeed(updatedFeedDO);
          
          var newItems = new List();
          for (FeedItem fi in f.feedItems) {
            newItems.add(Convert.feedItemToDO(fi, new JsonObject()));
          }
          
          _storage.addFeedItems(updatedFeedDO.id, newItems);
        });
    }
  }
  
  void initTestData() {
    var feed;
    var i;
    var itemsList;
    
    // feed 1 http://feeds.bbci.co.uk/news/rss.xml
    feed = new JsonObject();
    feed.id = null;
    feed.sourceUrl = @'C:\Work\dartfeeds\bbc.xml';
    _storage.saveFeed(feed);
    
    // feed 2
    feed = new JsonObject();
    feed.id = null;
    feed.sourceUrl = @'C:\Work\dartfeeds\nyt.xml';
    _storage.saveFeed(feed);

    feed = new JsonObject();
    feed.id = null;
    feed.sourceUrl = @'C:\Work\dartfeeds\sport.xml';
    _storage.saveFeed(feed);
  }
}

void main() {
  Server server = new Server();
  server.run();
}

