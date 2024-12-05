import Rainbow

public struct ExampleSection<Header: TextNode, Label: TextNode>: TextNode {
  public typealias Example = (label: String, example: String)

  @usableFromInline
  let configuration: ExampleSectionConfiguration

  @inlinable
  public init(
    examples: [Example],
    @TextBuilder title: () -> Header,
    @TextBuilder label: () -> Label
  ) {
    self.configuration = .init(
      title: title(),
      label: label(),
      examples: examples
    )
  }

  @inlinable
  public init(
    _ title: @autoclosure () -> Header,
    label: @autoclosure () -> Label,
    examples: [Example]
  ) {
    self.init(
      examples: examples,
      title: title,
      label: label
    )
  }

  @inlinable
  public var body: some TextNode {
    style(.default())
  }
}

/// The type-erased configuration of an ``ExampleSection``
public struct ExampleSectionConfiguration {
  @usableFromInline
  let title: any TextNode

  @usableFromInline
  let label: any TextNode

  @usableFromInline
  let examples: [ExampleSection.Example]

  @usableFromInline
  init(title: any TextNode, label: any TextNode, examples: [ExampleSection.Example]) {
    self.title = title
    self.label = label
    self.examples = examples
  }
}

// MARK: - Style

public extension ExampleSection {

  func style<S: ExampleSectionStyle>(_ style: S) -> some TextNode {
    style.render(content: configuration)
  }

  func exampleStyle<S: ExampleStyle>(_ style: S) -> some TextNode {
    DefaultExamplesStyle(exampleStyle: style).render(content: configuration)
  }
}

extension Array where Element == ExampleSection.Example {
  func exampleStyle<S: ExampleStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(examples: self))
  }
}

public struct ExampleConfiguration {
  @usableFromInline
  let examples: [ExampleSection.Example]

  @usableFromInline
  init(examples: [ExampleSection.Example]) {
    self.examples = examples
  }
}

public protocol ExampleSectionStyle: NodeModifier where Content == ExampleSectionConfiguration {}
public protocol ExampleStyle: NodeModifier where Content == ExampleConfiguration {}

public extension ExampleSectionStyle where Self == DefaultExamplesStyle {
  static func `default`(exampleStyle: any ExampleStyle = .default) -> Self {
    DefaultExamplesStyle(exampleStyle: exampleStyle)
  }
}

public extension ExampleStyle where Self == DefaultExampleStyle {
  static var `default`: Self {
    DefaultExampleStyle()
  }
}

public struct DefaultExamplesStyle: ExampleSectionStyle {

  @usableFromInline
  let exampleStyle: any ExampleStyle

  @inlinable
  public init(exampleStyle: any ExampleStyle = .default) {
    self.exampleStyle = exampleStyle
  }

  @inlinable
  public func render(content: ExampleSectionConfiguration) -> some TextNode {
    VStack(spacing: 2) {
      HStack {
        content.title
          .color(.yellow)
          .textStyle(.bold)

        content.label
          .textStyle(.italic)
      }
      exampleStyle.render(content: .init(examples: content.examples))
    }
  }
}

public struct DefaultExampleStyle: ExampleStyle {

  public func render(content: ExampleConfiguration) -> some TextNode {
    VStack(spacing: 2) {
      content.examples.map { example in
        VStack {
          Label(example.label.green.bold)
          ShellCommand { example.example }.style(.default)
        }
      }
    }
  }
}
