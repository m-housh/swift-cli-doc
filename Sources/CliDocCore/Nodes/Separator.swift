/// A namespace for separator types that are used in text nodes.
///
/// These are generally used in the ``HStack``'s and ``VStack``'s to
/// specifiy how the nodes they contain are separated.
///
///
/// **Note:**
///
/// > By default nodes do not contain any separators, unless they are written inline.
/// > However, both ``HStack`` and ``VStack`` allow you to specify the separator to use
/// > to control how the individual nodes they contain are separated.
///
public enum Separator {

  /// Represents a horizontal separator that can be used between text nodes, typically inside
  /// an ``HStack``
  ///
  /// **Note:**
  /// > By default nodes do not contain any separators, unless they are written inline.
  ///
  public enum Horizontal: TextNode {
    /// Separate nodes by spaces of the given count.
    case space(count: Int = 1)

    /// Separate nodes by tabs of the given count.
    case tab(count: Int = 1)

    /// Separate nodes by the provided string of the given count.
    ///
    /// **Note:**
    ///
    /// > This can allow for non-sensical separators, so should only be used
    /// > if the provided horizontal separators do not work for you.
    ///
    case custom(String, count: Int = 1)

    @TextBuilder
    @inlinable
    public var body: some TextNode {
      switch self {
      case let .tab(count: count):
        makeSeperator("\t", count: count)
      case let .space(count: count):
        makeSeperator(" ", count: count)
      case let .custom(string, count: count):
        makeSeperator(string, count: count)
      }
    }
  }

  /// Represents a vertical separator that can be used between text nodes, typically inside
  /// a ``VStack``
  ///
  /// **Note:**
  /// > By default nodes do not contain any separators, so if you would
  /// > like a blank line separating nodes, then a count of `2` is required.
  /// > A count of `1` will place nodes on the next line.
  ///
  public enum Vertical: TextNode {
    /// Separate nodes by new line characters of the given count.
    ///
    /// **Note:**
    /// > By default nodes do not contain any separtors, so if you would
    /// > like a blank line separating nodes, then a count of `2` is required.
    /// > A count of `1` will place nodes on the next line.
    ///
    ///
    /// - Parameters:
    ///   - count: The count of the new lines to use.
    case newLine(count: Int = 1)

    /// Separate nodes by the supplied string with the given count.
    ///
    /// **Note:**
    ///
    /// > This can allow for non-sensical separators, so should only be used
    /// > if the provided vertical separators do not work for you.
    ///
    /// - Parameters:
    ///   - count: The count of the new lines to use.
    case custom(String, count: Int = 1)

    @TextBuilder
    @inlinable
    public var body: some TextNode {
      switch self {
      case let .newLine(count: count):
        makeSeperator("\n", count: count)
      case let .custom(string, count: count):
        makeSeperator(string, count: count)
      }
    }
  }

}

// MARK: - Private Helpers.

@usableFromInline
func ensuredCount(_ count: Int) -> Int {
  guard count >= 1 else { return 1 }
  return count
}

@usableFromInline
func makeSeperator(_ separator: String, count: Int) -> some TextNode {
  let count = ensuredCount(count)

  assert(count >= 1, "Invalid count while creating a separator")

  var output = ""
  for _ in 1 ... count {
    output += separator
  }
  return output
}
