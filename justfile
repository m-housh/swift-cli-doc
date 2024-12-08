docker_image_name := "clidoc"

[private]
default:
  @just --list

clean:
  @rm -rf .build

snapshot command outputDir="./Sources/CliDocCore/Documentation.docc/Resources":
  @just -f Examples/justfile snapshot {{command}} ".{{outputDir}}"

test-docker: build-docker
  @docker run -t --rm {{docker_image_name}}:test swift test

build-docker:
  @docker build \
    --file docker/Dockerfile.test \
    --tag {{docker_image_name}}:test \
    .

preview-documentation target="CliDoc":
  # using the --enable-experimental-combined-documentation doesn't work in previews currently.
  @swift package \
    --disable-sandbox \
    --allow-writing-to-directory "docs/" \
    preview-documentation \
    --target {{target}} \
    --include-extended-types \
    --enable-inherited-docs \

build-documentation:
  swift package \
    --disable-sandbox \
    --allow-writing-to-directory "docs/" \
    generate-documentation \
    --target CliDoc \
    --target CliDocCore \
    --output-path "docs/" \
    --transform-for-static-hosting \
    --enable-experimental-combined-documentation
