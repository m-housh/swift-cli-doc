// swiftlint:disable type_name
/// Represents the content of an ``HStack`` or a ``VStack``.
///
/// This is an internal convenience type, but needs to remain public
/// for protcol conformances to work properly.
public struct _StackConfiguration {
  public let content: [any TextNode]
}

// swiftlint:enable type_name

/// A helper type that removes empty text nodes, and applies a separtor between
/// the array of text nodes.
///
@usableFromInline
struct AnySeparatableStackNode<Separator: TextNode>: TextNode {

  @usableFromInline
  let content: [any TextNode]

  @usableFromInline
  let separator: Separator

  @usableFromInline
  init(content: _StackConfiguration, separator: Separator) {
    self.content = content.content
    self.separator = separator
  }

  @usableFromInline
  var body: some TextNode {
    content.removingEmptys()
      .map { $0.render() }
      .joined(separator: separator.render())
  }
}
