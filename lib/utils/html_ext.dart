import 'package:html/dom.dart';

extension NodeParsing on Node {
  R? firstTag<R>(String tag, R apply(Node node)) => select(tag, apply);

  Node? firstTagNode<R>(String tag) => firstTag(tag, (node) => node);

  R? id<R>(String id, R apply(Node node)) {
    switch (nodeType) {
      case Node.DOCUMENT_NODE:
      case Node.DOCUMENT_FRAGMENT_NODE:
        return select('#$id', apply);
      default:
        return null;
    }
  }

  Node? idNode(String id) => this.id(id, (node) => node);

  R? firstClass<R>(String classes, R apply(Node node)) => select(
      classes.splitMapJoin(' ',
          onNonMatch: (m) => m.isNotEmpty ? '.$m' : m, onMatch: (m) => ''),
      apply);

  Node? firstClassNode(String classes) => firstClass(classes, (node) => node);

  R byTag<R>(String tag, R apply(List<Element> nodes)) => selectAll(tag, apply);

  List<Element> byTagNode(String tag) =>
      byTag(tag, (nodes) => nodes) ?? List.empty();

  R byClass<R>(String classes, R apply(List<Element> nodes)) => selectAll(
      classes.splitMapJoin(' ',
          onNonMatch: (m) => m.isNotEmpty ? '.$m' : m, onMatch: (m) => ''),
      apply);

  List<Element> byClassNode(String classes) =>
      byClass(classes, (nodes) => nodes) ?? List.empty();

  Element? _select(String selector) {
    switch (nodeType) {
      case Node.DOCUMENT_NODE:
        return (this as Document).querySelector(selector);
      case Node.DOCUMENT_FRAGMENT_NODE:
        return (this as DocumentFragment).querySelector(selector);
      case Node.ELEMENT_NODE:
        return (this as Element).querySelector(selector);
      default:
        return null;
    }
  }

  R? select<R>(String selector, R apply(Node node)) =>
      _select(selector)?.use(apply);

  List<Element> _selectAll(String selector) {
    switch (nodeType) {
      case Node.DOCUMENT_NODE:
        return (this as Document).querySelectorAll(selector);
      case Node.DOCUMENT_FRAGMENT_NODE:
        return (this as DocumentFragment).querySelectorAll(selector);
      case Node.ELEMENT_NODE:
        return (this as Element).querySelectorAll(selector);
      default:
        return List.empty();
    }
  }

  R selectAll<R>(String selector, R apply(List<Element> nodes)) =>
      apply(_selectAll(selector));

  List<Element> selectEach(String selector, void f(Element node)) {
    var nodes = _selectAll(selector);
    if (nodes.isNotEmpty) nodes.forEach(f);
    return nodes;
  }

  // Element child(Element f(Node node)) => f(this);

  R use<R>(R f(Node node)) => f(this);

  Node apply(void f(Node node)) {
    f(this);
    return this;
  }

  String? attr(String attribute) => attributes[attribute];
}
