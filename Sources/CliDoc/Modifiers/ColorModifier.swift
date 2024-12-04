import Rainbow

public extension TextNode {
  @inlinable
  func color(_ color: NamedColor) -> some TextNode {
    modifier(ColorModifier(color: color))
  }
}

@usableFromInline
struct ColorModifier<Content: TextNode>: NodeModifier {
  @usableFromInline
  let color: NamedColor

  @usableFromInline
  init(color: NamedColor) {
    self.color = color
  }

  @usableFromInline
  func render(content: Content) -> some TextNode {
    content.render().applyingColor(color)
  }
}
