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
; ###                     Handling of graphics hardware                     ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

	.text

GfxSetup:	move.b	GFX_VBASE_HIGH.w, _gfx_save_vbase_high.l
		move.b	GFX_VBASE_MID.w, _gfx_save_vbase_mid.l
		move.b	GFX_SYNC.w, _gfx_save_sync.l
		move.b	GFX_MODE.w, _gfx_save_mode.l
		lea.l	GFX_PALETTE.w, a0
		lea.l	_gfx_save_palette.l, a1
		moveq.l	#15, d7
.Palette:	move.w	(a0)+, (a1)+
		dbra.w	d7, .Palette

		move.b	GFX_SYNC_INTERN | GFX_SYNC_50HZ, GFX_SYNC

		rts

GfxRestore:
		lea.l	_gfx_save_palette.l, a0
		lea.l	GFX_PALETTE.w, a1
		moveq.l	#15, d7
.Palette:	move.w	(a0)+, (a1)+
		dbra.w	d7, .Palette
		move.b	_gfx_save_vbase_high.l, GFX_VBASE_HIGH.w
		move.b	_gfx_save_vbase_mid.l, GFX_VBASE_MID.w
		move.b	_gfx_save_sync.l, GFX_SYNC.w
		move.b	_gfx_save_mode.l, GFX_MODE.w
		rts

	.bss

_gfx_save_vbase_high:	.ds.b	1
_gfx_save_vbase_mid:	.ds.b	1
_gfx_save_sync:		.ds.b	1
_gfx_save_mode:		.ds.b	1
_gfx_save_palette:	.ds.w	16
