#import('dart:html');

class DartReader {

  DartReader() {
  }

  void run() {
    write("This is DartReader");
  }

  void write(String message) {
    // the HTML library defines a global "document" variable
    document.query('#status').innerHTML = message;
  }
}

void main() {
  new DartReader().run();
}
