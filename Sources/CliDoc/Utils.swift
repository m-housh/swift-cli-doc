@usableFromInline
func array(from node: any TextNode) -> [any TextNode] {
  if let container = node as? NodeContainer {
    return container.nodes
  } else if let array = node as? [any TextNode] {
    return array
  } else {
    return [node]
  }
}

@usableFromInline
func seperator(_ separator: String, count: Int) -> any TextNode {
  assert(count >= 0, "Invalid count while creating a separator")

  var output = ""
  for _ in 0 ... count {
    output += separator
  }
  return output
}

extension Array where Element == (any TextNode) {

  @usableFromInline
  func removingEmptys() -> [String] {
    compactMap { node in
      let string = node.render()
      if string == "" {
        return nil
      }
      return string
    }
  }

}
