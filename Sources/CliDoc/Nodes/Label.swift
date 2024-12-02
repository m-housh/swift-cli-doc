import Rainbow

public struct Label: Node {

  var color: NamedColor?
  var styles: [Style]
  let node: any Node

  public init(
    _ label: String,
    color: NamedColor? = nil,
    style styles: Style...
  ) {
    self.color = color
    self.node = label
    self.styles = styles
  }

  public init(
    _ label: String,
    color: NamedColor? = nil,
    style styles: [Style] = []
  ) {
    self.color = color
    self.node = label
    self.styles = styles
  }

  public init(
    color: NamedColor? = nil,
    styles: [Style] = [],
    @NodeBuilder _ build: () -> any Node
  ) {
    self.color = color
    self.styles = styles
    self.node = build()
  }

  public var body: some Node {
    let output = styles.reduce(node.render()) { $0.applyingStyle($1) }
    guard let color else { return output }
    return output.applyingColor(color)
  }

}
