#!/bin/sh

# Copyright © 2020 step https://github.com/step-/pointerpointer

VERSION=1.0
HOMEPAGE="https://github.com/step-/pointerpointer"
CREDITS="http://code.arp242.net/find-cursor"

# DEPENDENCIES: pointerpointer.sh uses modified versions of the following commands:
# find-cursor: forked at https://github.com/step-/find-cursor on branch "for-pointerpointer" commit a26bc75 or newer.
# yad (GTK+ 2): forked at https://github.com/step-/yad branch "maintain-gtk2" commit 350ab23 or newer:
# - e.g., package for Fatdog64 Linux: version 0.42.0_12 or newer
# - http://distro.ibiblio.org/fatdog/packages/810/yad_gtk2-0.42.0_12-x86_64-1.txz

# For command-line usage see section "Process positional parameters" further down.

SN=pointerpointer # vs $0

# Localization settings. {{{1
# ---------------------------------------------------------------------
export TEXTDOMAIN=fatdog OUTPUT_CHARSET=UTF-8

# Translation table
i18n_table() # {{{1
{
# Notes for translators:
# 1. Apparently the standard xgettext utility doesn't know how to extract
#    strings from calls to 'gettext -es'. Therefore the .pot template was
#    generated using
#    https://github.com/step-/scripts-to-go/blob/master/fatdog-wireless-antenna/usr/share/doc/fatdog-wireless-antenna/xgettext.sh
# 2. From this point on:
#    A. Never use \n **inside** a msgstr. For yad and gtkdialog you can replace
#    \n with \r.
#    B. However, always **end** your msgstr with \n.
#    C. Replace trailing spaces (hex 20) with non-breaking spaces (hex A0).
#
	{
	#  General
	read i18n_Win_title
	read i18n_Export_title
	read i18n_Help_title
	read i18n_Wrong_number_of_args
	read i18n_About
	read i18n_Version
	read i18n_Homepage
	read i18n_Credits
	# Form: presets
	read i18n_pset_default
	read i18n_pset_2
	read i18n_pset_3
	read i18n_pset_4
	read i18n_pset_5
	read i18n_pset_6
	read i18n_pset_7
	read i18n_pset_8
	read i18n_pset_9
	read i18n_pset_10
	read i18n_pset_11
	read i18n_pset_12
	# Form: option labels
	read i18n_opt_s
	read i18n_opt_d
	read i18n_opt_l
	read i18n_opt_w
	read i18n_opt_c
	read i18n_opt_S
	read i18n_opt_r
	read i18n_opt_f
	read i18n_opt_o
	read i18n_opt_more
	# From: info tooltips
	read i18n_form_s
	read i18n_form_d
	read i18n_form_l
	read i18n_form_w
	read i18n_form_c
	read i18n_form_S
	read i18n_form_r
	read i18n_form_f
	read i18n_form_o
	read i18n_form_more
	# Form: FBTN buttons
	read i18n_Test
	read i18n_Test_long
	read i18n_Stop
	read i18n_Stop_long
	read i18n_Save
	read i18n_Save_long
	read i18n_Load
	read i18n_Load_long
	read i18n_Run
	read i18n_Run_long
	# Buttons (none)
	read i18n_Export
	read i18n_Export_Long
	} << EOF
	$(gettext -es -- \
	"Pointer Pointer\n" \
	"Export\n" \
	"Help\n" \
	"Wrong number of arguments\n" \
	"About\n" \
	"Version\n" \
	"Homepage\n" \
	"Credits\n" \
	\
	"Default\n" \
	"Ring\n" \
	"Outlined\n" \
	"Zoom in\n" \
	"Zoom out\n" \
	"Sticky bubble\n" \
	"red35\n" \
	"green40\n" \
	"blue45\n" \
	"red40\n" \
	"red45\n" \
	"yellow\n" \
	\
	"Largest circle diameter in pixels\n" \
	"Distance between circles in pixels:\rNegative values shrink circles inwards.\n" \
	"Width of the pen that draws circles in pixels\n" \
	"Time units to wait before drawing the next circle in tenths of milliseconds\n" \
	"The circle color can be either an X11 color name or an RGB hex string\n" \
	"Symmetry 0 or 1 draws the circles in slightly different ways\n" \
	"How many times to repeat the animation; 0 plays forever\n" \
	"Attempt to follow the pointer as it moves.\n" \
	"Draw a thin outline in the opposite color to help visibility on mixed backgrounds.\n" \
	"Infrequently used options\rClick <u>Help</u> for more...\n" \
	\
	"Diameter\n" \
	"Gap\n" \
	"Pen width\n" \
	"Period\n" \
	"Color\n" \
	"Symmetry\n" \
	"Repeat\n" \
	"Follow\n" \
	"Outline\n" \
	"More\n" \
	\
	"_Test\n" \
	"Test current form values\n" \
	"_Stop\n" \
	"Stop all pointer trackers\n" \
	"S_ave\n" \
	"Save values to '%s'.\rType a name for this preset in the box below then click [Save]\n" \
	"_Load\n" \
	"Load the selected preset onto this form\n" \
	"_Run\n" \
	"⇖ Run the preset named above\n" \
	\
	"_Export\n" \
	"Export all presets as shell commands\n" \
	)
EOF
}

