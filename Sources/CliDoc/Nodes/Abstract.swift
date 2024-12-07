import CliDocCore

public struct Abstract<Content: TextNode>: TextNode {
  @usableFromInline
  let content: Content

  public init(@TextBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some TextNode {
    content
  }
}
