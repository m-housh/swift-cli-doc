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

public struct AnyTextNode: TextNode {
  let makeString: () -> String

  public init<N: TextNode>(_ node: N) {
    self.makeString = node.render
  }

  public var body: some TextNode { makeString() }
}

public extension TextNode {
  func eraseToAnyTextNode() -> AnyTextNode {
    AnyTextNode(self)
  }
}

extension Optional: TextNode where Wrapped: TextNode {
  public var body: some TextNode {
    guard let node = self else { return "".eraseToAnyTextNode() }
    return node.eraseToAnyTextNode()
  }
}

extension Optional: NodeRepresentable where Wrapped: NodeRepresentable {

  public func render() -> String {
    guard let node = self else { return "" }
    return node.render()
  }
}

extension Array: TextNode where Element: TextNode {
  public var body: some TextNode {
    NodeContainer(nodes: self)
  }
}

extension Array: NodeRepresentable where Element: NodeRepresentable {
  public func render() -> String {
    map { $0.render() }.joined()
  }
}
