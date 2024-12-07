import ArgumentParser

public extension CommandConfiguration {

  /// Generate a new command configuration, using ``TextNode``'s for the abstract,
  /// usage, and discussion parameters.
  ///
  ///
  init<A: TextNode, U: TextNode, D: TextNode>(
    commandName: String? = nil,
    abstract: Abstract<A>,
    usage: Usage<U>,
    discussion: Discussion<D>,
    version: String = "",
    shouldDisplay: Bool = true,
    subcommands ungroupedSubcommands: [ParsableCommand.Type] = [],
    groupedSubcommands: [CommandGroup] = [],
    defaultSubcommand: ParsableCommand.Type? = nil,
    helpNames: NameSpecification? = nil,
    aliases: [String] = []
  ) {
    self.init(
      commandName: commandName,
      abstract: abstract.render(),
      usage: usage.render(),
      discussion: discussion.render(),
      version: version,
      shouldDisplay: shouldDisplay,
      subcommands: ungroupedSubcommands,
      groupedSubcommands: groupedSubcommands,
      defaultSubcommand: defaultSubcommand,
      helpNames: helpNames,
      aliases: aliases
    )
  }
}
