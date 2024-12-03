@resultBuilder
public enum TextBuilder {

  @inlinable
  public static func buildPartialBlock<N: TextNode>(first: N) -> N {
    first
  }

  @inlinable
  public static func buildPartialBlock<N0: TextNode, N1: TextNode>(accumulated: N0, next: N1) -> NodeContainer {
    .init(nodes: [accumulated, next])
  }

  @inlinable
  public static func buildArray<N: TextNode>(_ components: [N]) -> NodeContainer {
    .init(nodes: components)
  }

  @inlinable
  public static func buildBlock<N: TextNode>(_ components: N...) -> NodeContainer {
    .init(nodes: components)
  }

  @inlinable
  public static func buildEither<N: TextNode, N1: TextNode>(first component: N) -> EitherNode<N, N1> {
    .first(component)
  }

  @inlinable
  public static func buildEither<N: TextNode, N1: TextNode>(second component: N1) -> EitherNode<N, N1> {
    .second(component)
  }

  @inlinable
  public static func buildOptional<N: TextNode>(_ component: N?) -> N? {
    component
  }

}

public enum EitherNode<N: TextNode, N1: TextNode>: TextNode {
  case first(N)
  case second(N1)

  public func render() -> String {
    switch self {
    case let .first(node): return node.render()
    case let .second(node): return node.render()
    }
  }
}

public struct NodeContainer: TextNode {

  @usableFromInline
  var nodes: [any TextNode]

  @usableFromInline
  init(nodes: [any TextNode]) {
    self.nodes = nodes.reduce(into: [any TextNode]()) { array, next in
      if let many = next as? NodeContainer {
        array += many.nodes
      } else {
        array.append(next)
      }
    }
  }

  @inlinable
  public func render() -> String {
    nodes.reduce("") { $0 + $1.render() }
  }
}
