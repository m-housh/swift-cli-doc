public struct Group: TextNode {
  @usableFromInline
  var content: [any TextNode]

  @usableFromInline
  var separator: any TextNode

  @inlinable
  public init(
    separator: any TextNode = "\n",
    content: [any TextNode]
  ) {
    self.content = content
    self.separator = separator
  }

  @inlinable
  public init(
    separator: any TextNode = "\n",
    @TextBuilder content: () -> any TextNode
  ) {
    // Check if the content is a NodeContainer, typically is when
    // using the TextBuilder with more than one text node.
    //
    // We need to take over the contents, so we can control the separator.
    let content = content()
    if let many = content as? NodeContainer {
      self.content = many.nodes
    } else {
      // We didn't get a NodeContainer, so fallback to just storing
      // the content.
      self.content = [content]
    }
    self.separator = separator
  }

  @inlinable
  public var body: some TextNode {
    content.map { $0.render() }.joined(separator: separator.render())
  }
}
