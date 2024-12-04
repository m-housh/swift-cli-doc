import Rainbow

public struct Examples<Header: TextNode, Label: TextNode>: TextNode {
  public typealias Example = (label: String, example: String)

  @usableFromInline
  let examples: [Example]

  @usableFromInline
  let header: Header

  @usableFromInline
  let label: Label

  public init(
    examples: [Example],
    @TextBuilder header: () -> Header,
    @TextBuilder label: () -> Label
  ) {
    self.examples = examples
    self.header = header()
    self.label = label()
  }

  public var body: some TextNode {
    Group(separator: "") {
      Group(separator: " ", content: [header.color(.yellow).style(.bold), label, "\n"])
      "\n"
      Group(
        separator: "\n\n",
        content: self.examples.map { example in
          Group(separator: "\n") {
            CliDoc.Label(example.label.green.bold)
            ShellCommand { example.example.italic }
          }
        }
      )
    }
  }
}
