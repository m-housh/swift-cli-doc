/// A horizontal group of text nodes.
public struct HStack: TextNode {

  @usableFromInline
  let content: [any TextNode]

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

  func style<S: HStackStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(content: content))
  }

  func separator(_ separator: Separator.Horizontal) -> some TextNode {
    style(.separator(separator))
  }
}

// MARK: - Style

public protocol HStackStyle: TextModifier where Content == StackConfiguration {}

public extension HStackStyle where Self == HStackSeparatorStyle {

  static func separator(_ separator: Separator.Horizontal) -> Self {
    HStackSeparatorStyle(separator: separator)
  }

}

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
