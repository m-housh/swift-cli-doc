public protocol NodeRepresentable {
  func render() -> String
}

public protocol TextNode: NodeRepresentable {
  // swiftlint:disable type_name
  associatedtype _Body: TextNode
  typealias Body = _Body
  // swiftlint:enable type_name

  var body: Body { get }
}

public extension TextNode {
  func render() -> String {
    body.render()
  }
}

// MARK: - String

extension String: NodeRepresentable {
  public func render() -> String {
    self
  }
}

extension String: TextNode {
  public var body: some TextNode {
    self
  }
}

// MARK: - Optional

extension Optional: TextNode where Wrapped: TextNode {
  @TextBuilder
  public var body: some TextNode {
    switch self {
    case let .some(node):
      node
    case .none:
      Empty()
    }
  }
}

extension Optional: NodeRepresentable where Wrapped: NodeRepresentable, Wrapped: TextNode {

  public func render() -> String {
    body.render()
  }
}

// MARK: - Array

extension Array: TextNode where Element: TextNode {
  public var body: some TextNode {
    NodeContainer(nodes: self)
  }
}

extension Array: NodeRepresentable where Element: NodeRepresentable, Element: TextNode {
  public func render() -> String {
    body.render()
  }
}
