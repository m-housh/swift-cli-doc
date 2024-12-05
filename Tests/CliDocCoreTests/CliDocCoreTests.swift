@testable import CliDocCore
@preconcurrency import Rainbow
import Testing

@Suite("CliDocCore Tests")
struct CliDocCoreTests {
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
      if setupRainbow {
        "baz".color(.blue)
      }
    }
    #expect(group.render() == "foobar\("baz".blue)")
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
  func testOptionalTextNode() {
    let someNode = String?.some("string")
    #expect(someNode.body.render() == "string")
    #expect(someNode.render() == "string")

    let noneNode = String?.none
    #expect(noneNode.body.render() == "")
    #expect(noneNode.render() == "")
  }

  @Test
  func testArrayTextNode() {
    let array = ["foo", " ", "bar"]
    #expect(array.body.render() == "foo bar")
    #expect(array.render() == "foo bar")
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
            "Content"
          } header: {
            "Header"
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
            "Content"
          } header: {
            "Header"
          },
          expected: """
          Header

          Content
          """
        )
      ]
    }
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
