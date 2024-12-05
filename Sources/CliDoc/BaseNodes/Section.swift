public struct Section<Header: TextNode, Content: TextNode, Footer: TextNode>: TextNode {

  @usableFromInline
  let header: Header

  @usableFromInline
  let content: Content

  @usableFromInline
  let footer: Footer

  @inlinable
  public init(
    @TextBuilder header: () -> Header,
    @TextBuilder content: () -> Content,
    @TextBuilder footer: () -> Footer
  ) {
    self.header = header()
    self.content = content()
    self.footer = footer()
  }

  public var body: some TextNode {
    style(.default)
  }
}

public extension Section where Footer == Empty {
  @inlinable
  init(
    @TextBuilder header: () -> Header,
    @TextBuilder content: () -> Content
  ) {
    self.init(header: header, content: content) { Empty() }
  }
}

public extension Section where Header == Empty {
  @inlinable
  init(
    @TextBuilder content: () -> Content,
    @TextBuilder footer: () -> Footer
  ) {
    self.init(header: { Empty() }, content: content, footer: footer)
  }
}
