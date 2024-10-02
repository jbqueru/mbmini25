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

; Coding style:
;	- ASCII
;	- hard tabs, 8 characters wide, except in ASCII art
;	- 120 columns overall
;	- Standalone block comments in the first 80 columns
;	- Code-related block comments allowed in the last 80 columns
;	- Note: rulers at 40, 80 and 120 columns help with source width
;
;	- Assembler directives are .lowercase
;	- Mnemomics and registers are lowercase unless otherwise required
;	- Global symbols for code are CamelCase
;	- Symbols for variables are snake_case
;	- Symbols for hardware registers are ALL_CAPS
;	- Related symbols start with the same prefix (so they sort together)
;	- hexadecimal constants are lowercase ($eaf00d).
;
;	- Include but comment out instructions that help readability but
;		don't do anything (e.g. redundant CLC on 6502 when the carry is
;		guaranteed already to be clear). The comment symbol should be
;		where the instruction would be, i.e. not on the first column.
;		There should be an explanation in a comment.
;	- Use the full instruction mnemonic when a shortcut would potentially
;		cause confusion. E.g. use movea instead of move on 680x0 when
;		the code relies on the flags not getting modified.

; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                       Stack and interrupt setup                       ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

	.text

; #########################################
; #########################################
; ###                                   ###
; ###  Set up the stack and interrupts  ###
; ###                                   ###
; #########################################
; #########################################

; WARNING: must be called from the top level, can't be called from a subroutine
; WARNING: stack content isn't preserved across this call

StackSetup:	move.w	sr, stack_sr_save.l
		move.w	#$2700, sr

		move.l	usp, a0
		move.l	a0, stack_usp_save.l

		move.l	(sp)+, a6		; pop the return address from the old stack
		move.l	sp, stack_ssp_save.l
		move.l	#$deadbeef, stack.l
		lea.l	stack_end.l, sp
		move.l	a6, -(sp)		; push the return address onto the new stack

		rts

; ##########################################
; ##########################################
; ###                                    ###
; ###  Restore the stack and interrupts  ###
; ###                                    ###
; ##########################################
; ##########################################

; WARNING: must be called from the top level, can't be called from a subroutine
; WARNING: stack content isn't preserved across this call

StackRestore:	move.w	#$2700, sr
		cmpi.l	#$deadbeef, stack.l
.StackOverflow:	bne.s	.StackOverflow
		move.l	(sp)+, a6		; pop the return address from the old stack
		move.l	stack_ssp_save.l, sp
		move.l	a6, -(sp)		; push the return address to the new stack
		move.l	stack_usp_save.l, a0
		move.l	a0, usp
		move.w	stack_sr_save.l, sr
		rts

	.bss
stack_sr_save:	.ds.w	1
stack_usp_save:	.ds.l	1
stack_ssp_save:	.ds.l	1

stack:		.ds.l	256
stack_end:
