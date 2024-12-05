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
  func color(red: UInt8, green: UInt8, blue: UInt8) -> some TextNode {
    textStyle(.color(rgb: (red, green, blue)))
  }

  @inlinable
  func textStyle<S: TextStyle>(_ styles: S...) -> some TextNode {
    styles.reduce(render()) { string, style in
      style.render(content: string).render()
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

// TODO: Remove string restraint.
public protocol TextStyle: NodeModifier where Content == String {}

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
  static var swap: Self { .init(.swap) }

  @inlinable
  static var strikeThrough: Self { .init(.strikethrough) }
}

public extension TextStyle where Self == ColorTextStyle {

  @inlinable
  static func color(_ name: NamedColor) -> Self {
    .init(.named(name))
  }

  @inlinable
  static func color(bit8: UInt8) -> Self {
    .init(.bit8(bit8))
  }

  @inlinable
  static func color(rgb: RGB) -> Self {
    .init(.bit24(rgb))
  }
}

public struct ColorTextStyle: TextStyle {
  enum Location {
    case foreground(ColorType)
    case background(ColorType)
  }

  @usableFromInline
  let color: ColorType

  @usableFromInline
  init(_ color: ColorType) {
    self.color = color
  }

  @inlinable
  public func render(content: String) -> some TextNode {
    content.applyingColor(color)
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
  public func render(content: String) -> some TextNode {
    content.applyingStyle(style)
  }
}
