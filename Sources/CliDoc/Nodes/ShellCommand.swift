public struct ShellCommand<Content: Node>: Node {

  public var symbol: String
  public var content: Content

  public init(
    symbol: String = "$",
    @NodeBuilder content: () -> Content
  ) {
    self.symbol = symbol
    self.content = content()
  }

  public var body: some Node {
    Group(separator: " ") {
      symbol
      content
    }
  }
}
