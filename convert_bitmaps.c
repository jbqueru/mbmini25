/*
 * Copyright 2024 Jean-Baptiste M. "JBQ" "Djaybee" Queru
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * As an added restriction, if you make the program available for
 * third parties to use on hardware you own (or co-own, lease, rent,
 * or otherwise control,) such as public gaming cabinets (whether or
 * not in a gaming arcade, whether or not coin-operated or otherwise
 * for a fee,) the conditions of section 13 will apply even if no
 * network is involved.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

// SPDX-License-Identifier: AGPL-3.0-or-later

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

unsigned char pi1[32034];

unsigned char rawpixels[320][200];

unsigned char logo[120 * 112];

unsigned char menubg[160 * 200];

void main() {
	FILE* inputfile;
	FILE* outputfile;

	inputfile = fopen("BUBLOG.PI1", "rb");
	fread(pi1, 1, 32034, inputfile);
	fclose(inputfile);

	for (int y = 0; y < 200; y++) {
		for (int x = 0; x < 320; x++) {
			int byteoffset = 34;
			byteoffset += (x / 16) * 8;
			byteoffset += (x / 8) % 2;
			byteoffset += y * 160;

			int bitoffset = 7 - (x % 8);

			rawpixels[x][y] =
				(((pi1[byteoffset] >> bitoffset) & 1)) +
				(((pi1[byteoffset + 2] >> bitoffset) & 1) * 2) +
				(((pi1[byteoffset + 4] >> bitoffset) & 1) * 4) +
				(((pi1[byteoffset + 6] >> bitoffset) & 1) * 8);
		}
	}

	int xmin = 320;
	int xmax = -1;
	int ymin = 200;
	int ymax = -1;
	for (int x = 0; x < 320; x++) {
		for (int y = 0; y < 200; y++) {
			if (rawpixels[x][y]) {
				if (x < xmin) xmin = x;
				if (x > xmax) xmax = x;
				if (y < ymin) ymin = y;
				if (y > ymax) ymax = y;
			}
		}
	}
	if (xmin != 47 || xmax != 274 || ymin != 38 || ymax != 149) {
		printf("Unexpected logo size (%d,%d)-(%d,%d) (expected (47,38)-(274-149))\n",
			xmin, ymin, xmax, ymax);
		exit(1);
	}

	for (int i = 0; i < 120 * 112; i++) {
		logo[i] = 0;
	}

	for (int y = 0; y < 112; y++) {
		for (int x = 0; x < 240; x++) {
			unsigned int c = rawpixels[x + 41][y + 38];
			if (c & 1) {
				logo[(x / 16) * 2 + (x & 8) / 8 + y * 120 + 0] |= (0x80 >> (x & 7));
			}
			if (c & 2) {
				logo[(x / 16) * 2 + (x & 8) / 8 + y * 120 + 30] |= (0x80 >> (x & 7));
			}
			if (c & 4) {
				logo[(x / 16) * 2 + (x & 8) / 8 + y * 120 + 60] |= (0x80 >> (x & 7));
			}
			if (c & 8) {
				logo[(x / 16) * 2 + (x & 8) / 8 + y * 120 + 90] |= (0x80 >> (x & 7));
			}
		}
	}

	outputfile = fopen("out/inc/bublog_bitmap.bin", "wb");
	fwrite(logo, 1, 120 * 112, outputfile);
	fclose(outputfile);

	outputfile = fopen("out/inc/bublog_palette.bin", "wb");
	fwrite(pi1 + 2, 2, 16, outputfile);
	fclose(outputfile);

	inputfile = fopen("BUBLOG.PI1", "rb");
	fread(pi1, 1, 32034, inputfile);
	fclose(inputfile);

	for (int y = 0; y < 200; y++) {
		for (int x = 0; x < 320; x++) {
			int byteoffset = 34;
			byteoffset += (x / 16) * 8;
			byteoffset += (x / 8) % 2;
			byteoffset += y * 160;

			int bitoffset = 7 - (x % 8);

			rawpixels[x][y] =
				(((pi1[byteoffset] >> bitoffset) & 1)) +
				(((pi1[byteoffset + 2] >> bitoffset) & 1) * 2) +
				(((pi1[byteoffset + 4] >> bitoffset) & 1) * 4) +
				(((pi1[byteoffset + 6] >> bitoffset) & 1) * 8);
		}
	}

	for (int i = 0; i < 160 * 200; i++) {
		menubg[i] = 0;
	}

	for (int y = 0; y < 200; y++) {
		for (int x = 0; x < 320; x++) {
			unsigned int c = rawpixels[x][y];
			if (c & 1) {
				menubg[(x / 16) * 8 + (x & 8) / 8 + y * 160 + 0] |= (0x80 >> (x & 7));
			}
			if (c & 2) {
				menubg[(x / 16) * 8 + (x & 8) / 8 + y * 160 + 2] |= (0x80 >> (x & 7));
			}
			if (c & 4) {
				menubg[(x / 16) * 8 + (x & 8) / 8 + y * 160 + 4] |= (0x80 >> (x & 7));
			}
			if (c & 8) {
				menubg[(x / 16) * 8 + (x & 8) / 8 + y * 160 + 6] |= (0x80 >> (x & 7));
			}
		}
	}

	outputfile = fopen("out/inc/menu_bitmap.bin", "wb");
	fwrite(menubg, 1, 160 * 200, outputfile);
	fclose(outputfile);

	outputfile = fopen("out/inc/menu_palette.bin", "wb");
	fwrite(pi1 + 2, 2, 16, outputfile);
	fclose(outputfile);


}
