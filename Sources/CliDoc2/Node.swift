import Rainbow

public protocol TextNode {
  func render() -> String
}

public extension TextNode {
  func map<T: TextNode>(_ transform: (Self) -> T) -> T {
    transform(self)
  }
}

extension String: TextNode {
  public func render() -> String {
    self
  }
}

extension Optional: TextNode where Wrapped: TextNode {
  public func render() -> String {
    guard let node = self else { return "" }
    return node.render()
  }
}
