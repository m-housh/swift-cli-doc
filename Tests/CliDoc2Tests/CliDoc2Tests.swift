@testable import CliDoc2
@preconcurrency import Rainbow
import Testing

let setupRainbow: Bool = {
  Rainbow.enabled = true
  Rainbow.outputTarget = .console
  return true
}()

@Test
func testGroup() {
  #expect(setupRainbow)
  let group = Group {
    Label { "Foo:" }
    "Bar"
    "Baz"
    Note { "Bang:" } content: { "boom" }
    if setupRainbow {
      Label("Hello, rainbow").color(.blue)
    } else {
      Label("No color for you!").color(.red)
    }
  }
  .color(.green)
  .style(.italic)
  .labelStyle(color: .blue, styles: .bold)

  print(type(of: group))
  print(group.render())

//   let note = Note { "Bang:" } content: { "boom" }
//   print(note.render())
//   print(type(of: note.label))
}
