/// A group container holding one or more nodes.
public struct Group: Node {
  var nodes: [any Node]
  var separator: String

  init(_ nodes: [any Node], separator: String = "\n") {
    self.nodes = nodes
    self.separator = separator
  }

  public init(
    separator: String = " ",
    @NodeBuilder build: () -> any Node
  ) {
    let node = build()
    if var group = node as? Self {
      group.separator = separator
      self = group
    } else {
      self.init([node], separator: separator)
    }
  }

  public var body: some Node {
    nodes.map { $0.render() }.joined(separator: separator)
  }

}
