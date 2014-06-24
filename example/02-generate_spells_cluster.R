# save the run number
run <- as.numeric(commandArgs(TRUE)) + 1
run.string <- sprintf("%03d", run)

setwd(redirect.dat.dir)
redirect.spells <- filename.to.spells(list.files()[run])

setwd(spells.data.dir)
save(redirect.spells, file=paste("redirect_spells-", run.string, ".RData", sep=""))

