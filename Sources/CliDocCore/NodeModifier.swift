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
}

extension ModifiedNode: NodeRepresentable where Self: TextNode {
  @inlinable
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
