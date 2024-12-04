import Rainbow

public extension ExampleSection {

  func style<S: ExampleSectionStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(
      header: header,
      label: label,
      examples: examples
    ))
  }

  func exampleStyle<S: ExampleStyle>(_ style: S) -> some TextNode {
    DefaultExamplesStyle(exampleStyle: style).render(content: .init(
      header: header,
      label: label,
      examples: examples
    ))
  }
}

extension Array where Element == ExampleSection.Example {
  func exampleStyle<S: ExampleStyle>(_ style: S) -> some TextNode {
    style.render(content: .init(examples: self))
  }
}

public struct ExampleSectionConfiguration {
  @usableFromInline
  let header: any TextNode

  @usableFromInline
  let label: any TextNode

  @usableFromInline
  let examples: [ExampleSection.Example]

  @usableFromInline
  init(header: any TextNode, label: any TextNode, examples: [ExampleSection.Example]) {
    self.header = header
    self.label = label
    self.examples = examples
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
        content.header
        content.label
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
