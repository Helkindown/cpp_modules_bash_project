#!/bin/env bash

set -euo pipefail # unofficial bash strict mode

GCC=$(which g++)

CPP_VERSION=(
    -std=c++2b
    -fmodules-ts
    -fno-exceptions
)

CPP_WARNS=(
    -Wall
    -Wcast-align
    -Weffc++
    -Wimplicit-fallthrough
    -Wredundant-decls
    -Wshadow
    -Wswitch-enum
    -Wunreachable-code
)

CPP_FLAGS=("${CPP_VERSION[@]}" "${CPP_WARNS[@]}")

get_obj_file_from_target () {
    echo ./build/"$(basename "$1")".o
}

compile () {
    local target_name="$1"
    local cpp_file="${target_name}".cpp
    local obj_file
    obj_file="$(get_obj_file_from_target "${target_name}")"

    local log="echo Compiling ${target_name}"
    local compile_command="${GCC} ${CPP_FLAGS[*]} -c ${cpp_file} -o ${obj_file}"

    if [ "${cpp_file}" -nt "${obj_file}" ]
    then
        ${log}
        ${compile_command}
        return 0
    fi

    shift
    for target in "$@"
    do
        local target_file
        target_file="$(get_obj_file_from_target "${target}")"
        if [ "${obj_file}" -ot "${target_file}" ]
        then
            ${log}
            ${compile_command}
            return 0
        fi
    done

    echo "${target_name} is satisfied"
}

stdheader () {
    local header_name="$1"

    if [ "$(find ./gcm.cache -name "${header_name}.gcm" | wc -l)" -eq 0 ]
    then
        echo "Compiling system header ${header_name}"
        "${GCC}" "${CPP_VERSION[@]}" -xc++-system-header "${header_name}"
    else
        echo "${header_name} is satisfied"
    fi
}

link () {
    local executable_name="$1"

    echo "linking"
    "${GCC}" "${CPP_FLAGS[@]}" ./build/*.o -o "${executable_name}"
}

mkdir -vp ./build ./gcm.cache

