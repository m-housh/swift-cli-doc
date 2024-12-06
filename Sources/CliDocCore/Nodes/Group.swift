/// A group of text nodes.
///
/// This allows you to group content together, which can optionally be
/// styled.
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
