#!/bin/bash

replace_tag_in_file() {
    local filename=$1
    local search=$2
    local replace=$3

    if [[ $search != "" ]]; then
        # Escape not allowed characters in sed tool
        search=$(printf '%s\n' "$search" | sed -e 's/[]\/$*.^[]/\\&/g');
        replace=$(printf '%s\n' "$replace" | sed -e 's/[]\/$*.^[]/\\&/g');
        sed -i'' -e "s/$search/$replace/g" $filename
    fi
}

MOBIUS_PV_TEMPLATE_FILE=/home/rocket/mobius12/mobius-pv/mobius-pv.template.yaml
MOBIUS_PV_FILE=/home/rocket/mobius12/mobius-pv/mobius-pv.yaml

cp  $MOBIUS_PV_TEMPLATE_FILE  $MOBIUS_PV_FILE

if [ -z "$1" ]
then
      MOBIUS_NAMESPACE=mobius-sales
else
      MOBIUS_NAMESPACE=$1
fi
echo "Creating Mobius pv, and pvc...."
replace_tag_in_file $MOBIUS_PV_FILE "<MOBIUS_NAMESPACE>" $MOBIUS_NAMESPACE;

kubectl apply -f $MOBIUS_PV_FILE
