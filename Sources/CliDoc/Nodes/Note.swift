import CliDocCore
import Rainbow

public struct Note<Label: TextNode, Content: TextNode>: TextNode {
  @usableFromInline
  let label: Label

  @usableFromInline
  let content: Content

  @inlinable
  public init(
    @TextBuilder _ label: () -> Label,
    @TextBuilder content: () -> Content
  ) {
    self.label = label()
    self.content = content()
  }

  @inlinable
  public var body: some TextNode {
    style(.default)
  }
}

public extension Note where Label == String {

  @inlinable
  init(
    _ label: @autoclosure () -> String = "NOTE:",
    @TextBuilder content: () -> Content
  ) {
    self.init(label, content: content)
  }

  static func important(
    _ label: String = "IMPORTANT NOTE:",
    @TextBuilder content: () -> Content
  ) -> Self {
    self.init(label, content: content)
  }

  static func seeAlso(
    _ label: String = "SEE ALSO:",
    @TextBuilder content: () -> Content
  ) -> Self {
    self.init(label, content: content)
  }
}

// TODO: Remove the important and see also.
public extension Note where Label == String, Content == String {

  @inlinable
  init(
    _ label: String = "NOTE:",
    content: String
  ) {
    self.init(label) { content }
  }

  static func important(
    _ label: String = "IMPORTANT NOTE:",
    content: String
  ) -> Self {
    self.init(label, content: content)
  }

  static func seeAlso(
    _ label: String = "SEE ALSO:",
    content: String
  ) -> Self {
    self.init(label, content: content)
  }
}

public struct NoteStyleConfiguration {
  @usableFromInline
  let label: any TextNode

  @usableFromInline
  let content: any TextNode

  @usableFromInline
  init(label: any TextNode, content: any TextNode) {
    self.label = label
    self.content = content
  }
}

public extension Note {
  @inlinable
  func style<S: NoteStyle>(_ modifier: S) -> some TextNode {
    modifier.render(content: NoteStyleConfiguration(label: label, content: content))
  }
}

// MARK: - Style

public protocol NoteStyle: TextModifier where Content == NoteStyleConfiguration {}

public extension NoteStyle where Self == DefaultNoteStyle {
  static var `default`: Self {
    DefaultNoteStyle()
  }
}

public struct DefaultNoteStyle: NoteStyle {

  @inlinable
  public func render(content: NoteStyleConfiguration) -> some TextNode {
    HStack {
      content.label.color(.yellow).textStyle(.bold)
      content.content
    }
  }
}
