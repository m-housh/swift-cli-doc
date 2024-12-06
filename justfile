
preview-documentation target="CliDoc":
  swift package \
    --disable-sandbox \
    preview-documentation \
    --target {{target}} \
    --include-extended-types \
    --enable-inherited-docs
