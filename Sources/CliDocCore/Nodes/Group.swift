/// A group of text nodes.
///
/// This allows you to group content together, which can optionally be
/// styled.
///
/// ### Example:
///
/// ```swift
/// let group = Group {
///   "My headline."
///   "\n"
///   "Some content".color(.green)
///   "\n"
///   "Foo Bar".italic()
/// }
///
/// print(group.render())
/// ```
///
/// ![Group example](group.png)
///
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
