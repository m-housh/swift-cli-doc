import ArgumentParser
import CliDocCore

struct HStackCommand: ParsableCommand {
  static let configuration = CommandConfiguration(commandName: "hstack")

  func run() throws {
    let note = HStack {
      "NOTE:".color(.cyan).bold()
      "This is my super cool note.".italic()
    }

    print()
    print(note.render())
  }
}
