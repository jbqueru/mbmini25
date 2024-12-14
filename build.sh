#!/bin/sh
# Copyright 2024 Jean-Baptiste M. "JBQ" "Djaybee" Queru
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# As an added restriction, if you make the program available for
# third parties to use on hardware you own (or co-own, lease, rent,
# or otherwise control,) such as public gaming cabinets (whether or
# not in a gaming arcade, whether or not coin-operated or otherwise
# for a fee,) the conditions of section 13 will apply even if no
# network is involved.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# SPDX-License-Identifier: AGPL-3.0-or-later

echo '(*) create output directories'
mkdir -p out/bin || exit $?
mkdir -p out/inc || exit $?
mkdir -p out/tos || exit $?

echo '(*) convert bitmaps'
cc convert_bitmaps.c -o out/bin/convert_bitmaps || exit $?
out/bin/convert_bitmaps || exit $?

echo '(*) assemble code'
rmac -s -p -4 main.s -o out/tos/MBMINI25.PRG || exit $?

echo '(*) clear/create distribution directory'
rm -rf out/mbmini25 || exit $?
mkdir -p out/mbmini25 || exit $?

echo '(*) copy files to distribution directory'
cp out/tos/MBMINI25.PRG out/mbmini25 || exit $?
cp LICENSE LICENSE_ASSETS AGPL_DETAILS.md README.md out/mbmini25 || exit $?

if [ -d .git ]
then
  echo '(*) prepare git bundle'
  git bundle create -q out/mbmini25/mbmini25.gitbundle --branches --tags HEAD || exit $?
else
  echo '(*) NO GIT DIRECTORY FOUND, BUNDLE NOT CREATED'
fi

echo '(*) prepare disk images'
# Create dual-sided disk image
hmsa out/mbmini25/mbmini25.st DS || exit $?
# .st files are plain FAT12 images, they can be manipulated with mtools,
mcopy -i out/mbmini25/mbmini25.st out/tos/MBMINI25.PRG ::/ || exit $?
# Create a .msa version of the image, which is smaller
# Ignore status code for now, hmsa returns it wrong
hmsa out/mbmini25/mbmini25.st # || exit $?

echo '(*) prepare source archive'
rm -rf out/src || exit $?
mkdir -p out/src || exit $?
cp $(ls -1 | grep -v ^out\$) out/src || exit $?
(cd out && zip -r -9 -q mbmini25/src.zip src) || exit $?

echo '(*) prepare final distribution archive'
rm -rf out/mbmini25.zip || exit $?
(cd out && zip -r -9 -q mbmini25.zip mbmini25) || exit $?

echo '(*) BUILD SUCCESSFUL'