# Initialization {{{1
# ---------------------------------------------------------------------
i18n_table
WINTITLE="$i18n_Win_title"
WINICON=/tmp/"$SN".sgv

# More command-line parsing takes place in section 'Process positional parameters'
case $1 in
	--config=* ) CONFIG=${1#*=}; shift ;;
	* ) CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"/$SN.rc ;;
esac

# The initial preset is the first preset in $CONFIG with fallback to $i18n_pset_default ("Default")
PRESET=${PRESET:-$i18n_pset_default}

export YAD_OPTIONS="
	--title=\"$WINTITLE\"
	--window-icon=\"$WINICON\"
	--borders=4
	--buttons-layout=center
	--center
"
! [ -e "$WINICON" ] && echo '
<svg xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" version="1.1" x="0" y="0" viewBox="0 0 22.6 22.6"><circle cx="10.3" cy="9.9" r="5.7" fill="#faa"/><path d="M1.5 9.9c0-4.9 4-8.9 8.9-8.9 4.9 0 8.9 4 8.9 8.9l0.9 0.3c0-0.1 0-0.1 0-0.2C20.2 4.4 15.8 0 10.4 0S0.5 4.4 0.5 9.9c0 5.3 4.2 9.6 9.5 9.8l-0.3-0.9C5.1 18.4 1.5 14.6 1.5 9.9z" fill="#faa"/><path d="M22 20.1l-6.5-6.5 4.8-1.7c0.1-0.1 0.1-0.2 0.1-0.3 0 0 0-0.1-0.1-0.1 0 0-0.1-0.1-0.2-0.1L7.7 8c-0.1 0-0.2 0-0.2 0.1C7.4 8.1 7.4 8.2 7.4 8.2l4.1 12.6c0 0.1 0.1 0.2 0.2 0.2 0.1 0 0.2 0 0.3-0.1l1-5 6.5 6.5c0.1 0.1 0.3 0.1 0.4 0l2.1-2.1C22.1 20.3 22.1 20.2 22 20.1z"/></svg>' > "$WINICON" &&
	chmod 777 "$WINICON"


