/// A type that can produce a string to be used as a documentation
/// text node.
public protocol TextNodeRepresentable {

  /// Produces the string output to use as the documentation string.
  func render() -> String
}

/// A type that can produce a string to be used as a documentation
/// text node.
public protocol TextNode: TextNodeRepresentable {
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

extension String: TextNodeRepresentable {
  public func render() -> String { self }
}

extension String: TextNode {
  public var body: some TextNode { self }
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

extension Optional: TextNodeRepresentable where Wrapped: TextNodeRepresentable, Wrapped: TextNode {

  public func render() -> String {
    body.render()
  }
}

// MARK: - Array

extension Array: TextNode where Element: TextNode {
  public var body: some TextNode {
    _NodeContainer(nodes: self)
  }
}

extension Array: TextNodeRepresentable where Element: TextNodeRepresentable, Element: TextNode {
  public func render() -> String {
    body.render()
  }
}
