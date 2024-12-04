public struct Group<Content: TextNode>: TextNode {
  @usableFromInline
  var content: Content

  @inlinable
  public init(
    @TextBuilder content: () -> Content
  ) {
    self.content = content()
  }

  @inlinable
  public var body: some TextNode {
    content
  }
}
