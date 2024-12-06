public enum Separator {

  /// Represents a horizontal separator that can be used between text nodes, typically inside
  /// an ``HStack``
  public enum Horizontal: TextNode {
    /// Separate nodes by spaces of the given count.
    case space(count: Int = 1)

    /// Separate nodes by tabs of the given count.
    case tab(count: Int = 1)

    /// Separate nodes by the provided string of the given count.
    case custom(String, count: Int = 1)

    @TextBuilder
    @inlinable
    public var body: some TextNode {
      switch self {
      case let .tab(count: count):
        seperator("\t", count: count)
      case let .space(count: count):
        seperator(" ", count: count)
      case let .custom(string, count: count):
        seperator(string, count: count)
      }
    }
  }

  /// Represents a vertical separator that can be used between text nodes, typically inside
  /// a ``VStack``
  public enum Vertical: TextNode {
    case newLine(count: Int = 1)
    case custom(String, count: Int = 1)

    @TextBuilder
    @inlinable
    public var body: some TextNode {
      switch self {
      case let .newLine(count: count):
        seperator("\n", count: count)
      case let .custom(string, count: count):
        seperator(string, count: count)
      }
    }
  }

}

@usableFromInline
func ensuredCount(_ count: Int) -> Int {
  guard count >= 1 else { return 1 }
  return count
}

@usableFromInline
func seperator(_ separator: String, count: Int) -> some TextNode {
  let count = ensuredCount(count)

  assert(count >= 1, "Invalid count while creating a separator")

  var output = ""
  for _ in 1 ... count {
    output += separator
  }
  return output
}
