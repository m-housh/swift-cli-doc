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

    let tabStack = HStack {
      "foo"
      "bar"
    }
    .separator(.tab())

    #expect(tabStack.render() == "foo\tbar")

    let customStack = HStack {
      "foo"
      "bar"
    }
    .separator(.custom(":blob:"))

    #expect(customStack.render() == "foo:blob:bar")
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

    let customStack = VStack {
      "foo"
      "bar"
    }
    .separator(.custom("\n\t"))

    #expect(customStack.render() == """
    foo
    \tbar
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

  @Test
  func testLabeledContent() {
    let horizontal = LabeledContent {
      "Content"
    } label: {
      "Label:".color(.yellow).bold()
    }

    let expected = """
    \("Label:".yellow.bold) Content
    """
    #expect(horizontal.render() == expected)

    #expect(horizontal.style(.vertical()).render() == """
    \("Label:".yellow.bold)
    Content
    """)
  }

  @Test(arguments: [
    Style.bold, .italic, .dim, .underline, .blink, .strikethrough
  ])
  func testTextStyles(style: Style) {
    let node = Group { "foo" }.textStyle(_StyledText(style))
    let string = "foo".applyingStyle(style)
    #expect(node.render() == string)
  }

  @Test
  func testTextStylesDirectlyOnNode() {
    let bold = Group { "foo" }.bold()
    let string = "foo".bold
    #expect(bold.render() == string)

    let dim = Group { "foo" }.dim()
    let dimString = "foo".dim
    #expect(dim.render() == dimString)

    let italic = Group { "foo" }.italic()
    let italicString = "foo".italic
    #expect(italic.render() == italicString)

    let blink = Group { "foo" }.blink()
    let blinkString = "foo".blink
    #expect(blink.render() == blinkString)

    let strikeThrough = Group { "foo" }.strikeThrough()
    let strikeThroughString = "foo".applyingStyle(.strikethrough)
    #expect(strikeThrough.render() == strikeThroughString)

    let underline = Group { "foo" }.underline()
    let underlineString = "foo".underline
    #expect(underline.render() == underlineString)
  }

  @Test(arguments: NamedColor.allCases)
  func testNamedColors(color: NamedColor) {
    let foregroundNode = Group { "foo" }.color(color)
    let string = "foo".applyingColor(color)
    #expect(foregroundNode.render() == string)

    let backgroundNode = Group { "foo" }.backgroundColor(color.toBackgroundColor)
    let backgroundString = "foo".applyingBackgroundColor(color.toBackgroundColor)
    #expect(backgroundNode.render() == backgroundString)
  }

  @Test
  func testBit8Colors() {
    let color: UInt8 = 32
    let foregroundNode = Group { "foo" }.color(color)
    let string = "foo".applyingColor(.bit8(color))
    #expect(foregroundNode.render() == string)

    let backgroundNode = Group { "foo" }.backgroundColor(color)
    let backgroundString = "foo".applyingBackgroundColor(.bit8(color))
    #expect(backgroundNode.render() == backgroundString)

    let rgbNode = Group { "foo" }.color(color, color, color)
    let rgbString = "foo".applyingColor(.bit24((color, color, color)))
    #expect(rgbNode.render() == rgbString)

    let rgbBackgroundNode = Group { "foo" }.backgroundColor(color, color, color)
    let rgbBackgroundString = "foo".applyingBackgroundColor(.bit24((color, color, color)))
    #expect(rgbBackgroundNode.render() == rgbBackgroundString)
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
