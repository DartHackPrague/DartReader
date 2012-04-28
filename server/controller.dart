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


final HOST = "127.0.0.1";
final PORT = 8080;

final LOG_REQUESTS = true;

void main() {
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
    FeedController c = new FeedController();
    result = c.get();
  } else if (request.path.startsWith('/feeditems')) {
    FeedItemController c = new FeedItemController();
    result = c.get(request.queryParameters['fid']);
  } else {
    result = ''; // TODO 404
  }
  
  response.headers.set(HttpHeaders.CONTENT_TYPE, "text/html; charset=UTF-8");
  response.outputStream.writeString(result);
  response.outputStream.close();
}
