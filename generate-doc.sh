#!/bin/bash

# All the main.tf (standard) are found so we have the entrypoint to all the main modules
find . -type f -name 'main.tf' ! -path '*/.*/*' | sed 's|^./||' | sed 's|/main.tf$||' > list_of_main_tf_paths.txt

while IFS= read -r list_of_main_tf_paths; do
    echo "Processing main.tf from $list_of_main_tf_paths"
    mkdir -p "./docs/$list_of_main_tf_paths"
    docker run --rm --volume "$(pwd)/$list_of_main_tf_paths:/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 markdown /terraform-docs > ./docs/${list_of_main_tf_paths}"/README.md"
done < list_of_main_tf_paths.txt

while IFS= read -r modules_to_document; do
    echo "Processing $modules_to_document"
    mkdir -p "./docs/$modules_to_document"
    docker run --rm --volume "$(pwd)/$modules_to_document:/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 markdown /terraform-docs > ./docs/${modules_to_document}"/README.md"
done < modules_to_document.txt
