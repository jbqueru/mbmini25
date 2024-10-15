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
Menu:
	movem.l	menu_palette.l, d0-d7
	movem.l	d0-d7, $ffff8240.w

	clr.b	menu_space_pressed.l

	lea.l	menu_background.l, a0
	movea.l	gfx_os_fb, a1
	move.w	#7999, d7
.CopyBg:
	move.l	(a0)+, (a1)+
	dbra.w	d7, .CopyBg

.Loop:
	lea.l	vbl_count.l, a0
	move.w	(a0), d0
.WaitVbl:
	cmp.w	(a0), d0
	beq.s	.WaitVbl

	not.w	$ffff8240.w

	movea.l	gfx_os_fb, a0
	lea	40+40*160(a0), a0

	move.w	#2, BLIT_SRC_XINC
	move.w	#114, BLIT_SRC_YINC

	move.w	#$ffff, BLIT_ENDMASK1
	move.w	#$ffff, BLIT_ENDMASK2
	move.w	#$ffff, BLIT_ENDMASK3

	move.w	#2, BLIT_DST_XINC
	move.w	#114, BLIT_DST_YINC

	move.w	#24, BLIT_XCOUNT

	move.w	#(BLIT_HOP_SRC << 8) + BLIT_OP_ST + BLIT_OP_SNT, BLIT_HOPOP

	move.b	#BLIT_SHIFT_NISR + BLIT_SHIFT_IFSR, BLIT_SHIFT
	move.l	#menu_background + 40 + 40 * 160, BLIT_SRC_ADDR
	move.l	a0, BLIT_DST_ADDR
	move.w	#80, BLIT_YCOUNT
	move.b	#BLIT_CTRL_HOG + BLIT_CTRL_BUSY, BLIT_CTRL

	nop
	nop


	move.w	#2, BLIT_SRC_XINC
	move.w	#2, BLIT_SRC_YINC

	move.w	#$ffff, BLIT_ENDMASK1
	move.w	#$ffff, BLIT_ENDMASK2
	move.w	#$0000, BLIT_ENDMASK3

	move.w	#8, BLIT_DST_XINC
	move.w	#120, BLIT_DST_YINC

	move.w	#6, BLIT_XCOUNT

	move.w	#(BLIT_HOP_SRC << 8) + BLIT_OP_NST, BLIT_HOPOP

	move.b	#BLIT_SHIFT_NISR + BLIT_SHIFT_NFSR, BLIT_SHIFT

	moveq.l	#3, d7
.ErasePlane:
	move.l	#menu_sprite, BLIT_SRC_ADDR
	move.l	a0, BLIT_DST_ADDR
	move.w	#80, BLIT_YCOUNT
	move.b	#BLIT_CTRL_HOG + BLIT_CTRL_BUSY, BLIT_CTRL
	addq.l	#2, a0
	dbra.w	d7, .ErasePlane

	subq.l	#8, a0
	move.w	#(BLIT_HOP_SRC << 8) + BLIT_OP_ST + BLIT_OP_SNT + BLIT_OP_NST, BLIT_HOPOP

	moveq.l	#3, d7
.DrawPlane:
	move.l	#menu_sprite, BLIT_SRC_ADDR
	move.l	a0, BLIT_DST_ADDR
	move.w	#80, BLIT_YCOUNT
	move.b	#BLIT_CTRL_HOG + BLIT_CTRL_BUSY, BLIT_CTRL
	addq.l	#2, a0
	dbra.w	d7, .DrawPlane

	not.w	$ffff8240.w

	cmpi.b	#$39, $fffffc02.w
	bne.s	.UpDone
	move.b	#1, menu_space_pressed.l
.UpDone:
	cmpi.b	#1, menu_space_pressed.l
	bne.w	.Loop
	cmpi.b	#$b9, $fffffc02.w
	bne.w	.Loop

	rts

	.data
	.even
menu_background:
	.incbin		"out/inc/menu_bitmap.bin"
menu_palette:
	.incbin		"out/inc/menu_palette.bin"

menu_sprite:
	.rept	8
	.dc.w	$ffff, $ffff, $ffff, $ffff, $ffff
	.endr
	.rept	64
	.dc.w	$ff00, $0000, $0000, $0000, $00ff
	.endr
	.rept	8
	.dc.w	$ffff, $ffff, $ffff, $ffff, $ffff
	.endr

	.bss
menu_space_pressed:
	.ds.b	1
