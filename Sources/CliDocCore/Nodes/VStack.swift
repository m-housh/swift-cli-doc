/// A vertical stack of text nodes.
///
/// ### Example:
///
/// ```swift
/// let vStack = VStack {
///   "Blob Esquire"
///     .color(.yellow)
///     .bold()
///     .underline()
///
///   "Blob is a super awesome worker.".italic()
/// }
///
/// print(vStack.render())
/// ```
/// ![VStack rendered output](vstack.png)
///
///
public struct VStack: TextNode {
  @usableFromInline
  let content: [any TextNode]

  /// Create a new ``VStack`` with the given text nodes.
  ///
  /// - Parameters:
  ///   - content: The content of the vstack.
  @inlinable
  public init(
    @TextBuilder content: () -> any TextNode
  ) {
    self.content = array(from: content())
  }

  @inlinable
  public var body: some TextNode {
    style(.separator(.newLine(count: 1)))
  }
}

public extension VStack {

  /// Apply the given style to a ``VStack``.
  ///
  /// - Parameters:
  ///   - style: The style to apply to the ``VStack``.
  func style<S: VStackStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(content: content.removingEmptys()))
  }

  /// Apply the given separator to a ``VStack``.
  ///
  /// - Parameters:
  ///   - separator: The vertical separator to use with the ``VStack``.
  func separator(_ separator: Separator.Vertical) -> some TextNode {
    style(.separator(separator))
  }
}

// MARK: - Style

/// Style a ``VStack`` by creating a type that conforms to ``VStackStyle`` and use the
/// style by calling the ``VStack/style(_:)`` method on your instance.
///
public protocol VStackStyle: TextModifier where Content == _StackConfiguration {}

public extension VStackStyle where Self == VStackSeparatorStyle {

  /// Apply the given separator on a ``VStack``.
  ///
  /// - See Also: ``VStack/separator(_:)``
  ///
  /// - Parameters:
  ///   - separator: The vertical separator to use with the ``VStack``.
  static func separator(_ separator: Separator.Vertical) -> Self {
    VStackSeparatorStyle(separator: separator)
  }

}

/// Separate items in a ``VStack`` with a given vertical separator.
///
/// - See Also: ``VStack/separator(_:)``.
///
public struct VStackSeparatorStyle: VStackStyle {
  @usableFromInline
  let separator: Separator.Vertical

  @usableFromInline
  init(separator: Separator.Vertical) {
    self.separator = separator
  }

  @inlinable
  public func render(content: _StackConfiguration) -> some TextNode {
    AnySeparatableStackNode(content: content, separator: separator)
  }
}
