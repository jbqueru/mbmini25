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
; ###                              Stack setup                              ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

STACK_GUARD	equ	$adfacade

	.text

; ##########################
; ##########################
; ###                    ###
; ###  Set up the stack  ###
; ###                    ###
; ##########################
; ##########################

; WARNING: must be called from the top level, can't be called from a subroutine
; WARNING: stack content is gone until the stack is restored

StackSetup:	move.l	usp, a0
		move.l	a0, stack_usp_save.l

		move.l	(sp)+, a6		; pop the return address from the old stack
		move.l	sp, stack_ssp_save.l
		move.l	#STACK_GUARD, stack.l
		lea.l	stack_end.l, sp
		jmp	(a6)			; this replaces rts - we've popped the return address into a6

; ###########################
; ###########################
; ###                     ###
; ###  Restore the stack  ###
; ###                     ###
; ###########################
; ###########################

; WARNING: must be called from the top level, can't be called from a subroutine
; WARNING: stack content isn't preserved across this call

StackRestore:	move.w	#$2700, sr
		cmpi.l	#STACK_GUARD, stack.l
.StackOverflow:	bne.s	.StackOverflow
		move.l	(sp)+, a6		; pop the return address from the old stack
		move.l	stack_ssp_save.l, sp
		move.l	stack_usp_save.l, a0
		move.l	a0, usp
		jmp	(a6)			; this replaces rts - we've popped the return address into a6

	.bss
stack_usp_save:	.ds.l	1
stack_ssp_save:	.ds.l	1

stack:		.ds.l	_STACK_SIZE
stack_end:
