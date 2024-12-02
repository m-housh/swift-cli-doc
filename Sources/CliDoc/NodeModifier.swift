public protocol NodeModifier {
  associatedtype Body: Node
  // swiftlint:disable type_name
  associatedtype _Content: Node
  typealias Content = _Content
  // swiftlint:enable type_name

  func render(content: Content) -> Body
}

public extension NodeModifier {
  func modifier<T: NodeModifier>(
    _ modifier: T
  ) -> ModifiedNode<Self, T> where T.Content == Body {
    .init(content: self, modifier: modifier)
  }
}

public extension Node {

  func modifier<T: NodeModifier>(_ modifier: T) -> ModifiedNode<Self, T> {
    .init(content: self, modifier: modifier)
  }
}

public struct ModifiedNode<Content, Modifier> {
  var content: Content
  var modifier: Modifier
}

extension ModifiedNode: NodeRepresentable where Content: NodeRepresentable,
  Modifier: NodeModifier,
  Modifier.Content == Content
{
  public func render() -> String {
    modifier.render(content: content).render()
  }
}

extension ModifiedNode: Node where Content: Node,
  Modifier: NodeModifier,
  Modifier.Content == Content
{
  public var body: some Node {
    content
  }
}

extension ModifiedNode: NodeModifier where
  Content: NodeModifier,
  Modifier: NodeModifier,
  Content.Body == Modifier.Content,
  Content: Node
{
  public func render(content: Content) -> some Node {
    let body = content.body
    return modifier.render(content: body).render()
  }
}
