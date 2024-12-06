public protocol TextModifier {
  // swiftlint:disable type_name
  associatedtype _Body: TextNode
  typealias Body = _Body
  // swiftlint:enable type_name

  associatedtype Content

  @TextBuilder
  func render(content: Content) -> Body
}
