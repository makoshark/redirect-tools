#!/bin/bash

RUN=$(expr $1 + 1)
INDEX=$(printf "%03d" "$RUN")

CUR_DIR="/nfs/home/B/bhill/condor_jobs/extract_redirects-20140412"
DATA_DIR="/nfs/home/B/bhill/shared_space/barnstar"
INPUT_FILE=$(find ${DATA_DIR}/wp-enwiki-xml -name '*7z' | sed -n ${RUN}p)
OUTPUT_FILE="${DATA_DIR}/wp-enwiki-redir/wp_edits_redir_${INDEX}.tsv.bz2"

# print material out
7za x -so "${INPUT_FILE}" | /usr/local/bin/python2.7 ${CUR_DIR}/extract_redirects.py | bzip2 -c - > ${OUTPUT_FILE}
