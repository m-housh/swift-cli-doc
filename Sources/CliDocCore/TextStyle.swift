import Rainbow

public extension TextNode {

  @inlinable
  func color(_ color: NamedColor) -> some TextNode {
    textStyle(.color(color))
  }

  @inlinable
  func color(_ bit8: UInt8) -> some TextNode {
    textStyle(.color(bit8: bit8))
  }

  @inlinable
  func color(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> some TextNode {
    textStyle(.color(rgb: (red, green, blue)))
  }

  @inlinable
  func backgroundColor(_ name: NamedBackgroundColor) -> some TextNode {
    textStyle(.backgroundColor(name))
  }

  @inlinable
  func backgroundColor(_ bit8: UInt8) -> some TextNode {
    textStyle(.backgroundColor(bit8: bit8))
  }

  @inlinable
  func backgroundColor(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> some TextNode {
    textStyle(.backgroundColor(rgb: (red, green, blue)))
  }

  @inlinable
  func textStyle<S: TextStyle>(_ styles: S...) -> some TextNode {
    styles.reduce(render()) { string, style in
      style.render(content: .init(string)).render()
    }
  }

  @inlinable
  func bold() -> some TextNode { textStyle(.bold) }

  @inlinable
  func dim() -> some TextNode { textStyle(.dim) }

  @inlinable
  func italic() -> some TextNode { textStyle(.italic) }

  @inlinable
  func underline() -> some TextNode { textStyle(.underline) }

  @inlinable
  func blink() -> some TextNode { textStyle(.blink) }

  @inlinable
  func strikeThrough() -> some TextNode { textStyle(.strikeThrough) }

}

public protocol TextStyle: TextModifier where Content == TextStyleConfiguration {}

public struct TextStyleConfiguration {
  public let node: any TextNode

  @usableFromInline
  init(_ node: any TextNode) {
    self.node = node
  }
}

public extension TextStyle where Self == StyledText {

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

public extension TextStyle where Self == ColorTextStyle {

  @inlinable
  static func color(_ name: NamedColor) -> Self {
    .init(.foreground(.named(name)))
  }

  @inlinable
  static func color(bit8: UInt8) -> Self {
    .init(.foreground(.bit8(bit8)))
  }

  @inlinable
  static func color(rgb: RGB) -> Self {
    .init(.foreground(.bit24(rgb)))
  }

  @inlinable
  static func backgroundColor(_ name: NamedBackgroundColor) -> Self {
    .init(.background(.named(name)))
  }

  @inlinable
  static func backgroundColor(bit8: UInt8) -> Self {
    .init(.background(.bit8(bit8)))
  }

  @inlinable
  static func backgroundColor(rgb: RGB) -> Self {
    .init(.background(.bit24(rgb)))
  }
}

public struct ColorTextStyle: TextStyle {
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

public struct StyledText: TextStyle {
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
