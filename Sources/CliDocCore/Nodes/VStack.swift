/// A vertical stack of text nodes.
///
///

public struct VStack: TextNode {
  @usableFromInline
  let content: [any TextNode]

  @usableFromInline
  let separator: Separator.Vertical

  @inlinable
  public init(
    separator: Separator.Vertical = .newLine(count: 1),
    @TextBuilder content: () -> any TextNode
  ) {
    self.content = array(from: content())
    self.separator = separator
  }

  @inlinable
  public var body: some TextNode {
    content.removingEmptys()
      .joined(separator: separator.render())
  }
}
