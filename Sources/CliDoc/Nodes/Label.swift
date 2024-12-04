public struct Label<Content: TextNode>: TextNode {
  @usableFromInline
  let content: Content

  @inlinable
  public init(@TextBuilder _ content: () -> Content) {
    self.content = content()
  }

  @inlinable
  public init(_ content: Content) {
    self.content = content
  }

  @inlinable
  public var body: some TextNode {
    content
  }
}
