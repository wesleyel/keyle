packages-repo := justfile_directory() / '.packages'
package-path := packages-repo / 'packages'
version := `sed -n 's/^version = "\(.*\)"/\1/p' typst.toml`
pkg-name := `sed -n 's/^name = "\(.*\)"/\1/p' typst.toml`
pkg-target := package-path / 'preview' / pkg-name / version
sparse-path := 'packages/preview/' + pkg-name

# Clone wesleyel/packages into .packages (sparse, preview/keyle only) and fetch refs.
ensure-packages-repo:
    #!/usr/bin/env bash
    set -euo pipefail
    repo="{{packages-repo}}"
    sparse="{{sparse-path}}"
    if [[ ! -d "$repo/.git" ]]; then
      rm -rf "$repo"
      git clone --depth 1 --no-checkout --filter=blob:none \
        https://github.com/wesleyel/packages.git "$repo"
      git -C "$repo" sparse-checkout init --cone
      git -C "$repo" sparse-checkout set "$sparse"
      git -C "$repo" checkout main
      git -C "$repo" remote add upstream https://github.com/typst/packages.git 2>/dev/null || true
    fi
    git -C "$repo" fetch origin
    git -C "$repo" fetch upstream 2>/dev/null || true

# Symlink this repo into the local packages tree for typst --package-path.
setup-package: ensure-packages-repo
    #!/usr/bin/env bash
    set -euo pipefail
    target="{{pkg-target}}"
    mkdir -p "{{package-path}}/preview/{{pkg-name}}"
    rm -rf "$target"
    ln -sfn "{{justfile_directory()}}" "$target"

test: setup-package
    rm -f test/test-*.png
    typst compile test/tests.typ 'test/test-{n}.png' --root . --package-path {{package-path}} --ppi 200

doc: setup-package
    typst compile doc/keyle.typ 'doc/keyle.pdf' --root . --package-path {{package-path}}

example: setup-package
    rm -f example/example-*.png
    typst compile example/example.typ 'example/example-{n}.png' --root . --package-path {{package-path}} --ppi 200

# Copy package files into packages/preview/keyle/{version}/ (no .git, test/, justfile, …).
sync-package VERSION=version:
    #!/usr/bin/env bash
    set -euo pipefail
    target="{{package-path}}/preview/{{pkg-name}}/{{VERSION}}"
    rm -rf "$target"
    mkdir -p "$target"
    rsync -a --delete \
      --exclude '.git/' \
      --exclude '.packages/' \
      --exclude 'test/' \
      --exclude 'justfile' \
      --exclude 'CHANGELOG.md' \
      --exclude '.gitignore' \
      --exclude 'vendor/' \
      --exclude 'packages/' \
      "{{justfile_directory()}}/" "$target/"
    echo "Synced to $target"

# Check out (or create) branch keyle-{version} on the packages fork.
packages-branch VERSION=version:
    #!/usr/bin/env bash
    set -euo pipefail
    just ensure-packages-repo
    repo="{{packages-repo}}"
    branch="{{pkg-name}}-{{VERSION}}"
    git -C "$repo" checkout main
    git -C "$repo" pull --ff-only origin main
    git -C "$repo" checkout -B "$branch"
    echo "On branch $branch"

# Build assets, sync, commit, push, and open a PR to typst/packages.
release VERSION=version:
    #!/usr/bin/env bash
    set -euo pipefail
    ver="{{VERSION}}"
    branch="{{pkg-name}}-$ver"
    repo="{{packages-repo}}"
    pkg_dir="packages/preview/{{pkg-name}}/$ver"

    just example
    just doc
    just packages-branch "$ver"
    just sync-package "$ver"

    git -C "$repo" add "$pkg_dir"
    if git -C "$repo" diff --cached --quiet; then
      echo "No changes to commit."
    else
      git -C "$repo" commit -m "Release {{pkg-name}} $ver"
    fi

    git -C "$repo" push -u origin "$branch"

    if gh pr view --repo typst/packages --head "wesleyel:$branch" >/dev/null 2>&1; then
      echo "PR already exists:"
      gh pr view --repo typst/packages --head "wesleyel:$branch" --web
    else
      gh pr create --repo typst/packages \
        --head "wesleyel:$branch" \
        --base main \
        --title "{{pkg-name}}:$ver" \
        --body "Submit @preview/{{pkg-name}}:$ver to Typst Universe."
    fi

bump $VERSION $FORCE="":
    perl -pi -e 's/^version = .*/version = "'"$VERSION"'"/g' typst.toml
    perl -pi -e 's/keyle:.*"$/keyle:'"$VERSION"'"/g' README.md
    perl -pi -e 's/keyle:.*"$/keyle:'"$VERSION"'"/g' doc/keyle.typ
    perl -pi -e 's/keyle:.*"$/keyle:'"$VERSION"'"/g' example/example.typ
    @just doc
    git add doc/keyle.pdf doc/keyle.typ README.md typst.toml example/example.typ
    git commit -m 'bump: version '$VERSION
    git tag $FORCE $VERSION -m 'version '$VERSION
    git push $FORCE
    git push $FORCE origin $VERSION
