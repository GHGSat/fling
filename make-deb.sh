#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

VERSION="${VERSION:-1.0}"
ARCH=amd64
NAME="${NAME:-fling}"
DESCRIPTION="${DESCRIPTION:-"S-Expression grepping tool"}"
MAINTAINER="${MAINTAINER:-"Frédéric Fortier <frf@ghgsat.com>"}"
DEPENDS="${DEPENDS:-"libc6 (>= 2.27)"}"
OCAML_BUILDDIR="$(pwd)/_build/install/default/bin"

dir="${NAME}_${VERSION}_${ARCH}"

make clean && make

rm -rf "$dir"
mkdir -p "${dir}/DEBIAN"

cd "$dir"

cat <<EOF >DEBIAN/control
Package: ${NAME}
Version: ${VERSION}
Description: ${DESCRIPTION}
Section: base
Priority: optional
Maintainer: ${MAINTAINER}
License: Proprietary
Architecture: ${ARCH}
Depends: ${DEPENDS}
EOF

mkdir -p usr/bin

cp ${OCAML_BUILDDIR}/* "usr/bin/"
for EXEC in usr/bin/* ; do
    strip "${EXEC}" 2>/dev/null || true
done

cd ..

dpkg-deb --build "${dir}"
rm -rf "${dir}"
#mv *.deb ../packaging
