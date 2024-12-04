import Rainbow

public struct NoteStyleConfiguration {
  let label: any TextNode
  let content: any TextNode
}

public extension Note {
  func noteStyle<S: NoteStyleModifier>(_ modifier: S) -> some TextNode {
    modifier.render(content: .init(label: label, content: content))
  }
}

public protocol NoteStyleModifier: NodeModifier where Content == NoteStyleConfiguration {}

public extension NoteStyleModifier where Self == DefaultNoteStyle {
  static var `default`: Self {
    DefaultNoteStyle()
  }
}

public struct DefaultNoteStyle: NoteStyleModifier {

  public func render(content: NoteStyleConfiguration) -> some TextNode {
    HStack {
      content.label.color(.yellow).style(.bold)
      content.content
    }
  }
}
