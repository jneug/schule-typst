root := justfile_directory()
package-fork := x'${TYPST_PKG_FORK:-}'
export TYPST_ROOT := root

[private]
default:
    @just --list --unsorted

compile FILE:
  typst compile --root . "{{ FILE }}" --diagnostic-format short

debug FILE:
  typst compile --root . "{{ FILE }}" --diagnostic-format human

watch FILE:
  typst watch --root . "{{ FILE }}" --diagnostic-format short

# generate assets
assets:
    typst compile --root . docs/examples/kl.typ docs/examples/kl-{n}.png
    typst compile --root . docs/examples/ab.typ docs/examples/ab.png
    typst compile --root . docs/examples/examples.typ docs/examples/examples.png

# generate manual
docs:
    shiroa build --root . docs/book
    typst compile --root . docs/manual.typ --diagnostic-format short

serve:
    shiroa serve --root . docs/book

# run test suite
test *args:
    tt run --warning ignore {{ args }}

# update test cases
update *args:
    tt update {{ args }}

# package the library into the specified destination folder
package target:
    ./scripts/package "{{ target }}"

# install the library with the "@local" prefix
install: (package "@local")

# install the library with the "@preview" prefix (for pre-release testing)
install-preview: (package "@preview")

# create a symbolic link to this library in the target repository
link target="@local":
    ./scripts/link "{{ target }}"

link-preview: (link "@preview")

# bump version number
bump VERSION:
    tbump {{ VERSION }}

[private]
[working-directory(x'${TYPST_PKG_FORK:-.}')]
prepare-fork:
    echo "preparing package for relase in $TYPST_PKG_FORK"
    git checkout main
    git pull typst main
    git push origin --force

# prepare: (package package-fork)
prepare: prepare-fork (package package-fork)

deploy: test docs prepare

[private]
remove target:
    ./scripts/uninstall "{{ target }}"

# uninstalls the library from the "@local" prefix
uninstall: (remove "@local")

# uninstalls the library from the "@preview" prefix (for pre-release testing)
uninstall-preview: (remove "@preview")

# unlinks the library from the "@local" prefix
unlink: (remove "@local")

# unlinks the library from the "@preview" prefix
unlink-preview: (remove "@preview")

# run ci suite
ci: test docs
