#!/bin/bash -x

DATA_DIR="/nfs/home/B/bhill/shared_space/barnstar"
NUM_RUNS=$(find ${DATA_DIR}/wp-enwiki-redir -name '*tsv.bz2' |wc -l)

condor_submit_util -i 02-generate_spells_cluster.R -a '--no-restore --no-save --args $(Process)' -n ${NUM_RUNS}

