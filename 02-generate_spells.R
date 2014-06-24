source("redirect_tools.R")

# save the run number
setwd(redirect.data.dir)
redirect.spells <- filename.to.spells(list.files())

setwd(spells.data.dir)
save(redirect.spells, file="redirect_spells.RData")

write.csv(redirect.spells, file="redirect_spells.tsv", sep="\t"
                 fileEncoding="UTF-8", row.names=FALSE)

library(foreign)
write.dta(redirect.spells, file="redirect_spells.dta")


