version := `sed -n 's/^version = "\(.*\)"/\1/p' typst.toml`

default: test

# Compile the test suite to PNGs. Sources are imported directly from src/,
# so no local package setup is needed.
test:
    rm -f test/test-*.png
    typst compile test/tests.typ 'test/test-{n}.png' --root . --ppi 200

# HTML export smoke test.
test-html:
    typst compile --features html -f html test/html.typ test/test-html.html --root .

# Build the manual.
doc:
    typst compile doc/keyle.typ doc/keyle.pdf --root .

# Build the README example images.
example:
    rm -f example/example-*.png
    typst compile example/example.typ 'example/example-{n}.png' --root . --ppi 200

all: test test-html example doc

# Bump the version everywhere, rebuild the manual, commit, tag and push.
# Pushing the tag triggers .github/workflows/release.yml, which opens the
# release PR on typst/packages.
bump $VERSION $FORCE="":
    perl -pi -e 's/^version = .*/version = "'"$VERSION"'"/g' typst.toml
    perl -pi -e 's/keyle:[0-9.]*"/keyle:'"$VERSION"'"/g' README.md
    perl -pi -e 's/keyle:[0-9.]*"/keyle:'"$VERSION"'"/g' doc/keyle.typ
    perl -pi -e 's/keyle:[0-9.]*"/keyle:'"$VERSION"'"/g' example/example.typ
    perl -pi -e 's/keyle:[0-9.]*"/keyle:'"$VERSION"'"/g' test/tests.typ
    @just doc
    git add doc/keyle.pdf doc/keyle.typ README.md typst.toml example/example.typ test/tests.typ
    git commit -m 'bump: version '$VERSION
    git tag $FORCE $VERSION -m 'version '$VERSION
    git push $FORCE
    git push $FORCE origin $VERSION
