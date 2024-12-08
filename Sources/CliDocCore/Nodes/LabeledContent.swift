/// A text node that consists of a label and content.
///
///
public struct LabeledContent<Label: TextNode, Content: TextNode>: TextNode {

  @usableFromInline
  let label: Label

  @usableFromInline
  let content: Content

  /// Create a new labeled content text node.
  ///
  /// - Parameters:
  ///   - content: The content portion of the labeled content.
  ///   - label: The label for the content.
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

// MARK: - Style

/// Represents a style for ``LabeledContent``.
///
///
public protocol LabeledContentStyle: TextModifier where Content == LabeledContentConfiguration {}

public extension LabeledContentStyle where Self == HorizontalLabeledContentStyle {

  /// The default labeled content style, which places the label
  /// and content inline with a space as a separator.
  ///
  static var `default`: Self {
    horizontal()
  }

  /// A horizontal labeled content style, which places the label
  /// and content inline with the given separator.
  ///
  /// - Parameters:
  ///   - separator: The horizontal separator to use.
  @inlinable
  static func horizontal(separator: Separator.Horizontal = .space()) -> Self {
    HorizontalLabeledContentStyle(separator: separator)
  }
}

public extension LabeledContentStyle where Self == VerticalLabeledContentStyle {
  /// A vertical labeled content style, which places the label
  /// and content with the given vertical separator.
  ///
  /// - Parameters:
  ///   - separator: The vertical separator to use.
  @inlinable
  static func vertical(separator: Separator.Vertical = .newLine()) -> Self {
    VerticalLabeledContentStyle(separator: separator)
  }
}

/// A labeled content style which places items inline based on a given
/// horizontal separator.
///
/// - See Also: ``LabeledContentStyle/horizontal(separator:)``
///
public struct HorizontalLabeledContentStyle: LabeledContentStyle {

  @usableFromInline
  let separator: Separator.Horizontal

  @usableFromInline
  init(separator: Separator.Horizontal) {
    self.separator = separator
  }

  public func render(content: LabeledContentConfiguration) -> some TextNode {
    HStack {
      content.label
      content.content
    }
    .separator(separator)
  }
}

/// A labeled content style which places items based on a given
/// vertical separator.
///
/// - See Also: ``LabeledContentStyle/vertical(separator:)``
///
public struct VerticalLabeledContentStyle: LabeledContentStyle {

  @usableFromInline
  let separator: Separator.Vertical

  @usableFromInline
  init(separator: Separator.Vertical) {
    self.separator = separator
  }

  public func render(content: LabeledContentConfiguration) -> some TextNode {
    VStack {
      content.label
      content.content
    }
    .separator(separator)
  }
}
