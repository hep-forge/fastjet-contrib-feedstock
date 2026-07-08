#! /usr/bin/bash
set -e

# Bundled config.sub/config.guess predate aarch64 triplets -- replace with
# the current ones from the gnuconfig package before configuring.
for f in config.sub config.guess; do
  find . -name "$f" -exec cp "$BUILD_PREFIX/share/gnuconfig/$f" {} \;
done

# fjcontrib's own Makefile.in hardcodes CXX=g++ and CXXFLAGS=-O2 -Wall -g
# as defaults; its custom `configure` script only overrides them if passed
# explicitly as bare CXX=/CXXFLAGS= arguments (see `configure --help`).
# Without this, the build falls back to whatever bare `g++` resolves to
# instead of conda's pinned toolchain wrapper, leaking newer host GLIBC
# symbol versions (e.g. GLIBC_2.38) into libfastjetcontribfragile.so.
./configure --prefix=$PREFIX CXX="${CXX}" CXXFLAGS="${CXXFLAGS}"

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
make -j$NPROC
make check
make install
make fragile-shared-install 
