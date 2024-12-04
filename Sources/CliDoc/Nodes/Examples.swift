import Rainbow

public struct Examples<Header: TextNode, Label: TextNode>: TextNode {
  public typealias Example = (label: String, example: String)

  @usableFromInline
  let examples: [Example]

  @usableFromInline
  let header: Header

  @usableFromInline
  let label: Label

  @inlinable
  public init(
    examples: [Example],
    @TextBuilder header: () -> Header,
    @TextBuilder label: () -> Label
  ) {
    self.examples = examples
    self.header = header()
    self.label = label()
  }

  @inlinable
  public var body: some TextNode {
    VStack(spacing: 2) {
      HStack {
        header
        label
      }
      VStack(spacing: 2) {
        self.examples.map { example in
          VStack {
            CliDoc.Label(example.label.green.bold)
            ShellCommand { example.example.italic }
          }
        }
      }
    }
  }
}

public extension Examples where Header == String, Label == String {
  @inlinable
  init(
    header: String = "Examples:".yellow.bold,
    label: String = "Some common usage examples.",
    examples: [Example]
  ) {
    self.init(examples: examples) { header } label: { label }
  }

  @inlinable
  init(
    header: String = "Examples:".yellow.bold,
    label: String = "Some common usage examples.",
    examples: Example...
  ) {
    self.init(header: header, label: label, examples: examples)
  }

}
