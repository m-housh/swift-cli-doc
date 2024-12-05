@testable import CliDoc
@testable import CliDocCore
@preconcurrency import Rainbow
import Testing

@Suite("CliDoc tests")
struct CliDocTests {
  // Ensure that rainbow is setup, for test comparisons to work properly.
  let setupRainbow: Bool = {
    Rainbow.enabled = true
    Rainbow.outputTarget = .console
    return true
  }()

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
    // .exampleStyle(CustomExampleOnlyStyle())

    let expected = """
    \("Examples:".applyingStyle(.bold).applyingColor(.yellow)) \("Some common usage examples.".italic)

    \("First".red)
    $ \("ls -lah".italic)

    \("Second".red)
    $ \("find . -name foo".italic)
    """
    let result = printIfNotEqual(
      examples.exampleStyle(CustomExampleOnlyStyle()).render(),
      expected
    )
    #expect(result)

    let result2 = printIfNotEqual(
      examples.style(.custom).render(),
      expected
    )
    #expect(result2)
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

extension ExampleSectionStyle where Self == DefaultExampleSectionStyle<CustomExampleOnlyStyle> {
  static var custom: Self {
    .default(exampleStyle: CustomExampleOnlyStyle())
  }
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
