#! /usr/bin/bash

./configure --prefix=$PREFIX

make fragile-shared-install -j$(nproc)
make check
make install
