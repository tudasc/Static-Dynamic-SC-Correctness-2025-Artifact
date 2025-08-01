#!/usr/bin/bash

###############################################################################
# Script to annotate or undo annotation of data race detection test files.
#
# Usage:
#   Annotate files (default):
#       ./script.sh [path]
#       - Adds annotation headers to matching source files under [path] (default: current directory).
#
#   Undo annotations:
#       ./script.sh --undo [path]
#       - Removes annotation headers previously added by this script from matching files under [path].
#
# Notes:
# - Files matched are C/C++/CUDA source files (*.c, *.cpp, *.cu).
# - Annotation depends on filename patterns to detect race/no-race tests.
# - XFAIL annotations are applied only to specific hardcoded files.
#
# Examples:
#   Annotate current directory:
#       ./script.sh
#
#   Annotate specific directory:
#       ./script.sh spmd/externals/
#
#   Undo annotations in current directory:
#       ./script.sh --undo
#
#   Undo annotations in specific directory:
#       ./script.sh --undo spmd/externals/
###############################################################################

basepath="."
if [ $# -ge 1 ]; then
    if [ "$1" == "--undo" ]; then
        mode="undo"
        if [ $# -eq 2 ]; then
            basepath="$2"
        fi
    else
        mode="annotate"
        basepath="$1"
    fi
else
    mode="annotate"
fi

norace_str='\/\/ RUN: %spmd-verify %s 2>\&1 | %filecheck %s\n\/\/ CHECK: No Data Race Found\n\n'
race_str='\/\/ RUN: %spmd-verify %s 2>\&1 | %filecheck %s\n\/\/ CHECK: may access the same memory as the previous operation without proper synch. (Data Race)\n\n'
xfail_str='XFAIL: *\n\n'

annotate() {
    echo "[INFO] Annotating files..."

    # No-race files
    find "${basepath}" -type f -regex ".*\(ok\|no\|correct\|Correct\).*\.\(c\|cpp\|cu\)$" | grep -v "\(nok\|yes\)" | while IFS= read -r f; do
        sed -i -e "1s/^/${norace_str}/" "$f"
    done

    # Race files
    find "${basepath}" -type f -regex ".*\(yes\|nok\|conflict\|LocalConcurrency\).*\.\(c\|cpp\|cu\)$" | grep -Ev "no[.-]" | while IFS= read -r f; do
        sed -i -e "1s/^/${race_str}/" "$f"
    done

    # XFAILs
    for name in reproducerTests/mlirTranformerError-no.cpp \
                reproducerTests/waitAll-no.c \
                RRB/MPIRMA/static/021-MPI-static-win-in-array-local-yes.c \
                RRB/MPIRMA/dynamic/007-MPI-dynamic-win-in-array-local-yes.c \
                RRB/SHMEM/sync/005-shmem-sync-waituntil-local-no.c \
                RRB/NVSHMEM/hostInitiated/sync/005-nvshmem-sync-waituntil-local-no.cpp \
                RRB/NVSHMEM/gpuInitiated/sync/005-nvshmem-sync-waituntil-local-no.cu \
                RRB/NVSHMEM/hybridInitiated/sync/005-nvshmem-sync-waituntil-local-no.cu \
                RRB/MPIRMA/static/020-MPI-static-get-get-recursive-local-no.c \
                RRB/SHMEM/static/020-shmem-static-getnbi-getnbi-recursive-local-no.c \
                RRB/NVSHMEM/hostInitiated/static/020-nvshmem-static-getnbi-getnbi-recursive-local-no.cpp \
                RRB/NVSHMEM/gpuInitiated/static/020-nvshmem-static-getnbi-getnbi-recursive-local-no.cu \
                RRB/MPIRMA/static/031-MPI-static-get-store-same-array-local-no.c \
                RRB/SHMEM/static/031-shmem-static-getnbi-store-same-array-local-no.c \
                RRB/NVSHMEM/hostInitiated/static/031-nvshmem-static-getnbi-store-same-array-local-no.cpp \
                RRB/NVSHMEM/gpuInitiated/static/031-nvshmem-static-getnbi-store-same-array-local-no.cu \
                RRB/NVSHMEM/hybridInitiated/static/031-nvshmem-static-getnbi-store-same-array-local-no.cu \
                RRB/MPIRMA/static/034-MPI-static-get-get-same-array-local-no.c \
                RRB/SHMEM/static/034-shmem-static-getnbi-getnbi-same-array-local-no.c \
                RRB/NVSHMEM/hostInitiated/static/034-nvshmem-static-getnbi-getnbi-same-array-local-no.cpp \
                RRB/NVSHMEM/gpuInitiated/static/034-nvshmem-static-getnbi-getnbi-same-array-local-no.cu \
                RRB/NVSHMEM/hybridInitiated/static/034-nvshmem-static-getnbi-getnbi-same-array-local-no.cu \
                RRB/MPIRMA/static/035-MPI-static-index-loop-local-no.c \
                RRB/SHMEM/static/035-shmem-static-index-loop-local-no.c \
                RRB/NVSHMEM/hostInitiated/static/035-nvshmem-static-index-loop-local-no.cpp \
                RRB/NVSHMEM/gpuInitiated/static/035-nvshmem-static-index-loop-local-no.cu \
                RRB/NVSHMEM/hybridInitiated/static/035-nvshmem-static-index-loop-local-no.cu \
                RRB/MPIRMA/static/038-MPI-static-loop-array-bounds-local-no.c \
                RRB/SHMEM/static/038-shmem-static-loop-array-bounds-local-no.c \
                RRB/NVSHMEM/hostInitiated/static/038-nvshmem-static-loop-array-bounds-local-no.cpp \
                RRB/NVSHMEM/gpuInitiated/static/038-nvshmem-static-loop-array-bounds-local-no.cu \
                RRB/NVSHMEM/hybridInitiated/static/038-nvshmem-static-loop-array-bounds-local-no.cu 

    do
        sed -i -e "1s/^/${xfail_str}/" "$basepath/$name"
    done
}

undo() {
    echo "[INFO] Undoing annotations..."

    find "$basepath" -type f -regex ".*\.\(c\|cpp\|cu\)$" | while IFS= read -r f; do
        # Remove RUN line
        sed -i '/^\/\/ RUN: %spmd-verify %s 2>&1 | %filecheck %s$/d' "$f"

        # Remove CHECK lines
        sed -i '/^\/\/ CHECK: No Data Race Found$/d' "$f"
        sed -i '/^\/\/ CHECK: may access the same memory as the previous operation without proper synch\. (Data Race)$/d' "$f"

        # Remove XFAIL line if first line
        sed -i '1{/^XFAIL: \*$/d}' "$f"

        # Remove empty first line if present
        sed -i '1{/^$/d}' "$f"

        # Remove empty first line if present (if two empty lines were added)
        sed -i '1{/^$/d}' "$f"
    done
}

if [ "$mode" == "undo" ]; then
    undo
else
    annotate
fi
