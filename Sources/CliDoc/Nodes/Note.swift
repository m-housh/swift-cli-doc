import Rainbow

public struct Note<Label: TextNode, Content: TextNode>: TextNode {
  @usableFromInline
  let label: Label

  @usableFromInline
  let content: Content

  @usableFromInline
  var separator: any TextNode = " "

  @inlinable
  public init(
    separator: any TextNode = " ",
    @TextBuilder _ label: () -> Label,
    @TextBuilder content: () -> Content
  ) {
    self.separator = separator
    self.label = label()
    self.content = content()
  }

  @inlinable
  public var body: some TextNode {
    Group(separator: separator, content: [label, content])
  }
}

public extension Note where Label == String {

  @inlinable
  init(
    separator: any TextNode = " ",
    _ label: String = "NOTE:".yellow.bold,
    @TextBuilder content: () -> Content
  ) {
    self.separator = separator
    self.label = label
    self.content = content()
  }

  static func important(
    separator: any TextNode = " ",
    _ label: String = "IMPORTANT NOTE:".red.underline,
    @TextBuilder content: () -> Content
  ) -> Self {
    self.init(separator: separator, label, content: content)
  }

  static func seeAlso(
    separator: any TextNode = " ",
    _ label: String = "SEE ALSO:".yellow.bold,
    @TextBuilder content: () -> Content
  ) -> Self {
    self.init(separator: separator, label, content: content)
  }
}
