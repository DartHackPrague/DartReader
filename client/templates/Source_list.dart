// Generated Dart class from HTML template.
// DO NOT EDIT.

String safeHTML(String html) {
  // TODO(terry): Escaping for XSS vulnerabilities TBD.
  return html;
}

class SourceList {
  Map<String, Object> _scopes;
  Element _fragment;

  List source_list;

  SourceList(this.source_list) : _scopes = new Map<String, Object>() {
    // Insure stylesheet for template exist in the document.
    add_foo_templatesStyles();

    _fragment = new DocumentFragment();
    var e0 = new Element.html('<ul id="source_lst"></ul>');
    _fragment.elements.add(e0);
    each_0(source_list, e0);
  }

  Element get root() => _fragment;

  // Injection functions:
  String inject_0() {
    // Local scoped block names.
    var item = _scopes["item"];

    return safeHTML('${item.title}');
  }

  // Each functions:
  each_0(List items, Element parent) {
    for (var item in items) {
      _scopes["item"] = item;
      var e0 = new Element.html('<li></li>');
      parent.elements.add(e0);
      var e1 = new Element.html('<span></span>');
      e0.elements.add(e1);
      var e2 = new Element.html('<img alt="${item.title}" src="${item.imageUrl}">image</img>');
      e1.elements.add(e2);
      var e3 = new Element.html('<span></span>');
      e1.elements.add(e3);
      var e4 = new Element.html('<a href="#${item.title}" onclick="javascript:download_feed_item(${item.id})">${inject_0()}</a>');
      e3.elements.add(e4);
      _scopes.remove("item");
    }
  }


  // With functions:

  // CSS for this template.
  static final String stylesheet = "";
}
class FeedItemsList {
  Map<String, Object> _scopes;
  Element _fragment;

  List feed_items_list;

  FeedItemsList(this.feed_items_list) : _scopes = new Map<String, Object>() {
    // Insure stylesheet for template exist in the document.
    add_foo_templatesStyles();

    _fragment = new DocumentFragment();
    var e0 = new Element.html('<ul id="feed_items_lst"></ul>');
    _fragment.elements.add(e0);
    each_0(feed_items_list, e0);
  }

  Element get root() => _fragment;

  // Injection functions:
  String inject_0() {
    // Local scoped block names.
    var item = _scopes["item"];

    return safeHTML('${item.title}');
  }

  String inject_1() {
    // Local scoped block names.
    var item = _scopes["item"];

    return safeHTML('${item.pubDate}');
  }

  String inject_2() {
    // Local scoped block names.
    var item = _scopes["item"];

    return safeHTML('${item.description}');
  }

  // Each functions:
  each_0(List items, Element parent) {
    for (var item in items) {
      _scopes["item"] = item;
      var e0 = new Element.html('<li></li>');
      parent.elements.add(e0);
      var e1 = new Element.html('<span></span>');
      e0.elements.add(e1);
      var e2 = new Element.html('<a href="${item.url}">${inject_0()}</a>');
      e1.elements.add(e2);
      var e3 = new Element.html('<span>${inject_1()}</span>');
      e0.elements.add(e3);
      var e4 = new Element.html('<span>${inject_2()}</span>');
      e0.elements.add(e4);
      _scopes.remove("item");
    }
  }


  // With functions:

  // CSS for this template.
  static final String stylesheet = "";
}


// Inject all templates stylesheet once into the head.
bool foo_stylesheet_added = false;
void add_foo_templatesStyles() {
  if (!foo_stylesheet_added) {
    StringBuffer styles = new StringBuffer();

    // All templates stylesheet.
    styles.add(SourceList.stylesheet);
    styles.add(FeedItemsList.stylesheet);

    foo_stylesheet_added = true;
    document.head.elements.add(new Element.html('<style>${styles.toString()}</style>'));
  }
}
