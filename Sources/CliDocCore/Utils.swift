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
