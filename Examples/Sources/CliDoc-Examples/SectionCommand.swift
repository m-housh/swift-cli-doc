import ArgumentParser
import CliDocCore

struct SectionCommand: ParsableCommand {

  static var configuration: CommandConfiguration {
    .init(commandName: "section")
  }

  func run() throws {
    let section = Section {
      "My super awesome section"
    } header: {
      "Awesome"
    } footer: {
      "Note: this is super awesome"
    }
    print(section.style(MySectionStyle()).render())
  }
}

struct MySectionStyle: SectionStyle {
  func render(content: SectionConfiguration) -> some TextNode {
    VStack(separator: .newLine(count: 2)) {
      content.header.color(.green).bold().underline()
      content.content
      content.footer.italic()
    }
  }
}
