import Rainbow

public extension Group {
  func labelColor(_ color: NamedColor) -> some Node {
    modifier(GroupLabelModifier(color: color))
  }
}

public extension Node where Self.Body == Group {
  func labelColor(_ color: NamedColor) -> some Node {
    body.modifier(GroupLabelModifier(color: color))
  }
}

public extension Node where Self == Label {
  func labelColor(_ color: NamedColor) -> some Node {
    modifier(LabelColorModifier(color: color))
  }
}

public extension Note where Label == CliDoc.Label {
  func labelColor(_ color: NamedColor) -> some Node {
    var node = self
    node.label.color = color
    return node
  }
}

struct LabelColorModifier: NodeModifier {
  let color: NamedColor

  func render(content: Label) -> some Node {
    var label = content
    label.color = color
    return label
  }
}

struct GroupLabelModifier: NodeModifier {
  let color: NamedColor

  func render(content: Group) -> some Node {
    var group = content
    applyLabelColor(&group)
    return group
  }

  private func applyLabelColor(_ group: inout Group) {
    for (idx, node) in group.nodes.enumerated() {
      if var label = node as? Label {
        label.color = color
        group.nodes[idx] = label
      } else if var nestedGroup = node as? Group {
        applyLabelColor(&nestedGroup)
        group.nodes[idx] = nestedGroup
      }
    }
  }
}
