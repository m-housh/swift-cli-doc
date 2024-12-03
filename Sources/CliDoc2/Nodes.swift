public struct AnyTextNode: TextNode {
  @usableFromInline
  var makeContent: () -> String

  @inlinable
  public init<T: TextNode>(_ node: T) {
    self.makeContent = node.render
  }

  @inlinable
  public func render() -> String {
    makeContent()
  }
}

public extension TextNode {
  func eraseToAnyTextNode() -> AnyTextNode {
    .init(self)
  }
}

public struct Group: TextNode {
  @usableFromInline
  var content: [any TextNode]

  @usableFromInline
  var separator: any TextNode

  @usableFromInline
  init(
    content: [any TextNode],
    separator: any TextNode = "\n"
  ) {
    self.content = content
    self.separator = separator
  }

  @inlinable
  public init(
    separator: any TextNode = "\n",
    @TextBuilder content: () -> any TextNode
  ) {
    let content = content()
    if let many = content as? NodeContainer {
      self.content = many.nodes
    } else {
      self.content = [content]
    }
    self.separator = separator
  }

  @inlinable
  public func render() -> String {
    content.reduce("") {
      $0 + $1.render() + separator.render()
    }
  }
}

public struct Label: TextNode {
  @usableFromInline
  var node: any TextNode

  @inlinable
  public init(@TextBuilder _ content: () -> any TextNode) {
    self.node = content()
  }

  @inlinable
  public init(_ node: any TextNode) {
    self.node = node
  }

  @inlinable
  public func render() -> String {
    node.render()
  }
}

public struct Note: TextNode {
  @usableFromInline
  var label: any TextNode

  @usableFromInline
  var content: any TextNode

  @usableFromInline
  var separator: any TextNode = " "

  @inlinable
  public init(
    separator: any TextNode = " ",
    @TextBuilder _ label: () -> any TextNode,
    @TextBuilder content: () -> any TextNode
  ) {
    self.separator = separator
    self.label = label()
    self.content = content()
  }

  @inlinable
  public func render() -> String {
    Group(content: [label, content], separator: separator).render()
  }
}
