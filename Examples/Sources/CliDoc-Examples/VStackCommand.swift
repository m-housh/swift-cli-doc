import ArgumentParser
import CliDocCore

struct VStackCommand: ParsableCommand {
  static let configuration = CommandConfiguration(commandName: "vstack")

  func run() throws {
    let vstack = VStack {
      "Blob Esquire"
        .color(.yellow)
        .bold()
        .underline()

      "Blob is a super awesome worker.".italic()
    }

    print()
    print(vstack.render())
  }

}
