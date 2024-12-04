public struct ShellCommand<Content: TextNode>: TextNode {

  @usableFromInline
  var symbol: any TextNode

  @usableFromInline
  var content: Content

  @inlinable
  public init(
    symbol: any TextNode = "$",
    @TextBuilder content: () -> Content
  ) {
    self.symbol = symbol
    self.content = content()
  }

  public var body: some TextNode {
    Group(separator: " ", content: [symbol, content])
  }
}
