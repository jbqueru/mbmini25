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
;	- Assembler directives are .lowercase with a leading period
;	- Mnemomics and registers are lowercase unless otherwise required
;	- Symbols for code are CamelCase
;	- Symbols for variables are snake_case
;	- Symbols for app-specific constants are ALL_CAPS
;	- Symbols for OS constants, hardware registers are ALL_CAPS
;	- File-specific symbols start with an underscore
;	- Related symbols start with the same prefix (so they sort together)
;	- Hexadecimal constants are lowercase ($eaf00d).
;
;	- Include but comment out instructions that help readability but
;		don't do anything (e.g. redundant CLC on 6502 when the carry is
;		guaranteed already to be clear). The comment symbol should be
;		where the instruction would be, i.e. not on the first column.
;		There should be an explanation in a comment.
;	- Use the full instruction mnemonic whenever possible, and especially
;		when a shortcut would potentially cause confusion. E.g. use
;		movea instead of move on 680x0 when the code relies on the
;		flags not getting modified.

; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                     Main entry point for the demo                     ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

; This file primarily contains the interactions with the host OS,
; saving the state of the machine and restoring it at the end.

; #####################
; #####################
; ###               ###
; ###  Boilerplate  ###
; ###               ###
; #####################
; #####################

	.68000
	.include	"defines.s"	; Start with the ST defines
	.include	"params.s"	; Add the global parameters

	.bss
_MainBssStart:				; Beginning of the BSS - clear starting from that address

	.text

; ########################################
; ########################################
; ###                                  ###
; ###  GEMDOS entry point (user mode)  ###
; ###                                  ###
; ########################################
; ########################################

MainUser:
	pea.l	.MainSuper.l
	move.w	#XBIOS_SUPEXEC, -(sp)
	trap	#XBIOS_TRAP
	addq.l	#6, sp

	move.w	#GEMDOS_TERM0, -(sp)
	trap	#GEMDOS_TRAP

; ############################################
; ############################################
; ###                                      ###
; ###  True entry point (supervisor mode)  ###
; ###                                      ###
; ############################################
; ############################################

.MainSuper:
	bsr.s	MainBSSClear
	bsr.s	IrqStackSetup
	bsr.w	MfpSetup
	bsr.w	PsgSetup
	bsr.w	GfxSetup

	bsr.w	MM24Entry

	bsr.w	GfxReset
	bsr.w	PsgReset
	bsr.w	MfpReset
	bsr.s	IrqStackReset
	rts

; ###################
; ###################
; ###             ###
; ###  Clear BSS  ###
; ###             ###
; ###################
; ###################

; TODO: optimize. Or eliminate entirely, TBD.

MainBSSClear:
	lea.l	_MainBssStart.l, a0
.Loop:	clr.b	(a0)+
	cmpa.l	#_MainBssEnd, a0
	bne.s	.Loop
	rts

; #########################
; #########################
; ###                   ###
; ###  Include helpers  ###
; ###                   ###
; #########################
; #########################

	.include	"irqstack.s"
	.include	"mfp.s"
	.include	"gfx.s"
	.include	"psg.s"

; ###########################
; ###########################
; ###                     ###
; ###  Include main code  ###
; ###                     ###
; ###########################
; ###########################

	.include	"mbmini24.s"	; The demo's main code

; #####################
; #####################
; ###               ###
; ###  Boilerplate  ###
; ###               ###
; #####################
; #####################

	.bss
	.even
_MainBssEnd:				; End of the BSS - clear up to that address
	.end
