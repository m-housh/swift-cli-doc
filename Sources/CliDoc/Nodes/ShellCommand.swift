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

  @inlinable
  public var body: some TextNode {
    style(.default)
  }
}

public extension ShellCommand where Content == String {
  @inlinable
  init(
    _ content: String,
    symbol: any TextNode = "$"
  ) {
    self.init(symbol: symbol) { content }
  }
}
