// TODO: Add vertical spacing.
public struct Section<Header: TextNode, Content: TextNode, Footer: TextNode>: TextNode {

  @usableFromInline
  let header: Header

  @usableFromInline
  let content: Content

  @usableFromInline
  let footer: Footer

  @inlinable
  public init(
    @TextBuilder content: () -> Content,
    @TextBuilder header: () -> Header,
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
    @TextBuilder content: () -> Content,
    @TextBuilder header: () -> Header
  ) {
    self.init(content: content, header: header) { Empty() }
  }
}

public extension Section where Header == Empty {
  @inlinable
  init(
    @TextBuilder content: () -> Content,
    @TextBuilder footer: () -> Footer
  ) {
    self.init(content: content, header: { Empty() }, footer: footer)
  }
}

public extension Section where Header == Empty, Footer == Empty {
  @inlinable
  init(
    @TextBuilder content: () -> Content
  ) {
    self.init(content: content, header: { Empty() }, footer: { Empty() })
  }
}

// MARK: - Style

public extension Section {

  @inlinable
  func style<S: SectionStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(header: header, content: content, footer: footer))
  }
}

public struct SectionConfiguration {
  public let header: any TextNode
  public let content: any TextNode
  public let footer: any TextNode

  @usableFromInline
  init(header: any TextNode, content: any TextNode, footer: any TextNode) {
    self.header = header
    self.content = content
    self.footer = footer
  }
}

public protocol SectionStyle: NodeModifier where Content == SectionConfiguration {}

public extension SectionStyle where Self == DefaultSectionStyle {
  static var `default`: Self { DefaultSectionStyle() }
}

public struct DefaultSectionStyle: SectionStyle {

  public func render(content: SectionConfiguration) -> some TextNode {
    VStack(spacing: 2) {
      content.header
      content.content
      content.footer
    }
  }
}
