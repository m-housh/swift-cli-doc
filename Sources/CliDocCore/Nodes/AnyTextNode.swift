/// A type-erased text node.
public struct AnyTextNode: TextNode {
  @usableFromInline
  let makeString: () -> String

  @inlinable
  public init<N: TextNode>(_ node: N) {
    self.makeString = node.render
  }

  @inlinable
  public var body: some TextNode { makeString() }
}

public extension TextNode {

  @inlinable
  func eraseToAnyTextNode() -> AnyTextNode {
    AnyTextNode(self)
  }
}
