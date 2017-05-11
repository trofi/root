#!/usr/bin/env bash

N='6 months'
# Script to detect packages older than 'N months'.
# Various tools upgrade time to time:
#     compiler, linkers, shells, CFLAGS, CXXFLAGS
# But automatic rebuilds are not triggered for them.
# It's useful to rebuild a few outdated packages
# against current environment.
#
# Usage example:
#    Rebuild a few old packages:
#      ./old-packages.sh | shuf | head -n 10 | xargs emerge -1

old_timestamp=$(date +'%s' -d "today - ${N}")
vdb_path=$(portageq vdb_path)

for bt in "${vdb_path}"/*/*/BUILD_TIME; do
    t=$(cat "${bt}")
    cpf_b=${bt#${vdb_path}/}
    cpf=${cpf_b%/BUILD_TIME}
    if [[ ${t} < ${old_timestamp} ]]; then
        #echo "OLD: '${cpf}': $(date -d @"${t}")"
        echo "=${cpf}"
    fi
done
