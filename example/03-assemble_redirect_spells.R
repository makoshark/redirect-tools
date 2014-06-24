source("CONFIG.R")
library(data.table)

# read in the redirect spells
setwd(redirect.data.dir)
redirect.spells <- rbindlist(lapply(list.files(), function (x) {load(x); return(redirect.spells)}))

# write out the redirect spells in a few formats
setwd(output.data.dir)
save(redirect.spells, file="redirect_spells.RData")


