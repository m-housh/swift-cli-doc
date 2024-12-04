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
    VStack {
      content.header
      content.content
      content.footer.textStyle(.italic)
    }
  }
}
