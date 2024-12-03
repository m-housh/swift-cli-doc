import Rainbow

public extension TextNode {

  @inlinable
  func labelStyle(color: NamedColor? = nil, styles: Style...) -> some TextNode {
    labelStyle(color: color, styles: styles)
  }

  @inlinable
  func labelStyle(color: NamedColor? = nil, styles: [Style]) -> some TextNode {
    modifier(LabelStyle(color: color, styles: styles))
  }
}

public extension ModifiedNode where Self: TextNode {
  @inlinable
  func labelStyle<M: NodeModifier>(
    color: NamedColor? = nil, styles: Style...
  ) -> some TextNode where
    Modifier.Body == Content,
    M.Content == Modifier.Body
  {
    apply(LabelStyle<Content>(color: color, styles: styles))
  }
}

public struct LabelStyle<Content: TextNode>: NodeModifier {
  @usableFromInline
  let color: NamedColor?

  @usableFromInline
  let styles: [Style]

  @usableFromInline
  init(color: NamedColor? = nil, styles: [Style] = []) {
    self.color = color
    self.styles = styles
  }

  @inlinable
  public func render(content: Content) -> some TextNode {
    print("Handling node: \(type(of: content))")
    return handleNode(content)
  }

  @TextBuilder
  @usableFromInline
  func handleNode<N: TextNode>(_ content: N) -> some TextNode {
    if let label = content as? Label {
      handleLabel(label)
    } else if let container = content as? NodeContainer {
      handleContainer(container)
    } else if let group = content as? Group {
      handleGroup(group)
    } else {
      content
    }
  }

  @usableFromInline
  func handleLabel(_ label: Label) -> Label {
    var label = label
    if let color {
      label.node = label.node.color(color)
    }
    label.node = label.node.style(styles)
    return label
  }

  @usableFromInline
  func handleContainer(_ container: NodeContainer) -> NodeContainer {
    var container = container
    for (idx, node) in container.nodes.enumerated() {
      container.nodes[idx] = handleNode(node)
    }
    return container
  }

  @usableFromInline
  func handleGroup(_ group: Group) -> Group {
    var group = group
    for (idx, node) in group.content.enumerated() {
      group.content[idx] = handleNode(node)
    }
    return group
  }
}
