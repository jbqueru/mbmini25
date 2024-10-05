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

IrqStackSetup:	move.w	sr, _irq_sr_save.l
		move.w	#$2700, sr
		move.l	_VECTOR_VBL.w, _irq_vbl_save.l
		move.l	#_IrqVblEmpty, _VECTOR_VBL.w
		move.l	usp, a0
		move.l	a0, stack_usp_save.l

		move.l	(sp)+, a0		; pop the return address from the old stack
		move.l	sp, stack_ssp_save.l
		move.l	#IRQSTACK_GUARD, stack.l
		lea.l	stack_end.l, sp
		jmp	(a0)			; this replaces rts - we've popped the return address into a0

; **************************
; **                      **
; **  Restore interrupts  **
; **                      **
; **************************

IrqStackReset:
		move.w	#$2700, sr
		move.l	_irq_vbl_save.l, _VECTOR_VBL.w
		move.w	_irq_sr_save.l, sr
		cmpi.l	#IRQSTACK_GUARD, stack.l
.StackOverflow:	bne.s	.StackOverflow
		move.l	stack_usp_save.l, a0
		move.l	a0, usp
		move.l	(sp)+, a0		; pop the return address from the old stack
		move.l	stack_ssp_save.l, sp
		jmp	(a0)			; this replaces rts - we've popped the return address into a0


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

	.bss
stack_usp_save:	.ds.l	1
stack_ssp_save:	.ds.l	1

stack:		.ds.l	IRQSTACK_SIZE
stack_end:
