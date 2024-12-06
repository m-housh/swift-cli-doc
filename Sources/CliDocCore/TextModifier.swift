/// A type that can modify a text node before it is rendered.
///
/// This allows you to create custom styles for your text-nodes.
///
public protocol TextModifier {
  // swiftlint:disable type_name
  associatedtype _Body: TextNode
  typealias Body = _Body
  // swiftlint:enable type_name

  associatedtype Content

  /// Apply custom styling to the text node.
  ///
  /// - Parameters:
  ///   - content: The text node to be styled.
  @TextBuilder
  func render(content: Content) -> Body
}
