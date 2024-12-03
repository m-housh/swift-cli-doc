import Rainbow

public extension TextNode {
  func labelStyle<C: TextNode>(color: NamedColor? = nil, styles: [Style] = []) -> some TextNode where Self == Label<C> {
    modifier(LabelStyle(color: color, styles: styles))
  }

  func labelStyle<C: TextNode>(color: NamedColor? = nil, styles: Style...) -> some TextNode where Self == Label<C> {
    labelStyle(color: color, styles: styles)
  }
}

public struct LabelStyle<C: TextNode>: NodeModifier {
  @usableFromInline
  let color: NamedColor?

  @usableFromInline
  let styles: [Style]

  @usableFromInline
  init(color: NamedColor? = nil, styles: [Style] = []) {
    self.color = color
    self.styles = styles
  }

  @inlinable
  public func render(content: Label<C>) -> some TextNode {
    var label: any TextNode = content.content
    label = label.style(styles)
    if let color {
      label = label.color(color)
    }
    return Label { label.eraseToAnyTextNode() }
  }
}
