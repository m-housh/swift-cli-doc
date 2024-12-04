import Rainbow

public struct Note<Label: TextNode, Content: TextNode>: TextNode {
  @usableFromInline
  let label: Label

  @usableFromInline
  let content: Content

  @inlinable
  public init(
    @TextBuilder _ label: () -> Label,
    @TextBuilder content: () -> Content
  ) {
    self.label = label()
    self.content = content()
  }

  @inlinable
  public var body: some TextNode {
    noteStyle(.default)
  }
}

public extension Note where Label == String {

  @inlinable
  init(
    _ label: String = "NOTE:",
    @TextBuilder content: () -> Content
  ) {
    self.label = label
    self.content = content()
  }

  static func important(
    _ label: String = "IMPORTANT NOTE:",
    @TextBuilder content: () -> Content
  ) -> Self {
    self.init(label, content: content)
  }

  static func seeAlso(
    _ label: String = "SEE ALSO:",
    @TextBuilder content: () -> Content
  ) -> Self {
    self.init(label, content: content)
  }
}

public extension Note where Label == String, Content == String {

  @inlinable
  init(
    _ label: String = "NOTE:",
    content: String
  ) {
    self.init(label) { content }
  }

  static func important(
    _ label: String = "IMPORTANT NOTE:",
    content: String
  ) -> Self {
    self.init(label, content: content)
  }

  static func seeAlso(
    _ label: String = "SEE ALSO:",
    content: String
  ) -> Self {
    self.init(label, content: content)
  }
}
