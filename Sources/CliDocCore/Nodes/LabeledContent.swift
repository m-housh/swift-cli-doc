/// A text node that consists of a label and content.
///
///
public struct LabeledContent<Label: TextNode, Content: TextNode>: TextNode {

  @usableFromInline
  let label: Label

  @usableFromInline
  let content: Content

  @inlinable
  public init(
    @TextBuilder _ content: () -> Content,
    @TextBuilder label: () -> Label
  ) {
    self.label = label()
    self.content = content()
  }

  @inlinable
  public var body: some TextNode {
    style(.default)
  }
}

public extension LabeledContent {

  /// Apply the given style to the labeled content.
  ///
  /// - Parameters:
  ///   - style: The labeled content style to apply.
  @inlinable
  func style<S: LabeledContentStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(label: label, content: content))
  }
}

/// Holds the type-erased label and content of a ``LabeledContent`` text node.
///
/// This is used when creating custom styles for the ``LabeledContent``.
///
public struct LabeledContentConfiguration {

  /// The type-erased label text node.
  public let label: any TextNode

  /// The type-erased content text node.
  public let content: any TextNode

  @usableFromInline
  init(label: any TextNode, content: any TextNode) {
    self.label = label
    self.content = content
  }
}

public protocol LabeledContentStyle: TextModifier where Content == LabeledContentConfiguration {}

public extension LabeledContentStyle where Self == HorizontalLabeledContentStyle {

  static var `default`: Self {
    horizontal()
  }

  @inlinable
  static func horizontal(separator: Separator.Horizontal = .space()) -> Self {
    HorizontalLabeledContentStyle(separator: separator)
  }
}

public extension LabeledContentStyle where Self == VerticalLabeledContentStyle {

  @inlinable
  static func vertical(separator: Separator.Vertical = .newLine()) -> Self {
    VerticalLabeledContentStyle(separator: separator)
  }
}

public struct HorizontalLabeledContentStyle: LabeledContentStyle {

  @usableFromInline
  let separator: Separator.Horizontal

  @usableFromInline
  init(separator: Separator.Horizontal) {
    self.separator = separator
  }

  public func render(content: LabeledContentConfiguration) -> some TextNode {
    HStack(separator: separator) {
      content.label
      content.content
    }
  }
}

public struct VerticalLabeledContentStyle: LabeledContentStyle {

  @usableFromInline
  let separator: Separator.Vertical

  @usableFromInline
  init(separator: Separator.Vertical) {
    self.separator = separator
  }

  public func render(content: LabeledContentConfiguration) -> some TextNode {
    VStack(separator: separator) {
      content.label
      content.content
    }
  }
}
