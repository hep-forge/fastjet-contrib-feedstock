#! /usr/bin/bash

./configure --prefix=$PREFIX

make -j$(nproc)
make check
make install
make fragile-shared-install 
