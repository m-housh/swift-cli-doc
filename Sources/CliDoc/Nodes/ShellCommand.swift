import CliDocCore
import Rainbow

/// Represents a shell command text node, with a symbol and the content of
/// the command.  Used for displaying example shell commands.
///
///
public struct ShellCommand<Content: TextNode, Symbol: TextNode>: TextNode {

  @usableFromInline
  let symbol: Symbol

  @usableFromInline
  let content: Content

  /// Create a new shell command with the given content and symbol.
  ///
  /// - Parameters:
  ///   - content: The shell command to display.
  ///   - symbol: The symbol to use in front of the shell command.
  @inlinable
  public init(
    @TextBuilder content: () -> Content,
    @TextBuilder symbol: () -> Symbol
  ) {
    self.symbol = symbol()
    self.content = content()
  }

  /// Create a new shell command with the given content and symbol.
  ///
  /// - Parameters:
  ///   - symbol: The symbol to use in front of the shell command.
  ///   - content: The shell command to display.
  @inlinable
  public init(
    symbol: @autoclosure () -> Symbol,
    @TextBuilder content: () -> Content
  ) {
    self.init(content: content, symbol: symbol)
  }

  @inlinable
  public var body: some TextNode {
    style(.default)
  }
}

public extension ShellCommand where Content == String, Symbol == String {
  /// Create a new shell command with the given content and symbol.
  ///
  /// - Parameters:
  ///   - content: The shell command to display.
  ///   - symbol: The symbol to use in front of the shell command.
  @inlinable
  init(
    _ content: @autoclosure () -> String,
    symbol: @autoclosure () -> String = "$"
  ) {
    self.init(content: content, symbol: symbol)
  }
}

public struct ShellCommandConfiguration {
  public let symbol: any TextNode

  public let content: any TextNode

  @usableFromInline
  init(symbol: any TextNode, content: any TextNode) {
    self.symbol = symbol
    self.content = content
  }
}

public extension ShellCommand {
  @inlinable
  func style<S: ShellCommandStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(symbol: symbol, content: content))
  }
}

// MARK: - Style

public protocol ShellCommandStyle: TextModifier where Content == ShellCommandConfiguration {}

public extension ShellCommandStyle where Self == DefaultShellCommandStyle {
  static var `default`: Self { DefaultShellCommandStyle() }
}

public struct DefaultShellCommandStyle: ShellCommandStyle {

  public func render(content: ShellCommandConfiguration) -> some TextNode {
    HStack {
      content.symbol
      content.content.italic()
    }
  }
}
