public struct Note<Label: Node, Content: Node>: Node {

  var separator: String
  var label: Label
  var content: Content

  public init(
    separator: String = " ",
    @NodeBuilder label: () -> Label,
    @NodeBuilder content: () -> Content
  ) {
    self.separator = separator
    self.label = label()
    self.content = content()
  }

  public var body: some Node {
    Group([label, content], separator: separator)
  }
}

public extension Note where Label == CliDoc.Label {

  init(
    separator: String = " ",
    label: String = "NOTE:",
    @NodeBuilder content: () -> Content
  ) {
    self.init(separator: separator, label: { CliDoc.Label(label) }, content: content)
  }
}
