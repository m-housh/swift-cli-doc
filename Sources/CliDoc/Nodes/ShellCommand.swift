import Rainbow

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

public struct ShellCommandConfiguration {
  let symbol: any TextNode
  let content: any TextNode
}

public extension ShellCommand {
  func style<S: ShellCommandStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(symbol: symbol, content: content))
  }
}

// MARK: - Style

public protocol ShellCommandStyle: TextModifier where Self.Content == ShellCommandConfiguration {}

public extension ShellCommandStyle where Self == DefaultShellCommandStyle {
  static var `default`: Self { DefaultShellCommandStyle() }
}

public struct DefaultShellCommandStyle: ShellCommandStyle {

  public func render(content: ShellCommandConfiguration) -> some TextNode {
    HStack {
      content.symbol
      content.content.textStyle(.italic)
    }
  }
}
