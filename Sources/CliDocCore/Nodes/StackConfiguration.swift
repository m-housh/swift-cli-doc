/// Represents the content of an ``HStack`` or a ``VStack``.
///
///
public struct StackConfiguration {
  public let content: [any TextNode]
}

@usableFromInline
struct AnySeparatableStackNode<Separator: TextNode>: TextNode {

  @usableFromInline
  let content: [any TextNode]

  @usableFromInline
  let separator: Separator

  @usableFromInline
  init(content: StackConfiguration, separator: Separator) {
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
