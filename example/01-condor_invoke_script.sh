#!/bin/bash -x

DATA_DIR="/nfs/home/B/bhill/shared_space/barnstar"
NUM_RUNS=$(find ${DATA_DIR}/wp-enwiki-xml -name '*7z' |wc -l)

condor_submit_util -x ./extract_redirects_wrapper.sh -i /dev/null -a '$(Process)' -n ${NUM_RUNS}
