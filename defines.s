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
; ###                     Atari ST constant definitions                     ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

_GEMDOS_TERM0	.equ	0

_GEMDOS_TRAP	.equ	1

_XBIOS_SUPEXEC	.equ	38

_XBIOS_TRAP	.equ	14

_VECTOR_RESET_SR	.equ	$0
_VECTOR_RESET_PC	.equ	$4
_VECTOR_ACCESS	.equ	$8
_VECTOR_ADDRESS	.equ	$c
_VECTOR_ILLEGAL	.equ	$10
_VECTOR_DIVZERO	.equ	$14
_VECTOR_CHK	.equ	$18
_VECTOR_TRAPCC	.equ	$1c
_VECTOR_PRIV	.equ	$20
_VECTOR_TRACE	.equ	$24
_VECTOR_LINE_A	.equ	$28
_VECTOR_LINE_F	.equ	$2c
_VECTOR_HBL	.equ	$68
_VECTOR_VBL	.equ	$70
_VECTOR_TRAP0	.equ	$80
_VECTOR_TRAP1	.equ	$84
_VECTOR_TRAP2	.equ	$88
_VECTOR_TRAP3	.equ	$8c
_VECTOR_TRAP4	.equ	$90
_VECTOR_TRAP5	.equ	$94
_VECTOR_TRAP6	.equ	$98
_VECTOR_TRAP7	.equ	$9c
_VECTOR_TRAP8	.equ	$a0
_VECTOR_TRAP9	.equ	$a4
_VECTOR_TRAP10	.equ	$a8
_VECTOR_TRAP11	.equ	$ac
_VECTOR_TRAP12	.equ	$b0
_VECTOR_TRAP13	.equ	$b4
_VECTOR_TRAP14	.equ	$b8
_VECTOR_TRAP15	.equ	$bc
_VECTOR_MFP_CENTRONICS_BUSY	.equ	$100
_VECTOR_MFP_RS232_DCD	.equ	$104
_VECTOR_MFP_RS232_CTS	.equ	$108
_VECTOR_MFP_BLITTER_DONE	.equ	$10c
_VECTOR_MFP_TIMER_D	.equ	$110
_VECTOR_MFP_TIMER_C	.equ	$114
_VECTOR_MFP_ACIA	.equ	$118
_VECTOR_MFP_FLOPPY	.equ	$11c
_VECTOR_MFP_TIMER_B	.equ	$120
_VECTOR_MFP_RS232_SEND_ERROR	.equ	$124
_VECTOR_MFP_RS232_SEND_EMPTY	.equ	$128
_VECTOR_MFP_RS232_RECV_ERROR	.equ	$12c
_VECTOR_MFP_RS232_RECV_FULL	.equ	$130
_VECTOR_MFP_TIMER_A	.equ	$134
_VECTOR_MFP_RS232_RING	.equ	$138
_VECTOR_MFP_MONO	.equ	$13c

_SYSTEM_RESVALID	.equ	$426
_SYSTEM_RESVECTOR	.equ	$42a
_SYSTEM_RESVALID_MAGIC	.equ	$31415926

_GFX_VBASE_HIGH	.equ	$ffff8201
_GFX_VBASE_MID	.equ	$ffff8203
_GFX_SYNC	.equ	$ffff820a	; ......px
					;       ||
					;       |+- external sync (1 = yes)
					;       +-- color refresh rate (1 = PAL - 50Hz)
_GFX_COLOR0	.equ	$ffff8240
_GFX_COLOR1	.equ	$ffff8242
_GFX_COLOR2	.equ	$ffff8244
_GFX_COLOR3	.equ	$ffff8246
_GFX_COLOR4	.equ	$ffff8248
_GFX_COLOR5	.equ	$ffff824a
_GFX_COLOR6	.equ	$ffff824c
_GFX_COLOR7	.equ	$ffff824e
_GFX_COLOR8	.equ	$ffff8250
_GFX_COLOR9	.equ	$ffff8252
_GFX_COLOR10	.equ	$ffff8254
_GFX_COLOR11	.equ	$ffff8256
_GFX_COLOR12	.equ	$ffff8258
_GFX_COLOR13	.equ	$ffff825a
_GFX_COLOR14	.equ	$ffff825c
_GFX_COLOR15	.equ	$ffff825e
_GFX_PALETTE	.equ	_GFX_COLOR0
_GFX_MODE	.equ	$ffff8260
