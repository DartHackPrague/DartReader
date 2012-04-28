// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#library("time_server");

#import("dart:io");
#import("dart:json");
#import("../3rdParty/jsonObject.dart");

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

  String jsonResponse = createJsonResponse();
  
  
  response.headers.set(HttpHeaders.CONTENT_TYPE, "text/html; charset=UTF-8");
  response.outputStream.writeString(jsonResponse);
  response.outputStream.close();
}

String createJsonResponse() {
  
  var feed = new JsonObject();  //default constructor sets isExtendable to true
  feed.name = "Chris";
  feed.title = "FirstTitle";
  String response =  JSON.stringify(feed);
  return response;
}

String createJsonResponseExample() {
  return 
'''
<html>
  <style>
    body { background-color: teal; }
    p { background-color: white; border-radius: 8px; border:solid 1px #555; text-align: center; padding: 0.5em; 
        font-family: "Lucida Grande", Tahoma; font-size: 18px; color: #555; }
  </style>
  <body>
    <br/><br/>
    <p>Current time: ${new Date.now()}</p>
  </body>
</html>
''';
} 