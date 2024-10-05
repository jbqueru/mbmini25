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
; ###                     Interrupt and stack management                    ###
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

; IrqStackSetup:
;	* Saves state of SR and disables interrupts
;	* Save VBL vector and sets up a trivial one
;	* Save stack state (USP and SSP) and sets up our stack
;	* Parameters:
;		- none
;	* Returns:
;		- nothing
;	* Modifies:
;		- A0, SP, SR

; IrqStackReset:
;	* Restores VBL vector
;	* Restores SR (which potentially restores interrupts)
;	* Checks stack overflow
;	* Restore stack stack (USP and SSP)
;	* Parameters:
;		- none
;	* Returns:
;		- nothing
;	* Modifies:
;		- A0, SP, USP, SR

; ########################
; ########################
; ###                  ###
; ###  Implementation  ###
; ###                  ###
; ########################
; ########################

	.text

; ***********************************
; **                               **
; **  Set up interrupts and stack  **
; **                               **
; ***********************************

IrqStackSetup:
; Save SR and disable interrupts
		move.w	sr, _irq_sr_save.l
		move.w	#$2700, sr

; Save VBL handler and set up ours
		move.l	_VECTOR_VBL.w, _irq_vbl_save.l
		move.l	#_IrqVblEmpty, _VECTOR_VBL.w

; Save USP
		move.l	usp, a0
		move.l	a0, _stack_usp_save.l

; Save SP and set up our stack
		move.l	(sp)+, a0		; pop the return address from the old stack
		move.l	#STACK_GUARD, _stack.l
		move.l	sp, _stack_ssp_save.l
		lea.l	_stack_end.l, sp
		jmp	(a0)			; this replaces rts - we've popped the return address into a0

; ************************************
; **                                **
; **  Restore interrupts and stack  **
; **                                **
; ************************************

IrqStackReset:
; Disable interrupts
		move.w	#$2700, sr

; Restore VBL handler
		move.l	_irq_vbl_save.l, _VECTOR_VBL.w

; Check for stack overflow
		cmpi.l	#STACK_GUARD, _stack.l
.StackOverflow:	bne.s	.StackOverflow

; Restore USP
		move.l	_stack_usp_save.l, a0
		move.l	a0, usp

; Restore SP
		move.l	(sp)+, a0		; pop the return address from the old stack
		move.l	_stack_ssp_save.l, sp

; Restore SR (most likely re-enables interrupts)
		move.w	_irq_sr_save.l, sr
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

_stack_usp_save:	.ds.l	1
_stack_ssp_save:	.ds.l	1

_stack:		.ds.l	STACK_SIZE
_stack_end:
