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

    return safeHTML('${item}');
  }

  // Each functions:
  each_0(List items, Element parent) {
    for (var item in items) {
      _scopes["item"] = item;
      var e0 = new Element.html('<li>${inject_0()}</li>');
      parent.elements.add(e0);
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

    foo_stylesheet_added = true;
    document.head.elements.add(new Element.html('<style>${styles.toString()}</style>'));
  }
}
