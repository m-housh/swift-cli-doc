/// A vertical stack of text nodes.
///
///
public struct VStack: TextNode {
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
    style(.separator(.newLine(count: 1)))
  }
}

public extension VStack {

  func style<S: VStackStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(content: content.removingEmptys()))
  }

  func separator(_ separator: Separator.Vertical) -> some TextNode {
    style(.separator(separator))
  }
}

// MARK: - Style

public protocol VStackStyle: TextModifier where Content == StackConfiguration {}

public extension VStackStyle where Self == VStackSeparatorStyle {

  static func separator(_ separator: Separator.Vertical) -> Self {
    VStackSeparatorStyle(separator: separator)
  }

}

public struct VStackSeparatorStyle: VStackStyle {
  @usableFromInline
  let separator: Separator.Vertical

  @usableFromInline
  init(separator: Separator.Vertical) {
    self.separator = separator
  }

  @inlinable
  public func render(content: StackConfiguration) -> some TextNode {
    AnySeparatableStackNode(content: content, separator: separator)
  }
}
