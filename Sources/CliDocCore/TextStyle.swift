import Rainbow

public extension TextNode {

  /// Apply coloring to a text node.
  ///
  /// - Parameters:
  ///   - color: The color to apply to the text node.
  @inlinable
  func color(_ color: NamedColor) -> some TextNode {
    textStyle(_ColorTextStyle(.foreground(.named(color))))
  }

  /// Apply coloring to a text node.
  ///
  /// - Parameters:
  ///   - bit8: The color to apply to the text node.
  @inlinable
  func color(_ bit8: UInt8) -> some TextNode {
    textStyle(_ColorTextStyle(.foreground(.bit8(bit8))))
  }

  /// Apply coloring to a text node using RGB.
  ///
  /// - Parameters:
  ///   - red: The red color to apply to the text node.
  ///   - green: The green color to apply to the text node.
  ///   - blue: The blue color to apply to the text node.
  @inlinable
  func color(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> some TextNode {
    textStyle(_ColorTextStyle(.foreground(.bit24((red, green, blue)))))
  }

  /// Apply background coloring to a text node.
  ///
  /// - Parameters:
  ///   - color: The color to apply to the text node.
  @inlinable
  func backgroundColor(_ color: NamedBackgroundColor) -> some TextNode {
    textStyle(_ColorTextStyle(.background(.named(color))))
  }

  /// Apply background coloring to a text node.
  ///
  /// - Parameters:
  ///   - bit8: The color to apply to the text node.
  @inlinable
  func backgroundColor(_ bit8: UInt8) -> some TextNode {
    textStyle(_ColorTextStyle(.background(.bit8(bit8))))
  }

  /// Apply background coloring to a text node using RGB.
  ///
  /// - Parameters:
  ///   - red: The red color to apply to the text node.
  ///   - green: The green color to apply to the text node.
  ///   - blue: The blue color to apply to the text node.
  @inlinable
  func backgroundColor(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> some TextNode {
    textStyle(_ColorTextStyle(.background(.bit24((red, green, blue)))))
  }

  /// Apply styles to a text node.
  ///
  /// - Parameters:
  ///   - styles: The styles to apply.
  @inlinable
  func textStyle<S: TextStyle>(_ styles: S...) -> some TextNode {
    styles.reduce(render()) { string, style in
      style.render(content: .init(string)).render()
    }
  }

  /// Apply a bold text style to a text node.
  @inlinable
  func bold() -> some TextNode { textStyle(.bold) }

  /// Apply a dim text style to a text node.
  @inlinable
  func dim() -> some TextNode { textStyle(.dim) }

  /// Apply an italic text style to a text node.
  @inlinable
  func italic() -> some TextNode { textStyle(.italic) }

  /// Apply an underline text style to a text node.
  @inlinable
  func underline() -> some TextNode { textStyle(.underline) }

  /// Apply a blink text style to a text node.
  @inlinable
  func blink() -> some TextNode { textStyle(.blink) }

  /// Apply a strike-through text style to a text node.
  @inlinable
  func strikeThrough() -> some TextNode { textStyle(.strikeThrough) }

}

/// A general purpose way of styling a text node.
///
/// This is generally used for applying styling that can work with any text node.
///
/// Most of the time you will want to customize styles for a text node's type instead
/// of using this.
public protocol TextStyle: TextModifier where Content == TextStyleConfiguration {}

/// A type-erased text node that can be used for creating
/// custom styles.
///
/// This is generally used to change the style of text nodes as
/// a whole, such as applying text colors or styling such as `bold`.
///
/// Most of the time you will want to customize styles for a text node's
/// type, instead of using this.
///
public struct TextStyleConfiguration {
  public let node: any TextNode

  @usableFromInline
  init(_ node: any TextNode) {
    self.node = node
  }
}

public extension TextStyle where Self == _StyledText {

  @inlinable
  static var bold: Self { .init(.bold) }

  @inlinable
  static var dim: Self { .init(.dim) }

  @inlinable
  static var italic: Self { .init(.italic) }

  @inlinable
  static var underline: Self { .init(.underline) }

  @inlinable
  static var blink: Self { .init(.blink) }

  @inlinable
  static var strikeThrough: Self { .init(.strikethrough) }
}

// swiftlint:disable type_name
public struct _ColorTextStyle: TextStyle {
  @usableFromInline
  enum Style {
    case foreground(ColorType)
    case background(BackgroundColorType)
  }

  @usableFromInline
  let style: Style

  @usableFromInline
  init(_ style: Style) {
    self.style = style
  }

  @inlinable
  public func render(content: TextStyleConfiguration) -> some TextNode {
    switch style {
    case let .foreground(color):
      return content.node.render().applyingColor(color)
    case let .background(color):
      return content.node.render().applyingBackgroundColor(color)
    }
  }
}

public struct _StyledText: TextStyle {
  @usableFromInline
  let style: Style

  @usableFromInline
  init(_ style: Style) {
    self.style = style
  }

  @inlinable
  public func render(content: TextStyleConfiguration) -> some TextNode {
    content.node.render().applyingStyle(style)
  }
}

// swiftlint:enable type_name
