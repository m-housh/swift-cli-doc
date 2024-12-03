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
  public var body: some TextNode {
    content.reduce("") {
      $0 + $1.render() + separator.render()
    }
  }
}
