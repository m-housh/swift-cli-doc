/// A horizontal stack of text nodes.
///
/// ### Example:
///
/// ```swift
/// let note = HStack {
///   "NOTE:".color(.cyan).bold()
///   "This is my super cool note".italic()
/// }
///
/// print(note.render())
/// ```
///
/// ![HStack example](hstack.png)
///
///
public struct HStack: TextNode {

  @usableFromInline
  let content: [any TextNode]

  /// Create a new ``HStack`` with the given text nodes.
  ///
  /// - Parameters:
  ///   - content: The content of the hstack.
  @inlinable
  public init(
    @TextBuilder content: () -> any TextNode
  ) {
    self.content = array(from: content())
  }

  @inlinable
  public var body: some TextNode {
    style(.separator(.space()))
  }
}

public extension HStack {
  /// Apply the given style to a ``HStack``.
  ///
  /// - Parameters:
  ///   - style: The style to apply to the ``HStack``.
  func style<S: HStackStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(content: content))
  }

  /// Apply the given separator to a ``HStack``.
  ///
  /// - Parameters:
  ///   - separator: The horizontal separator to use with the ``HStack``.
  func separator(_ separator: Separator.Horizontal) -> some TextNode {
    style(.separator(separator))
  }
}

// MARK: - Style

/// Style a ``HStack`` by creating a type that conforms to ``HStackStyle`` and use the
/// style by calling the ``HStack/style(_:)`` method on your instance.
///
public protocol HStackStyle: TextModifier where Content == StackConfiguration {}

public extension HStackStyle where Self == HStackSeparatorStyle {
  /// Apply the given separator on a ``HStack``.
  ///
  /// - See Also: ``HStack/separator(_:)``
  ///
  /// - Parameters:
  ///   - separator: The vertical separator to use with the ``HStack``.
  static func separator(_ separator: Separator.Horizontal) -> Self {
    HStackSeparatorStyle(separator: separator)
  }

}

/// Separate items in a ``HStack`` with a given horizontal separator.
///
/// - See Also: ``HStack/separator(_:)``.
///
public struct HStackSeparatorStyle: HStackStyle {
  @usableFromInline
  let separator: Separator.Horizontal

  @usableFromInline
  init(separator: Separator.Horizontal) {
    self.separator = separator
  }

  @inlinable
  public func render(content: StackConfiguration) -> some TextNode {
    AnySeparatableStackNode(content: content, separator: separator)
  }
}
