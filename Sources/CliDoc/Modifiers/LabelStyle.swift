import Rainbow

// public extension Node {
//   func labelStyel(_ styles: Style...) -> any Node {}
// }

public extension Node where Self == Label {
  func labelStyle(_ styles: Style...) -> some Node {
    modifier(LabelStyleModifier(styles: styles))
  }
}

struct LabelStyleModifier: NodeModifier {
  let styles: [Style]

  func render(content: Label) -> some Node {
    var label = content
    label.styles = styles
    return label
  }
}
