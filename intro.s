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
	movem.l	palette.l, d0-d7
	movem.l	d0-d7, GFX_PALETTE.w
	moveq.l	#0, d0
	movea.l	gfx_os_fb, a0

	lea.l	bublog.l, a5
	lea.l	88 * 160(a0), a6
	moveq.l	#111, d7
.CL:
	moveq.l	#3, d6
.CP:
	moveq.l	#14, d5
.CR:
	move.w	(a5), (a6)
	addq.l	#2, a5
	addq.l	#8, a6
	dbra.w	d5, .CR
	lea.l	-118(a6), a6
	dbra.w	d6, .CP
	lea.l	152(a6), a6
	dbra.w	d7, .CL



.Loop:
	move.w	vbl_count.l, d0
.Wait:
	cmp.w	vbl_count.l, d0
	beq.s	.Wait

	move.w	#2, $ffff8a20.w		; SXinc
	move.w	#2, $ffff8a22.w		; SYinc
	move.w	#$ffff, $ffff8a28.w	; Endmask1
	move.w	#$ffff, $ffff8a2a.w	; EndMask2
	move.w	#$ffff, $ffff8a2c.w	; EndMask3
	move.w	#2, $ffff8a2e.w		; DXinc
	move.w	#2, $ffff8a30.w		; DYinc
	move.b	#2, $ffff8a3a.w		; HOP. 2 = src
	move.b	#3, $ffff8a3b.w		; BOP. 3 = src
	move.b	#0, $ffff8a3d.w		; Shift
	move.w	#80, $ffff8a36.w	; Xcount

	movea.l	gfx_os_fb, a0
	lea.l	160(a0), a1
	move.w	#100, $ffff8a38.w	; Ycount
	move.l	a1, $ffff8a24.w		; Source
	move.l	a0, $ffff8a32.w		; Destination
	move.b	#192, $ffff8a3c.w	; Ctrl. 192 = start hog
.W1:
	btst	#7, $ffff8a3c.w
	bne.s	.W1

;	move.w	#99, $ffff8a38.w	; Ycount
;	move.b	#192, $ffff8a3c.w	; Ctrl. 192 = start hog
;.W2:
;	btst	#7, $ffff8a3c.w
;	bne.s	.W2

	move.w	#2, $ffff8a20.w		; SXinc
	move.w	#2, $ffff8a22.w		; SYinc
	move.w	#$ffff, $ffff8a28.w	; Endmask1
	move.w	#$ffff, $ffff8a2a.w	; EndMask2
	move.w	#$ffff, $ffff8a2c.w	; EndMask3
	move.w	#8, $ffff8a2e.w		; DXinc
	move.w	#-110, $ffff8a30.w	; DYinc
	move.b	#2, $ffff8a3a.w		; HOP. 2 = src
	move.b	#3, $ffff8a3b.w		; BOP. 3 = src
	move.b	vbl_count + 1, d0
	andi.b	#15, d0
	move.b	d0, $ffff8a3d.w		; Shift
	move.w	#15, $ffff8a36.w	; Xcount
	move.w	#4, $ffff8a38.w		; Ycount
	move.l	#bublog + 120 * 40, $ffff8a24.w		; Source
	movea.l	gfx_os_fb, a0
	lea	24000(a0), a1
	move.l	a1, $ffff8a32.w		; Destination
	move.b	#192, $ffff8a3c.w	; Ctrl. 192 = start hog

.W3:
	btst	#7, $ffff8a3c.w
	bne.s	.W3

	move.l	#bublog, $ffff8a24.w	; Source Address
	move.w	#2, $ffff8a20.w		; Source X increment
	move.w	#2, $ffff8a22.w		; Source Y increment

	movea.l	gfx_os_fb, a0
	move.w	#8, $ffff8a2e.w		; Destination X increment
	move.w	#-118, $ffff8a30.w	; Destination Y increment

	move.w	#$ffff, $ffff8a28.w	; Endmask1
	move.w	#$ffff, $ffff8a2a.w	; EndMask2
	move.w	#$0000, $ffff8a2c.w	; EndMask3

	move.w	#16, $ffff8a36.w	; Xcount
	move.b	#2, $ffff8a3a.w		; HOP. 2 = src
	move.b	#3, $ffff8a3b.w		; BOP. 3 = src
	move.b	#$40, $ffff8a3d.w	; Shift register. 40 = NFSR

	moveq.l	#111, d7

.BlitLine:
	move.l	a0,$ffff8a32.w		; Destination address

	move.w	#4, $ffff8a38.w		; Ycount
	move.b	#192, $ffff8a3c.w	; Ctrl. 192 = start hog

	lea.l	160(a0), a0
	dbra.w	d7, .BlitLine



	cmpi.b	#$39, $fffffc02.w
	bne.w	.Loop

	rts

	.data
	.even
bublog:
	.incbin		"out/inc/bublog_bitmap.bin"
palette:
	.incbin		"out/inc/bublog_palette.bin"