help_gui() { # NO RETURN {{{1
	exec yad --title="$i18n_Help_title - $WINTITLE" --width=500 --height=400 --button=gtk-ok \
		--form --scroll --field="
<b>$WINTITLE</b>
$(gettext "Draw concentric circles around the mouse pointer. Circles grow from the pointer hotspot outwards or shrink from the maximum <i>Diameter</i> inwards. <i>Gap</i> is the distance between consecutive circles (a negative gap makes circles shrink).")
\t\t<span bgcolor=\"white\" fgcolor=\"black\" font=\"36\">\t◎<span font=\"18\"> ⇄ ±</span> <span font=\"15\">$i18n_form_d</span>\t</span>

<b>$i18n_form_f</b> : $i18n_opt_f\r\r
<b>$i18n_form_o</b> : $i18n_opt_o\r\r
<b>$i18n_form_more</b> : $(gettext "Enter special options into this field as follows:
<tt><b>-t</b></tt>\tIn case of circle transparency issues entering -t might help depending on the window manager in use.")

$(gettext "<b>Application</b>
To load an existing single preset select its name in the pulldown and press <u>Load</u>.  This will fill the form with the preset's values, which you may further edit. Press <u>Test</u> to see your changes.
To save your changes enter a new name in the <u>Load</u> pulldown then press <u>Save</u>. There is no warning for overwriting an existing preset.
The name must not include the characters <span bgcolor=\"yellow\" fgcolor=\"black\"> ; \$ | = \" \` (back-quote) </span>.
A <i>group name</i> is also possible. It is a list of <b>existing</b> presets separated by semicolons, i.e., group <big><i>A;B;C</i></big> comprises the three presets named <big><i>A</i></big>, <big><i>B</i></big>, and <big><i>C</i></big>. A group name may also express timing constraints (see the <i>Notes</i> section).")

$(gettext "<b>Notes</b>
Loading a group only loads its first member's values onto the edit form.

While <u>Test</u> starts a pointer tracker based on the current form values, <u>Run</u> starts the pointer trackers named in the <u>Load</u> pulldown. For the preceding example, pressing <u>Run</u> will start three preset trackers respectively named <i>A</i>, <i>B</i> and <i>C</i>.

To add an initial delay before a grouped preset, enter without spaces 'w=' (unquoted) followed by the numeric delay and an optional time unit supported by the <tt>sleep</tt> command. For instance, running a group named <i>A;w=0.5s;B</i> will start <i>A</i>, wait half a second, then start <i>B</i>. A trailing 'w=' is not supported.  Rudimental looping is supported: end the preset group name with ';b=' to make the preset group repeat forever. You can stop runaway loops with the [Stop] button or the command-line line <tt>--stop</tt> option.

The first outgrowing circle is drawn at <i>Gap</i> pixels from the center. If you want to reach inside that circle start drawing from the maximum diameter with a negative <i>Gap</i>.

<i>Gap</i> is the distance between the middle circles of two consecutive annuli (rings) so it is unaffected by the <i>Pen width</i>.")

$(gettext "For the duration of an animation in seconds we have:
<span bgcolor=\"white\" fgcolor=\"black\"><tt>Duration = Diameter/|Gap| * Period / 10,000</tt></span>
hence:
<span bgcolor=\"white\" fgcolor=\"black\"><tt>Period = Duration * |Gap| / Diameter * 10,000</tt></span>
Example: For an 8 second animation with 16 px <u>Diameter</u> and 2 px <u>Gap</u> set <u>Period</u> = 10,000 units.")

<b>$i18n_About</b>
$i18n_Version: $VERSION
$i18n_Homepage: $HOMEPAGE
$i18n_Credits: $CREDITS
":LBL "KEEP"
}
set_IDX() { # {{{1 => $IDX_{PRESET,FIND_CURSOR_OPTS,FIND_CURSOR_LTRS}
	# yad form field indices of find-cursor options...
	IDX_FIND_CURSOR_OPTS="%1 %2 %3 %4 %5 %6 %7 %8 %9 %10"
	# ...and their corresponding find-cursor short option letter...
	IDX_FIND_CURSOR_LTRS="s d l w c S r more f o"
	# ...and the length of $IDX_FIND_CURSOR_{LTRS,OPTS}
	IDX_FIND_CURSOR_LEN=10
	# yad form field indices of Load combo-box CBE and RO
	# CBE reflects which preset will [Load]; RO reflects which preset will [Run]
	IDX_PRESET_CBE="%12"
}

set_FOPT() { # <null> | $@-find_cursor-option-value-ordered-list  => $FOPT_<x> formatted for find-cursor {{{1
	# <null> falls back to the current set of $OPT_<x> values
	if [ $# -gt 0 -a $IDX_FIND_CURSOR_LEN != $# ];then
		echo >&2 "${0##*/}: $i18n_Wrong_number_of_args"
		return 1
	fi
	FOPT_s=${1:-$OPT_s} FOPT_d=${2:-$OPT_d} FOPT_l=${3:-$OPT_l} FOPT_w=${4:-$OPT_w} FOPT_c=${5:-$OPT_c} FOPT_S=${6:-$OPT_S}
	case ${7:-$OPT_r} in
		0 ) FOPT_r="-r 0"     ;;
		1 ) FOPT_r=           ;;
		* ) FOPT_r="-r $((${7:-$OPT_r} -1))" ;;
	esac
	case $FOPT_d in 0) FOPT_d=1 ;; -*) FOPT_d=${FOPT_d#-} FOPT_g= ;; *) FOPT_g=-g ;; esac
	FOPT_more=${8:-$OPT_more}
	[ TRUE = "${9:-$OPT_f}"    ] && FOPT_f=-f || FOPT_f=
	[ TRUE = "${10:-$OPT_o}"   ] && FOPT_o=-o || FOPT_o=
}

stock_presets() { # {{{1
	cat << EOF
PSET="$i18n_pset_default" OPT_s="10" OPT_d="1" OPT_l="1" OPT_w="1000" OPT_c="#0000FF" OPT_S="1" OPT_r="0" OPT_more="" OPT_f="FALSE" OPT_o="FALSE"
PSET="$i18n_pset_2" OPT_s="15" OPT_d="10" OPT_l="3" OPT_w="4000" OPT_c="#FF0000" OPT_S="1" OPT_r="0" OPT_more="" OPT_f="TRUE" OPT_o="FALSE"
PSET="$i18n_pset_3" OPT_s="20" OPT_d="15" OPT_l="3" OPT_w="4000" OPT_c="#00FF00" OPT_S="1" OPT_r="0" OPT_more="" OPT_f="TRUE" OPT_o="TRUE"
PSET="$i18n_pset_4" OPT_s="310" OPT_d="-50" OPT_l="4" OPT_w="500" OPT_c="#FFD700" OPT_S="1" OPT_r="1" OPT_more="" OPT_f="FALSE" OPT_o="FALSE"
PSET="$i18n_pset_5" OPT_s="310" OPT_d="50" OPT_l="4" OPT_w="500" OPT_c="#00D7FF" OPT_S="1" OPT_r="1" OPT_more="" OPT_f="FALSE" OPT_o="FALSE"
PSET="$i18n_pset_6" OPT_s="50" OPT_d="-50" OPT_l="1" OPT_w="100" OPT_c="purple" OPT_S="1" OPT_r="0" OPT_more="" OPT_f="FALSE" OPT_o="FALSE"
PSET="$i18n_pset_7" OPT_s="13" OPT_d="1" OPT_l="13" OPT_w="3500" OPT_c="#FF0000" OPT_S="0" OPT_r="0" OPT_more="" OPT_f="TRUE" OPT_o="FALSE"
PSET="$i18n_pset_8" OPT_s="13" OPT_d="1" OPT_l="13" OPT_w="4000" OPT_c="#00FF00" OPT_S="0" OPT_r="0" OPT_more="" OPT_f="TRUE" OPT_o="FALSE"
PSET="$i18n_pset_9" OPT_s="13" OPT_d="1" OPT_l="13" OPT_w="4500" OPT_c="#0000FF" OPT_S="0" OPT_r="0" OPT_more="" OPT_f="TRUE" OPT_o="FALSE"
PSET="$i18n_pset_10" OPT_s="13" OPT_d="1" OPT_l="13" OPT_w="4000" OPT_c="#FF0000" OPT_S="0" OPT_r="0" OPT_more="" OPT_f="TRUE" OPT_o="FALSE"
PSET="$i18n_pset_11" OPT_s="13" OPT_d="1" OPT_l="13" OPT_w="4500" OPT_c="#FF0000" OPT_S="0" OPT_r="0" OPT_more="" OPT_f="TRUE" OPT_o="FALSE"
PGRP="$i18n_pset_7;$i18n_pset_8;$i18n_pset_9"
PGRP="$i18n_pset_7;$i18n_pset_10;$i18n_pset_11"
PGRP="$i18n_pset_4;w=0.5;$i18n_pset_5"
PSET="$i18n_pset_12" OPT_s="30" OPT_d="-30" OPT_l="30" OPT_w="2500" OPT_c="#FFAA00" OPT_S="0" OPT_r="1" OPT_more="" OPT_f="FALSE" OPT_o="FALSE"
PGRP="w=1;$i18n_pset_12;b="
EOF
}

set_CBE_PRESETS() { # $1-config-pathname $2-preset-i18n-label {{{1
	local config_pathname="$1" preset="$2" p
	unset CBE_PRESETS
	while read p; do
		p=${p#PSET=\"}
		p=${p#PGRP=\"}
		p=${p%%\"*}
		[ "$preset" = "$p" ] && p="^$p"
		CBE_PRESETS="$CBE_PRESETS!$p"
	done < "$config_pathname"
	CBE_PRESETS=${CBE_PRESETS#!}
}

load_preset() { # $1-config-pathname $2-preset-i18n-label $3-mode => $PRESET $OPT_{s,d,...,o} {{{1
	local config_pathname="$1" preset="$2" mode="$3" p PSET PGRP
	unset PRESET
	[ ! -r "$config_pathname" ] && return 1
	while read p; do
		case $p in PSET=\"$preset\"*|PGRP=\"$preset\"* )
			eval $p
			if [ "${p#PGRP}" != "$p" ] && [ "$mode" != PSET ]; then
				# fill the combo-box with the first item of the preset group
				local first="$preset"

				## chop w=<sleep time>;
				while [ ${first#w=} != "$first" ]; do
					first="$first;"; first=${first#*;}; first=${first%;}
				done
				! [ "$first" ] && break
				load_preset "$config_pathname" "${first%%;*}" PSET
			fi
			PRESET=$preset
			break ;;
		esac
	done < "$config_pathname"
}

save_preset() { # $1-config-pathname $2-preset-i18n-label $3@-find_cursor-option-value-ordered-list {{{1
	# values shall not include the following characters: see help_gui text
	# if config-pathname doesn't exist it is created
	# the line that matches preset-i18n-label is replaced otherwise a new preset is appended
	# if preset-i18n-label includes ';' it creates/replaces a preset group, which can be started with --show-group

	local config_pathname="$1" preset="$2" line_number i line p
	shift 2
	! [ "$config_pathname" ] && return 1

	# find matching $preset's $line_number
	if [ -r "$config_pathname" ]; then
		while read p; do
			i=$(($i +1))
			case $p in PSET=\"$preset\"*|PGRP=\"$preset\"* )
				line_number=$i; break ;;
			esac
		done < "$config_pathname"
	fi

	if [ "${preset#*;}" != "$preset" ]; then
		line="PGRP=\"$preset\""
	else
		line="PSET=\"$preset\""
		for p in $IDX_FIND_CURSOR_LTRS; do line="$line OPT_$p=\"$1\""; shift; done
	fi

	if ! [ -s "$config_pathname" ] || ! [ "$line_number" ]; then
		printf %s\\n "$line" >> "$config_pathname"
	else
		sed -i -e "$line_number c $line" "$config_pathname"
	fi
}

show() { # $1-config-pathname $2-preset-group $@3-preset-i18n-label... {{{1
	local config_pathname="$1" preset="$2"
	if [ "$preset" ]; then
		export POINTERPOINTER_KILLABLE=true # see stop_all
		export_preset "$config_pathname" "$preset" | sh &
	else
		shift 2
		set_FOPT "$@" &&
		start_pointer_tracker
	fi
}

stop_all() { # {{{1
	local p

	# this user's pointer trackers' parents
	set -- $(grep -lF POINTERPOINTER_KILLABLE= /proc/*/environ 2>/dev/null | cut -d/ -f3)
	# kill'em
	for p; do
		shift
		kill $p 2>/dev/null; wait $p 2>/dev/null
	done

	# this user's pointer trackers
	set -- $(pgrep -u $USER find-cursor)
	for p; do
		shift
		kill $p 2>/dev/null; wait $p 2>/dev/null
	done
}

start_pointer_tracker() { # [--indent[="\t"] ] $1-starting-delay <= $FOPT_<x>... {{{1
	local indent is_dry_run p starting_delay
	# if --indent then dry-run the actual commands that would start the pointer tracker
	case $1 in --indent=* ) indent=${1#*=} is_dry_run=is_dry_run; shift ;; esac
	starting_delay="$1"

	set -- -s "$FOPT_s" -d "$FOPT_d" -l "$FOPT_l" -w "$FOPT_w" -c "$FOPT_c" -S "$FOPT_S" \
	$FOPT_r \
	"$FOPT_g" "$FOPT_f" "$FOPT_o" $FOPT_more

	# delete empty parameters
	for p; do shift; [ "$p" ] && set -- "$@" "$p"; done

	if [ "$is_dry_run" ]; then
		# quote all parameters
		for p; do shift; set -- "$@" "'$p'"; done

		[ "$starting_delay" ] && printf "$indent%s\n" "sleep $starting_delay"
		printf "$indent%s" 'find-cursor'
		printf " %s" "$@"
		printf " &\n"
	else
		[ "$starting_delay" ] && sleep $starting_delay
		find-cursor "$@" &
	fi
}

export_preset() { # $1-config-pathname $2-preset-group {{{1
	local config_pathname="$1" preset="$2" p q IFS starting_delay is_loop
	[ -r "$config_pathname" ] || return 1
	while read p; do
		p=${p#PSET=\"}
		p=${p#PGRP=\"}
		p=${p%%\"*}

		[ "$preset" ] && [ "$preset" != "$p" ] && continue

		echo
		printf "# %s\n" "$p" "${0##*/} --show='$config_pathname|$p'"

		case $p in *'b='*) is_loop=is_loop ;; esac
		[ "$is_loop" ] && echo "while : forever; do"

		IFS=';'
		set -- $p
		unset IFS
		for q; do
			case $q in
				'' | *'b='* ) continue ;;
				w=[0-9]* ) starting_delay=${q#w=}; continue ;;
			esac
			load_preset "$config_pathname" "$q"
			[ "$PRESET" ] &&
				set_FOPT &&
				start_pointer_tracker --indent="${is_loop:+\\t}" $starting_delay
			unset starting_delay
		done
		[ "$is_loop" ] && echo "done"
		[ "$preset" ] && [ "$preset" = "$p" ] && break
	done < "$config_pathname"
}

# Main {{{1}}}
# ---------------------------------------------------------------------

! [ -s "$CONFIG" ] && stock_presets > "$CONFIG"

# The initial preset is the first preset in file $CONFIG with fallback to $PREFIX,
# which is assigned $i18n_pset_default ("Default") at the start of this file.
unset preset
if [ -s "$CONFIG" ]; then
	read preset < "$CONFIG"
	preset=${preset#PSET=\"}; preset=${preset%%\"*}
fi
PRESET=${preset:-$PRESET}

[ -e "$CONFIG" ] && load_preset "$CONFIG" "$PRESET"

set_IDX

# Process positional parameters {{{1
# ---------------------------------------------------------------------

unset cfg_fpn preset STATUS
case $1 in
	-h|--help ) gettext "
Usage: PP [--config=config_file] [ option ] [ --show ]

Options:
PP -h | --help | --help-gui
PP --export[=config_file]
PP --export[=config_file['|'preset_name]]    Export presets as shell commands
PP --load    Load the default preset
PP --load=[config_file'|']preset_name    Load a named preset
PP --save[=config_file['|'preset_name]] values...    Save ordered values
PP --show    Show the currently loaded preset or the form values if the GUI is active
PP --show values...    Show a pointer tracker for values
PP --show=preset_group    Show all the presets in preset_group ::= preset_name[';'preset_name...]
PP --stop    Stop all pointer trackers

All options but --load exit.  This allows loading and starting a specific preset:
»  PP --load=... --show   # this loads and shows a named preset then exits
»  PP --load --show       # ditto the default preset
whereas PP --load=... without --show continues on to display the GUI with the loaded preset selected.
"
	exit
	;;
	--help-gui )
		help_gui # exec'ed
		# NOT REACHED
		;;
	--export | --export=* ) # --export[=cfg_fpn['|'preset_i18n_label]]
		if [ "$1" != "${1#*=}" ]; then
			cfg_fpn=${1#*=}
			[ "$cfg_fpn" != "${cfg_fpn%|*}" ] && preset=${cfg_fpn##*|} && cfg_fpn=${cfg_fpn%|*}
		fi
		shift
		export_preset "${cfg_fpn:-$CONFIG}" "$preset"
		exit $?
		;;
	--save | --save=* ) # --save[=cfg_fpn['|'preset_i18n_label]] opt_{s,d,...,o}
		if [ "$1" != "${1#*=}" ]; then
			cfg_fpn=${1#*=}
			[ "$cfg_fpn" != "${cfg_fpn%|*}" ] && preset=${cfg_fpn##*|} && cfg_fpn=${cfg_fpn%|*}
		fi
		shift
		save_preset "${cfg_fpn:-$CONFIG}" "${preset:-$i18n_pset_default}" "$@"
		exit $?
		;;
	--stop )
		stop_all
		exit $?
		;;
esac
case $1 in
	--load | --load=* ) # --load | --load=[cfg_fpn'|']i18n_pset_LABEL
		preset=${1#*=}; preset=${preset#--load}
		[ "$preset" != "${preset%|*}" ] && cfg_fpn=${preset%|*} && preset=${preset##*|}
		shift
		load_preset "${cfg_fpn:-$CONFIG}" "${preset:-$i18n_pset_default}"
		STATUS=$(($STATUS +$?))
		;;
esac
unset cfg_fpn preset
case $1 in
	--show | --show=* ) # --show | --show opt_{s,d,...,o} | --show=[cfg_fpn'|']preset_group
		preset=${1#*=}; preset=${preset#--show}
		[ "$preset" != "${preset%|*}" ] && cfg_fpn=${preset%|*} && preset=${preset##*|}
		shift
		show "${cfg_fpn:-$CONFIG}" "$preset" "$@"
		exit $((STATUS +$?))
		;;
	* ) : Get interactive ;;
esac

# Show interactive GUI {{{1
# ---------------------------------------------------------------------
set_CBE_PRESETS "$CONFIG" "$PRESET" # populate combo-box

# Syntax aids -- note that the prescribed syntax for BTN and FBTN commands is:
#   ...FBTN 'sh -c "command-list..."'
# Hence the following definitions:
Begin='sh -c "' End='"'                      # FBTN command wrapper
This='\"'"$0"'\"'                            # pointerpointer.sh
Exit='kill -USR2 $YAD_PID'                # exit $This
Selected='\"'"$CONFIG"'|\"'"$IDX_PRESET_CBE" # the 'Load' combo-box selection
ConfigFile='\"'"$CONFIG"'\"'
YadExport='yad --width=500 --height=400 --title=\"'"$i18n_Export_title - $WINTITLE"'\" --button=gtk-ok'

# Pen width starts at 1 not 0 to ensure Xlib's wide-line algorithm is used, which is predictable.

IFS='|' # yad's form output field separator
set -- $(yad \
	--form --columns=2 \
	\
	\
	--field=:NUM \
	--field=:NUM \
	--field=:NUM \
	--field=:NUM \
	--field=:CLR \
	--field=:NUM \
	--field=:NUM \
	--field=    \
		\
	--field="$i18n_form_f":CHK \
	--field="$i18n_form_o":CHK \
		\
	--field=:LBL \
	--field=:CBE \
	--field="$i18n_Stop!gtk-media-stop!$i18n_Stop_long":FBTN \
	\
	\
	--field="$i18n_form_s!!$i18n_opt_s":BTN \
	--field="$i18n_form_d!!$i18n_opt_d":BTN \
	--field="$i18n_form_l!!$i18n_opt_l":BTN \
	--field="$i18n_form_w!!$i18n_opt_w":BTN \
	--field="$i18n_form_c!!$i18n_opt_c":BTN \
	--field="$i18n_form_S!!$i18n_opt_S":BTN \
	--field="$i18n_form_r!!$i18n_opt_r":BTN \
	--field="$i18n_form_more!!$i18n_opt_more":BTN \
		\
	--field="$i18n_Test!gtk-media-play!$i18n_Test_long":FBTN \
	--field="$i18n_Save!gtk-save!$(printf "$i18n_Save_long" "$CONFIG")":FBTN \
	--field=:LBL \
	--field="$i18n_Load!gtk-apply!$i18n_Load_long":FBTN \
	--field="$i18n_Run!gtk-media-forward!$i18n_Run_long":FBTN \
\
\
	--button=gtk-help:"'$0' --help-gui &" \
	--button=gtk-quit:1 \
	--button="$i18n_Export!gtk-execute!$i18n_Export_Long":"$Begin $This --export=$ConfigFile | $YadExport --text-info & $End" \
-- \
	\
	\
	"$OPT_s!1..3600" \
	"$OPT_d!-3600..3600" \
	"$OPT_l!1..3600" \
	"$OPT_w!100..1000000!100" \
	"$OPT_c" \
	"$OPT_S!0..1!1" \
	"$OPT_r!0..3600!1" \
	"$OPT_more" \
		\
	"$OPT_f" \
	"$OPT_o" \
		\
	"lbl" \
	"$CBE_PRESETS" \
	"$Begin $This --stop $End" \
	\
	\
	true \
	true \
	true \
	true \
	true \
	true \
	true \
	"$0 --help-gui" \
		\
	"$Begin $This --show $IDX_FIND_CURSOR_OPTS $End" \
	"$Begin $This --save=$Selected $IDX_FIND_CURSOR_OPTS; $This --config=$ConfigFile --load=$Selected & $Exit $End" \
	"lbl" \
	"$Begin $This --config=$ConfigFile --load=$Selected & $Exit $End" \
	"$Begin $This --show=$Selected $End" \
\
\
	;
	echo $?
)
for button; do :; done; button=${button#?} # chop \n
IFS=" "
PRESET=$1; shift

case $button in
	*) : button not used ;;
esac

