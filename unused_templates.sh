#!/bin/bash

# Run this a few times  until you no longer get used template warnings
# this is because since templates might depend on each other

function is_used {
    usage_count=$(ag --ignore unused -l $1 | wc -l)
}

function all_templates {
    # All templates that are not in admin, or named 404 or 500
    templates=$(find templates -type f -name '*.html' | grep -v unused | grep -v admin | grep -v 404 | grep -v 500 | awk -F '/' '{print $NF;}' | sort)
}

all_templates

for i in `seq 1 3`; do
    echo "Pass $i"
    for template in $templates; do
        is_used $template

        if [[ $usage_count -eq 0 ]]; then
            echo $template is not used
            mkdir -p templates/unused
            find templates -name $template -exec mv {} templates/unused/ \;
        fi

    done
done
