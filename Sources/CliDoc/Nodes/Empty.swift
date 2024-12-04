/// An empty text node.
public struct Empty: TextNode {

  @inlinable
  public init() {}

  @inlinable
  public var body: some TextNode {
    ""
  }
}
