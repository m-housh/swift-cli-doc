/// A horizontal group of text nodes.
public struct HStack: TextNode {

  @usableFromInline
  let content: [any TextNode]

  @usableFromInline
  let separator: Separator.Horizontal

  @inlinable
  public init(
    separator: Separator.Horizontal = .space(count: 1),
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
