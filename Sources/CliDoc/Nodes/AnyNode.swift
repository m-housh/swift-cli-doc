/// A type erased node.
public struct AnyNode: Node {
  private var renderNode: () -> String

  public init<N: NodeRepresentable>(_ node: N) {
    self.renderNode = node.render
  }

  public var body: some Node {
    renderNode()
  }
}

public extension Node {
  func eraseToAnyNode() -> AnyNode {
    .init(self)
  }
}
