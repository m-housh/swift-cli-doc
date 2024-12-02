import Rainbow

public struct Colored: Node {
  var color: NamedColor
  var node: any Node

  public init(
    color: NamedColor,
    @NodeBuilder build: () -> any Node
  ) {
    self.color = color
    self.node = build()
  }

  public var body: some Node {
    node.render().applyingColor(color)
  }
}
