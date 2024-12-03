@testable import CliDoc
@preconcurrency import Rainbow
import Testing

let setupRainbow: Bool = {
  Rainbow.enabled = true
  Rainbow.outputTarget = .console
  return true
}()

@Test
func checkStringBuilder() {
  let group = Group {
    Label("foo:")
    "bar"
  }

  #expect(group.render() == "foo: bar")

  #expect(setupRainbow)
  let coloredLabel = group.labelColor(.green)
  #expect(
    coloredLabel.render() == """
    \("foo:".green) bar
    """)
}

@Test
func checkLabelColorModifier() {
  #expect(setupRainbow)
  let group = Group(separator: "\n") {
    Label("Foo:")
    Group(separator: "\n") {
      "Bar"
      Label("baz:")
      Group {
        Label("Bang")
        "boom"
      }
      .labelColor(.green)
    }
  }
  .labelColor(.blue)

  print(type(of: group))
  print(type(of: group.body))

  let expected = """
  \("Foo:".blue)
  Bar
  \("baz:".blue)
  \("Bang".green) boom
  """
  #expect(group.render() == expected)

//   var foo = group
//   if var bar = group as? ModifiedNode<Group, GroupLabelModifier> {
//     print("Modified Node")
//     bar.modifier = bar.modifier.concat(GroupLabelModifier(color: .green))
//     print(type(of: bar.body))
//   }
}

@Test
func checkNote() {
  #expect(setupRainbow)
  let note = Note {
    "My note..."
  }
  .labelColor(.yellow)

  #expect(note.render() == "\("NOTE:".yellow) My note...")
}
