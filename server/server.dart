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
    //FeedParser.loadAndParse(@"C:\work\dartfeeds\bbc.xml").then((Feed f) => tempParsed = f);
    initTestData();
    
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
    sb.add('callbackForJsonpApi({"responseData":{"results":');
    sb.add(jsonString);
    sb.add('}})');
    
    return sb.toString();
  }
  
  void initTestData() {
    var feed;
    var i;
    var itemsList;
    
    // feed 1
    feed = new JsonObject();
    feed.id = null;
    feed.title = "BBC News - Home";
    feed.imageUrl = "http://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif";
    _storage.saveFeed(feed);
    
    itemsList = new List();
    
    i = new JsonObject();
    i.guid = '1';
    i.title = 'Item 11';
    i.url = 'http://www.dartlang.org';
    i.description = 'Item description text.';
    itemsList.add(i);
    
    i = new JsonObject();
    i.guid = '2';
    i.title = 'Item 12';
    i.url = 'http://www.dartlang.org';
    i.description = 'Item description text.';
    itemsList.add(i);
    
    _storage.addFeedItems("1", itemsList);

    // feed 2
    feed = new JsonObject();
    feed.id = null;
    feed.title = "any rss feed...";
    feed.imageUrl = "http://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif";
    _storage.saveFeed(feed);
    
    itemsList = new List();
    
    i = new JsonObject();
    i.guid = '3';
    i.title = 'Item 21';
    i.url = 'http://www.dartlang.org';
    i.description = 'Item description text.';
    itemsList.add(i);
    
    i = new JsonObject();
    i.guid = '4';
    i.title = 'Item 22';
    i.url = 'http://www.dartlang.org';
    i.description = 'Item description text.';
    itemsList.add(i);
    
    _storage.addFeedItems("2", itemsList);
  }
}

void main() {
  Server server = new Server();
  server.run();
}

