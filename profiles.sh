#!/bin/bash

source font.cfg

echo -e $COLOR_HEADER$FONT_BOLD"Profiles generator for iTerm2"$COLOR_END
profiles_message=$FONT_BOLD"profiles.sh -l <hosts_file_name> [-s <settings_file_name>] [-t <template_file_name>] [-o <output_file_name>]"$COLOR_END

while getopts ":l:s:t:o:" opt; do
    case $opt in
        l)
              l=$OPTARG
              echo -e $COLOR_OKGREEN"Use list from $l"$COLOR_END
              ;;
        s)
              s=$OPTARG
              echo -e $COLOR_OKGREEN"Use settings from $s"$COLOR_END
              ;;
        t)
              t=$OPTARG
              echo -e $COLOR_OKGREEN"Use template from $t"$COLOR_END
              ;;
        o)
              o=$OPTARG
              echo -e $COLOR_OKGREEN"For output use $o"$COLOR_END
              ;;
        \?)
              echo -e "$profiles_message"
              echo -e $COLOR_FAIL"Invalid option: -$OPTARG"$COLOR_END
              exit 1
              ;;
        :)
              echo -e "$profiles_message"
              echo -e $COLOR_FAIL"Option -$OPTARG requires an argument."$COLOR_END
              exit 1
              ;;
    esac
done
if [ -z $l ]; then
    echo -e "$profiles_message"
    echo -e $COLOR_FAIL"Option -l required."$COLOR_END
    exit 1
fi
if [ -z $s ]; then
    s="settings.cfg"
fi
if [ -z $t ]; then
    t="template.cfg"
fi
if [ -z $o ]; then
    o="$l.json"
fi
echo -e $COLOR_OKGREEN"For output use $o"$COLOR_END
echo ""


source "$s"
source "$t"

ALL_TEMPLATES=""
first=0

while IFS='\n' read -r line || [[ -n "$line" ]]; do
    if [ -n "$line" ]; then
        IFS=' ' list=($line)
        if [ -n "${list[2]}" ]; then
            profile_name=${list[2]}
        else
	        profile_name=$(echo ${list[0]} | sed -E 's/^([a-z0-9]*)\.(.*)/\1/')
        fi
        profile_ip=$(echo ${list[1]} | sed -E 's/^([0-9]*)\.([0-9]*)\.([0-9]*)\.([0-9]*)(.*)/\1.\2.\3.\4/')
	    if [[ $first == 1 ]]; then
            ALL_TEMPLATES="$ALL_TEMPLATES ,"
        fi
        profile_command="$command_prefix$profile_ip$command_postfix"
        ALL_TEMPLATES=$ALL_TEMPLATES" "$(echo $TEMPLATE | sed -E "s/__SERVER_COMMAND__/$profile_command/g" | sed -E "s/__SERVER_GROUP__/$profile_group/g" | sed -E "s/__SERVER_NAME__/$profile_name/g" | sed -E "s/__SERVER_INITIAL_TEXT__/$initial_text/g")
        first=1
    fi
done < "$l"

echo "{
  \"Profiles\": [
      $ALL_TEMPLATES
  ]
}" > "$o"
