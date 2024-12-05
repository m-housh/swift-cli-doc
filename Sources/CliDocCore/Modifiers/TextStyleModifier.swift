import Rainbow

public extension TextNode {
  @inlinable
  func textStyle(_ styles: Style...) -> some TextNode {
    modifier(StyleModifier(styles: styles))
  }

  @inlinable
  func textStyle(_ styles: [Style]) -> some TextNode {
    modifier(StyleModifier(styles: styles))
  }
}

@usableFromInline
struct StyleModifier<Content: TextNode>: NodeModifier {

  @usableFromInline
  let styles: [Style]

  @usableFromInline
  init(styles: [Style]) {
    self.styles = styles
  }

  @usableFromInline
  func render(content: Content) -> some TextNode {
    styles.reduce(content.render()) {
      $0.applyingStyle($1)
    }
  }
}
