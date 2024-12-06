/// An empty text node.
///
/// This gets removed from any output when rendering text nodes.
public struct Empty: TextNode {

  @inlinable
  public init() {}

  @inlinable
  public var body: some TextNode {
    ""
  }
}
