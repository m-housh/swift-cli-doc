import ArgumentParser
import CliDoc

@main
struct Application: ParsableCommand {
  static var configuration: CommandConfiguration {
    .init(
      commandName: "examples",
      subcommands: [
        SectionCommand.self
      ]
    )
  }
}