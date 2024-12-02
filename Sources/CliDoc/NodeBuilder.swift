@resultBuilder
public enum NodeBuilder {

  public static func buildPartialBlock<N: Node>(first: N) -> N {
    first
  }

  public static func buildArray<N: Node>(_ components: [N]) -> Group {
    .init(components)
  }

  public static func buildOptional<N: Node>(_ component: N?) -> OptionalNode<N> {
    .init(component: component)
  }

  public static func buildEither<N: Node>(first component: N) -> N {
    component
  }

  public static func buildEither<N: Node>(second component: N) -> N {
    component
  }

  public static func buildPartialBlock<N0: Node, N1: Node>(accumulated: N0, next: N1) -> Group {
    .init([accumulated, next])
  }

}

public struct OptionalNode<N: Node>: Node {
  let component: N?

  public var body: some Node {
    component?.render() ?? ""
  }
}
