# ``CliDocCore``

A framework for writing `cli` documentation in a way similar to `SwiftUI`, where
your types conform to ``TextNode`` and implement a ``TextNode/body`` that
returns a ``TextNode``, generally using the essential types described below.

## Topics

### Essentials

- ``VStack``
- ``HStack``
- ``Section``
- ``Group``
- ``Empty``
- ``AnyTextNode``

### Styling

- ``SectionStyle``
- ``DefaultSectionStyle``
- ``SectionConfiguration``
- ``TextStyleConfiguration``

### Base Protocols

- ``TextNode``
- ``TextNodeRepresentable``
- ``TextStyle``
- ``TextModifier``
