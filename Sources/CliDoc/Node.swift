public protocol NodeRepresentable {
  func render() -> String
}

public protocol Node: NodeRepresentable {
  // swiftlint:disable type_name
  associatedtype _Body: Node
  typealias Body = _Body
  // swiftlint:enable type_name

  @NodeBuilder
  var body: Body { get }
}

public extension Node {
  func render() -> String {
    body.render()
  }
}

extension String: NodeRepresentable {
  public func render() -> String { self }
}

extension String: Node {
  public var body: some Node { self }
}
