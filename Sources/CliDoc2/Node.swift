import Rainbow

public protocol Node {
  func render() -> String
}

extension String: Node {
  public func render() -> String {
    self
  }
}

@resultBuilder
enum NodeBuilder {

  public static func buildPartialBlock<N: Node>(first: N) -> N {
    first
  }

  static func buildPartialBlock<N0: Node, N1: Node>(accumulated: N0, next: N1) -> ManyNode {
    .init(nodes: [accumulated, next])
  }

  public static func buildArray<N: Node>(_ components: [N]) -> ManyNode {
    .init(nodes: components)
  }

  static func buildBlock<N: Node>(_ components: N...) -> ManyNode {
    .init(nodes: components)
  }

  static func buildEither<N: Node>(first component: N) -> N {
    component
  }

  static func buildEither<N: Node>(second component: N) -> N {
    component
  }

  static func buildOptional<N: Node>(_ component: N?) -> any Node {
    component
  }

}

extension Optional: Node where Wrapped: Node {
  public func render() -> String {
    guard let node = self else { return "" }
    return node.render()
  }
}

struct ManyNode: Node {

  var nodes: [any Node]

  init(nodes: [any Node]) {
    self.nodes = nodes.reduce(into: [any Node]()) { array, next in
      if let many = next as? ManyNode {
        array += many.nodes
      } else {
        array.append(next)
      }
    }
  }

  func render() -> String {
    nodes.reduce("") { $0 + $1.render() }
  }
}

struct Group: Node {
  var content: [any Node]
  var separator: any Node

  init(
    content: [any Node],
    separator: any Node = "\n"
  ) {
    self.content = content
    self.separator = separator
  }

  init(
    separator: any Node = "\n",
    @NodeBuilder content: () -> any Node
  ) {
    let content = content()
    if let many = content as? ManyNode {
      self.content = many.nodes
    } else {
      self.content = [content]
    }
    self.separator = separator
  }

  func render() -> String {
    content.reduce("") {
      $0 + $1.render() + separator.render()
    }
  }
}

struct ColorNode: Node {
  let color: NamedColor
  let node: any Node

  func render() -> String {
    node.render().applyingColor(color)
  }
}

extension Node {
  func color(_ color: NamedColor) -> some Node {
    ColorNode(color: color, node: self)
  }
}

struct Label: Node {
  var node: any Node

  init(@NodeBuilder _ content: () -> any Node) {
    self.node = content()
  }

  func render() -> String {
    node.render()
  }
}

struct Note: Node {
  var label: any Node
  var content: any Node
  var separator: any Node = " "

  init(
    separator: any Node = " ",
    @NodeBuilder _ label: () -> any Node,
    @NodeBuilder content: () -> any Node
  ) {
    self.separator = separator
    self.label = label()
    self.content = content()
  }

  func render() -> String {
    Group(content: [label, content], separator: separator).render()
  }
}
