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
; ###                          Interrupt management                         ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

; ###########################
; ###########################
; ###                     ###
; ###  Public interfaces  ###
; ###                     ###
; ###########################
; ###########################

; IrqSetup:
;	* Saves state of SR and disables interrupts
;	* Save VBL vector and sets up a trivial one
;	* Parameters:
;		- none
;	* Returns:
;		- nothing
;	* Modifies:
;		- SR

; IrqRestore:
;	* Restores VBL vector
;	* Restores SR (which potentially restores interrupts)
;	* Parameters:
;		- none
;	* Returns:
;		- nothing
;	* Modifies:
;		- SR

; ########################
; ########################
; ###                  ###
; ###  Implementation  ###
; ###                  ###
; ########################
; ########################

	.text

; *************************
; **                     **
; **  Set up interrupts  **
; **                     **
; *************************

IrqSetup:	move.w	sr, _irq_sr_save.l
		move.w	#$2700, sr
		move.l	_VECTOR_VBL.w, _irq_vbl_save.l
		move.l	#_IrqVblEmpty, _VECTOR_VBL.w
		rts

; **************************
; **                      **
; **  Restore interrupts  **
; **                      **
; **************************

IrqRestore:	move.l	_irq_vbl_save.l, _VECTOR_VBL.w
		move.w	_irq_sr_save.l, sr
		rts

; *************************
; **                     **
; **  Empty VBL handler  **
; **                     **
; *************************

_IrqVblEmpty:	rte

; ###################
; ###################
; ###             ###
; ###  Variables  ###
; ###             ###
; ###################
; ###################
	.bss

_irq_sr_save:	.ds.w	1
_irq_vbl_save:	.ds.l	1
