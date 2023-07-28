#!/bin/sh

Reset='\033[0m'       # Text Reset
 
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

case "$1" in
    ''|'-w'|'--weather')
        TMPDIR="$(mktemp -d)"
        TMPFILE="$(mktemp --tmpdir=$TMPDIR)"
        trap "rm -f -r $TMPDIR;exit 1" EXIT

        echo -e "${Green}Ctrl+D to end note"
        echo -e "$Green$(date)$Reset">>$TMPFILE
        echo -e "$(date)$Reset"
        if [ "$1" == "-w" ] || [ "$1" == "--weather" ]
        then
            echo -e "${Cyan}Getting weather info...${Reset}"
            weather="${Blue}$(curl -s wttr.in/?format="%l+%C+%t")${Reset}"
            echo -e "$weather"
            echo -e "$weather" >> $TMPFILE
        fi
        cat >>$TMPFILE
        echo -e "${Blue}~~~~~~~~~~~~~~~~~~~~$Reset\n" 
        echo -e "${Blue}~~~~~~~~~~~~~~~~~~~~$Reset\n" >>$TMPFILE
        #cat $TMPFILE >> ~/.notes
        cat $TMPFILE | cat - ~/.notes > temp && mv temp ~/.notes
        rm -f -r $TMPDIR
    ;;
    #view notes
    '-v'|'--view')
        less -R ~/.notes
    ;;
    '-e'|'--edit')
        vim ~/.notes
    ;;
    #delete notes
    '--purge')
    read -p "$(echo -e "${Red}Completly delete notes?[y/N]${Reset}")" response
        case "$response" in
            [yY])
                rm ~/.notes;
                touch ~/.notes;
                echo -e "${Red}Notes erased.${Reset}"
                exit
            ;;
            *)
                echo "Note erasing cancelled."
                exit
            ;;
        esac
    ;;
    '-h'|'--help')
        echo -e "Usage: note [OPTION]
Write a time-stamped note to ~/.notes
Ctrl+D to end note.
 -v, --view         view notes
 -e, --edit         edit notes with vim
 -w, --weather      add weather and location info to note
                    from wttr.in, requires internet
     --purge        delete all notes
 -h, --help         display this help menu
     --version      display version"
    ;;
    '--version')
        echo -e "note 0.1
License GPLv3+: GNU GPL Version 3 or later
This is free software: you are free to change and redistribute it.

Written by Eduardo Monteiro da Costa."
    ;;
    *)
        echo "Invalid argument."
esac

# note
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
