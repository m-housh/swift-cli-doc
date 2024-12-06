/// A result builder for creating ``TextNode`` types, similar to how
/// `ViewBuilder` works in `SwiftUI`.
///
@resultBuilder
public enum TextBuilder {

  @inlinable
  public static func buildPartialBlock<N: TextNode>(first: N) -> N {
    first
  }

  @inlinable
  public static func buildPartialBlock<N0: TextNode, N1: TextNode>(accumulated: N0, next: N1) -> _NodeContainer {
    .init(nodes: [accumulated, next])
  }

  @inlinable
  public static func buildArray<N: TextNode>(_ components: [N]) -> _NodeContainer {
    .init(nodes: components)
  }

  @inlinable
  public static func buildBlock<N: TextNode>(_ components: N...) -> _NodeContainer {
    .init(nodes: components)
  }

  @inlinable
  public static func buildEither<N: TextNode, N1: TextNode>(first component: N) -> _EitherNode<N, N1> {
    .first(component)
  }

  @inlinable
  public static func buildEither<N: TextNode, N1: TextNode>(second component: N1) -> _EitherNode<N, N1> {
    .second(component)
  }

  @inlinable
  public static func buildOptional<N: TextNode>(_ component: N?) -> N? {
    component
  }

}

// swiftlint:disable type_name
public enum _EitherNode<N: TextNode, N1: TextNode>: TextNode {
  case first(N)
  case second(N1)

  public var body: some TextNode {
    switch self {
    case let .first(node): return node.eraseToAnyTextNode()
    case let .second(node): return node.eraseToAnyTextNode()
    }
  }
}

public struct _NodeContainer: TextNode {

  @usableFromInline
  var nodes: [any TextNode]

  @usableFromInline
  init(nodes: [any TextNode]) {
    self.nodes = nodes.reduce(into: [any TextNode]()) { array, next in
      if let many = next as? _NodeContainer {
        array += many.nodes
      } else {
        array.append(next)
      }
    }
  }

  @inlinable
  public var body: some TextNode {
    nodes.reduce("") { $0 + $1.render() }
  }
}

// swiftlint:enable type_name
