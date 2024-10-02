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
; ###                            Interrupt setup                            ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

	.text

IrqSetup:	move.w	sr, irq_sr_save.l
		move.w	#$2700, sr
		move.l	_VECTOR_VBL.w, irq_vbl_save.l
		move.l	#IrqVblEmpty, _VECTOR_VBL.w
		rts

IrqRestore:	move.l	irq_vbl_save.l, _VECTOR_VBL.w
		move.w	irq_sr_save.l, sr
		rts

IrqVblEmpty:	rte

	.bss

irq_sr_save:	.ds.w	1
irq_vbl_save:	.ds.l	1