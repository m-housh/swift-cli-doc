@testable import CliDoc
@preconcurrency import Rainbow
import Testing

// Ensure that rainbow is setup, for test comparisons to work properly.
let setupRainbow: Bool = {
  Rainbow.enabled = true
  Rainbow.outputTarget = .console
  return true
}()

@Test
func testGroup() {
  #expect(setupRainbow)
  let group = Group {
    "foo"
    "bar"
  }
  #expect(group.render() == "foobar")
}

@Test
func testHStack() {
  #expect(setupRainbow)
  let stack = HStack {
    "foo"
    "bar"
  }
  #expect(stack.render() == "foo bar")
}

@Test
func testVStack() {
  #expect(setupRainbow)
  let stack = VStack {
    "foo"
    "bar"
  }
  #expect(stack.render() == """
  foo
  bar
  """)
}

@Test
func testNote() {
  #expect(setupRainbow)
  let note = Note(content: "Some note.")
  let expected = """
  \("NOTE:".yellow.bold) Some note.
  """
  #expect(note.render() == expected)
}

@Test
func testExamples() {
  #expect(setupRainbow)
  let examples = ExampleSection(
    "Examples:",
    label: "Some common usage examples.",
    examples: [("First", "ls -lah"), ("Second", "find . -name foo")]
  )

  let expected = """
  \("Examples:".yellow.bold)\(" ")\("Some common usage examples.".italic)

  \("First".green.bold)
  $ \("ls -lah".italic)

  \("Second".green.bold)
  $ \("find . -name foo".italic)
  """
  let result = printIfNotEqual(examples.render(), expected)
  #expect(result)
}

@Test
func testExamplesWithCustomExampleOnlyStyle() {
  #expect(setupRainbow)
  let examples = ExampleSection(
    "Examples:",
    label: "Some common usage examples.",
    examples: [("First", "ls -lah"), ("Second", "find . -name foo")]
  )
  .exampleStyle(CustomExampleOnlyStyle())

  let expected = """
  \("Examples:".applyingStyle(.bold).applyingColor(.yellow)) \("Some common usage examples.".italic)

  \("First".red)
  $ \("ls -lah".italic)

  \("Second".red)
  $ \("find . -name foo".italic)
  """
  let result = printIfNotEqual(examples.render(), expected)
  #expect(result)
}

@Test(
  arguments: SectionArg.arguments
)
func testSection(arg: SectionArg) {
  #expect(setupRainbow)
  printIfNotEqual(arg.section.render(), arg.expected)
  #expect(arg.section.render() == arg.expected)
}

struct SectionArg: @unchecked Sendable {
  let section: any TextNode
  let expected: String

  static var arguments: [Self] {
    [
      .init(
        section: Section {
          "Header"
        } content: {
          "Content"
        } footer: {
          "Footer"
        },
        expected: """
        Header
        Content
        Footer
        """
      ),
      .init(
        section: Section {
          "Content"
        } footer: {
          "Footer"
        },
        expected: """
        Content
        Footer
        """
      ),
      .init(
        section: Section {
          "Header"
        } content: {
          "Content"
        },
        expected: """
        Header
        Content
        """
      )
    ]
  }
}

@discardableResult
func printIfNotEqual(_ lhs: String, _ rhs: String) -> Bool {
  guard lhs == rhs else {
    print(lhs)
    print(rhs)
    return false
  }
  return true
}

struct CustomExampleOnlyStyle: ExampleStyle {
  func render(content: ExampleConfiguration) -> some TextNode {
    VStack(spacing: 2) {
      content.examples.map { example in
        VStack {
          example.label.red
          ShellCommand { example.example }
        }
      }
    }
  }
}
