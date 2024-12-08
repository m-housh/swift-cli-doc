/// A section of text nodes, that can contain a header, content, and footer.
///
/// This allows nodes to be grouped and styled together.
///
/// **Example:**
///
/// ```swift
/// let mySection = Section {
///   "My super awesome section content"
/// } header: {
///   "Awesome"
/// } footer: {
///   "Note: this is super awesome".italic()
/// }
/// ```
///
/// **Styling Sections:**
///
/// You can style a section by creating a custom ``SectionStyle``, which gives you the
/// opportunity to arrange and style the nodes within the section.
///
/// ```swift
/// struct MySectionStyle: SectionStyle {
///   func render(content: SectionConfiguration) -> some TextNode {
///     VStack(separator: .newLine(count: 2)) {
///       content.header
///         .color(.green)
///         .bold()
///         .underline()
///       content.content
///       content.footer.italic()
///     }
///   }
/// }
///
/// mySection.style(MySectionStyle())
///
/// print(mySection.render())
/// ```
///
/// _Below is an image of the output from the `mySection.render()` above._
///
/// ![Custom section style image](section.png)
///
public struct Section<Header: TextNode, Content: TextNode, Footer: TextNode>: TextNode {

  @usableFromInline
  let header: Header

  @usableFromInline
  let content: Content

  @usableFromInline
  let footer: Footer

  /// Create a new section with the given content, header, and footer.
  ///
  /// - Parameters:
  ///   - content: The content of the section.
  ///   - header: The header for the section.
  ///   - footer: The footer for the section.
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
  /// Create a new section with the given content and header, with no footer.
  ///
  /// - Parameters:
  ///   - content: The content of the section.
  ///   - header: The header for the section.
  @inlinable
  init(
    @TextBuilder content: () -> Content,
    @TextBuilder header: () -> Header
  ) {
    self.init(content: content, header: header) { Empty() }
  }
}

public extension Section where Header == Empty {
  /// Create a new section with the given content and footer, with no header.
  ///
  /// - Parameters:
  ///   - content: The content of the section.
  ///   - footer: The footer for the section.
  @inlinable
  init(
    @TextBuilder content: () -> Content,
    @TextBuilder footer: () -> Footer
  ) {
    self.init(content: content, header: { Empty() }, footer: footer)
  }
}

// MARK: - Style

public extension Section {

  /// Style a ``Section`` using the given ``SectionStyle``.
  ///
  /// - Parameters:
  ///   - style: The section style to use.
  @inlinable
  func style<S: SectionStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(header: header, content: content, footer: footer))
  }
}

/// Holds the type-erased values of a ``Section``, that can be used to create
/// custom styling for a section.
public struct SectionConfiguration {
  /// The type-erased header of a section.
  public let header: any TextNode

  /// The type-erased content of a section.
  public let content: any TextNode

  /// The type-erased footer of a section.
  public let footer: any TextNode

  @usableFromInline
  init(header: any TextNode, content: any TextNode, footer: any TextNode) {
    self.header = header
    self.content = content
    self.footer = footer
  }
}

/// Used to declare a custom style for a ``Section``. Your custom section style
/// must conform to this protocol.
///
public protocol SectionStyle: TextModifier where Content == SectionConfiguration {}

public extension SectionStyle where Self == DefaultSectionStyle {

  /// Style a section using the default style, separating the content with
  /// a new line between the elements.
  static var `default`: Self { `default`(separator: .newLine(count: 2)) }

  /// Style a section using the default style, separating the content with
  /// given separator between the elements.
  ///
  /// - Parameters:
  ///   - separator: The separator to use to separate elements in a section.
  static func `default`(separator: Separator.Vertical) -> Self {
    DefaultSectionStyle(separator: separator)
  }
}

/// Represents the default ``SectionStyle``, which arranges the nodes in
/// a ``VStack``, using the separator passed in.
///
/// - SeeAlso: ``SectionStyle/default(separator:)``
///
public struct DefaultSectionStyle: SectionStyle {

  @usableFromInline
  let separator: Separator.Vertical

  public func render(content: SectionConfiguration) -> some TextNode {
    VStack {
      content.header
      content.content
      content.footer
    }
    .style(.separator(separator))
  }
}
