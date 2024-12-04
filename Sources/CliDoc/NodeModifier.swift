import Rainbow

public protocol NodeModifier {
  // swiftlint:disable type_name
  associatedtype _Body: TextNode
  typealias Body = _Body
  // swiftlint:enable type_name

  associatedtype Content

  @TextBuilder
  func render(content: Content) -> Body
}

public extension NodeModifier {

  func concat<T: NodeModifier>(_ modifier: T) -> ConcatModifier<Self, T> {
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
  public var body: some TextNode {
    modifier.render(content: content)
  }

  @inlinable
  func apply<M: NodeModifier>(_ modifier: M) -> ModifiedNode<Content, ConcatModifier<Modifier, M>> {
    return .init(content: content, modifier: self.modifier.concat(modifier))
  }
}

extension ModifiedNode: NodeRepresentable where Self: TextNode {
  public func render() -> String {
    body.render()
  }
}

public extension TextNode {
  @inlinable
  func modifier<M: NodeModifier>(_ modifier: M) -> ModifiedNode<Self, M> {
    .init(content: self, modifier: modifier)
  }
}
