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

; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                      Intro for the mini-megademo                      ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

	.text

Intro:
; ########################
; ########################
; ###                  ###
; ###  Initialization  ###
; ###                  ###
; ########################
; ########################

	movem.l	intro_palette.l, d0-d7
	movem.l	d0-d7, GFX_PALETTE.w

	move.l	#intro_music, intro_music_pointer.l
	clr.b	intro_space_pressed.l

; ###################
; ###################
; ###             ###
; ###  Main loop  ###
; ###             ###
; ###################
; ###################
.Loop:
	lea.l	vbl_count.l, a0
	move.w	(a0), d0
.Wait:
	cmp.w	(a0), d0
	beq.s	.Wait

	move.l	intro_music_pointer.l, a0
	lea.l	$ffff8800.w, a1
	moveq.l	#13, d7

.CopyReg:
	move.b	d7, (a1)
	move.b	(a0)+, 2(a1)
	dbra	d7, .CopyReg

	cmpa.l	#intro_music_end, a0
	bne.s	.InMusic
	lea.l	intro_music, a0
.InMusic:
	move.l	a0, intro_music_pointer.l

	move.l	#intro_logo, BLIT_SRC_ADDR.w
	move.w	#2, BLIT_SRC_XINC.w
	move.w	#2, BLIT_SRC_YINC.w

	movea.l	gfx_fb_back, a0
	move.w	#8, BLIT_DST_XINC.w
	move.w	#-118, BLIT_DST_YINC.w

	move.w	#$ffff, BLIT_ENDMASK2.w

	move.w	#16, BLIT_XCOUNT.w

	move.w	#(BLIT_HOP_SRC << 8) + BLIT_OP_ST + BLIT_OP_SNT, BLIT_HOPOP.w

	moveq.l	#111, d7

.BlitLine:
	move.w	d7, d0
	add.w	vbl_count, d0
	andi.w	#31, d0
	cmp.w	#16, d0
	blt.s	.XOk
	subi.w	#31, d0
	neg.w	d0
.XOk:

	moveq.l	#-1, d1
	lsr.w	d0, d1

	move.w	d1, BLIT_ENDMASK1.w
	not.w	d1
	move.w	d1, BLIT_ENDMASK3.w

	addi.b	#BLIT_SHIFT_NISR + BLIT_SHIFT_NFSR, d0
	move.b	d0, BLIT_SHIFT

	move.l	a0, BLIT_DST_ADDR.w

	move.w	#4, BLIT_YCOUNT.w
	move.b	#BLIT_CTRL_HOG + BLIT_CTRL_BUSY, BLIT_CTRL.w

	lea.l	160(a0), a0
	dbra.w	d7, .BlitLine

	move.l	gfx_fb_back.l, d0
	move.l	gfx_fb_front.l, gfx_fb_back.l
	move.l	d0, gfx_fb_front.l
	lsr.w	#8, d0
	move.b	d0, GFX_VBASE_MID.w
	swap	d0
	move.b	d0, GFX_VBASE_HIGH.w

	cmpi.b	#$39, $fffffc02.w
	bne.s	.UpDone
	move.b	#1, intro_space_pressed.l
.UpDone:
	cmpi.b	#1, intro_space_pressed.l
	bne.w	.Loop
	cmpi.b	#$b9, $fffffc02.w
	bne.w	.Loop


	rts

	.data
	.even
intro_logo:
	.incbin		"out/inc/bublog_bitmap.bin"
intro_palette:
	.incbin		"out/inc/bublog_palette.bin"
intro_music:
	.incbin		"DIGITALF.BIN"
intro_music_end:

	.bss
	.even
intro_music_pointer:
	.ds.l	1
intro_space_pressed:
	.ds.b	1
