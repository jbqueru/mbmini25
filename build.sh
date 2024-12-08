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

mkdir -p out/bin
mkdir -p out/inc
mkdir -p out/tos

cc convert_bitmaps.c -o out/bin/convert_bitmaps
out/bin/convert_bitmaps

rmac -s -p -4 main.s -o out/tos/MBMINI25.PRG
chmod 664 out/tos/MBMINI25.PRG

rm -rf out/mbmini25
mkdir -p out/mbmini25
cp out/tos/MBMINI25.PRG out/mbmini25
cp LICENSE LICENSE_ASSETS AGPL_DETAILS.md README.md out/mbmini25
cp blank.msa out/mbmini25/mbmini25.msa
git bundle create -q out/mbmini25/mbmini25.bundle HEAD main

rm -rf out/src
mkdir -p out/src
cp $(ls -1 | grep -v ^out\$) out/src
(cd out && zip -9 -q mbmini25/src.zip src/*)

echo Copy the executable to the floppy image before running makedist.sh!
