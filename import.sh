#!/bin/sh -e

if [ $# -ne 1 ] ; then
    echo 'Required a version'
    exit 1
fi

VERSION=$1

quiet_git() {
    stdout=$(mktemp)
    stderr=$(mktemp)

    if ! git "$@" </dev/null >$stdout 2>$stderr; then
        cat $stderr >&2
        rm -f $stdout $stderr
        exit 1
    fi

    rm -f $stdout $stderr
}

quiet_git checkout --orphan ${VERSION}

rm -rf *
curl -sL https://static.rust-lang.org/dist/rustc-${VERSION}-src.tar.gz | tar -xz --strip-components=1

quiet_git add .
quiet_git commit -S -a -m "Import rustc-${VERSION}-src.tar.gz"
quiet_git tag -s v${VERSION} -m "Import rustc-${VERSION}-src.tar.gz"
