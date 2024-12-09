import ArgumentParser
import CliDocCore

struct GroupCommand: ParsableCommand {

  static let configuration = CommandConfiguration(commandName: "group")

  func run() throws {
    let group = Group {
      "My headline."
      "\n"
      "Some content".color(.green)
      "\n"
      "Foo Bar".italic()
    }
    .color(.blue)

    print()
    print("\(group.render())")
  }
}
