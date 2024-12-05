public struct VStack: TextNode {

  @usableFromInline
  let content: [any TextNode]

  @usableFromInline
  let separator: any TextNode

  @inlinable
  public init(
    spacing: Int = 1,
    @TextBuilder content: () -> any TextNode
  ) {
    self.content = array(from: content())
    self.separator = seperator("\n", count: spacing > 0 ? spacing - 1 : 0)
  }

  @inlinable
  public var body: some TextNode {
    content.removingEmptys()
      .joined(separator: separator.render())
  }
}
