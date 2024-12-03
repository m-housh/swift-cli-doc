import Rainbow

public protocol NodeModifier {
  // swiftlint:disable type_name
  associatedtype _Body: TextNode
  typealias Body = _Body
  // swiftlint:enable type_name

  associatedtype Content: TextNode

  @TextBuilder
  func render(content: Content) -> Body
}

public extension NodeModifier {

  func concat<T: NodeModifier>(_ modifier: T) -> ConcatModifier<Self, T> {
    print("Concat: \(type(of: modifier))")
    return .init(firstModifier: self, secondModifier: modifier)
  }
}

public struct ConcatModifier<M0: NodeModifier, M1: NodeModifier>: NodeModifier where M1.Content == M0.Body {
  let firstModifier: M0
  let secondModifier: M1

  public func render(content: M0.Content) -> some TextNode {
    let firstOutput = firstModifier.render(content: content)
    return secondModifier.render(content: firstOutput)
  }
}

public struct ModifiedNode<Content: TextNode, Modifier: NodeModifier> {
  @usableFromInline
  let content: Content

  @usableFromInline
  let modifier: Modifier

  @usableFromInline
  init(content: Content, modifier: Modifier) {
    self.content = content
    self.modifier = modifier
  }
}

extension ModifiedNode: TextNode where Modifier.Content == Content {
  public func render() -> String {
    modifier.render(content: content).render()
  }

  @inlinable
  func apply<M: NodeModifier>(_ modifier: M) -> ModifiedNode<Content, ConcatModifier<Modifier, M>> {
    print("ModifiedNode modifier called.")
    return .init(content: content, modifier: self.modifier.concat(modifier))
  }
}

public extension TextNode {
  @inlinable
  func modifier<M: NodeModifier>(_ modifier: M) -> ModifiedNode<Self, M> {
    .init(content: self, modifier: modifier)
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

public extension TextNode {
  @inlinable
  func color(_ color: NamedColor) -> some TextNode {
    modifier(ColorModifier(color: color))
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

public extension TextNode {
  @inlinable
  func style(_ styles: Style...) -> some TextNode {
    modifier(StyleModifier(styles: styles))
  }

  @inlinable
  func style(_ styles: [Style]) -> some TextNode {
    modifier(StyleModifier(styles: styles))
  }
}
