; Copyright 2024 Jean-Baptiste M. "JBQ" "Djaybee" Queru
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU Affero General Public License as
; published by the Free Software Foundation, either version 3 of the
; License, or (at your option) any later version.
;
; As an added restriction, if you make the program available for
; third parties to use on hardware you own (or co-own, lease, rent,
; or otherwise control,) such as public gaming cabinets (whether or
; not in a gaming arcade, whether or not coin-operated or otherwise
; for a fee,) the conditions of section 13 will apply even if no
; network is involved.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
; GNU Affero General Public License for more details.
;
; You should have received a copy of the GNU Affero General Public License
; along with this program. If not, see <https://www.gnu.org/licenses/>.
;
; SPDX-License-Identifier: AGPL-3.0-or-later

; See main.s for more information

	.text
Intro:
	movem.l	intro_palette.l, d0-d7
	movem.l	d0-d7, GFX_PALETTE.w
	moveq.l	#0, d0
	movea.l	gfx_os_fb.l, a0

.Loop:
	lea.l	vbl_count.l, a0
	move.w	(a0), d0
.Wait:
	cmp.w	(a0), d0
	beq.s	.Wait

	move.l	#intro_logo, BLIT_SRC_ADDR.w
	move.w	#2, BLIT_SRC_XINC.w
	move.w	#2, BLIT_SRC_YINC.w

	movea.l	gfx_os_fb, a0
	move.w	#8, BLIT_DST_XINC.w
	move.w	#-118, BLIT_DST_YINC.w

	move.w	#$ffff, BLIT_ENDMASK2.w

	move.w	#16, BLIT_XCOUNT.w

	move.w	#(BLIT_HOP_SRC << 8) + BLIT_OP_ST + BLIT_OP_SNT, BLIT_HOPOP.w

	moveq.l	#111, d7

.BlitLine:
	move.w	d7, d0
	add.w	vbl_count, d0
	andi.w	#15, d0

	moveq.l	#-1, d1
	lsr.w	d0, d1

	move.w	d1, BLIT_ENDMASK1.w
	not.w	d1
	move.w	d1, BLIT_ENDMASK3.w

	addi.b	#BLIT_SHIFT_NISR + BLIT_SHIFT_NFSR, d0
	move.b	d0, BLIT_SHIFT

	move.l	a0, BLIT_DST_ADDR.w		; Destination address

	move.w	#4, BLIT_YCOUNT.w		; Ycount
	move.b	#BLIT_CTRL_HOG + BLIT_CTRL_BUSY, BLIT_CTRL.w	; Ctrl. 192 = start hog

	lea.l	160(a0), a0
	dbra.w	d7, .BlitLine



	cmpi.b	#$39, $fffffc02.w
	bne.w	.Loop

	rts

	.data
	.even
intro_logo:
	.incbin		"out/inc/bublog_bitmap.bin"
intro_palette:
	.incbin		"out/inc/bublog_palette.bin"
