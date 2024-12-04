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
  let note = Note(content: "Some note.").noteStyle(.default)
  let expected = """
  \("NOTE:".yellow.bold) Some note.
  """
  #expect(note.render() == expected)
}

@Test
func testExamples() {
  #expect(setupRainbow)
  let examples = Examples(
    examples: [("First", "ls -lah"), ("Second", "find . -name foo")]
  )

  let expected = """
  \("Examples:".yellow.bold) Some common usage examples.

  \("First".green.bold)
  $ \("ls -lah".italic)

  \("Second".green.bold)
  $ \("find . -name foo".italic)
  """
  #expect(examples.render() == expected)
}
