import Rainbow

public struct ShellCommandConfiguration {
  let symbol: any TextNode
  let content: any TextNode
}

public extension ShellCommand {
  func style<S: ShellCommandStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(symbol: symbol, content: content))
  }
}

public protocol ShellCommandStyle: NodeModifier where Self.Content == ShellCommandConfiguration {}

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
