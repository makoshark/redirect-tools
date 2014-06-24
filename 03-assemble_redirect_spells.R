# #1: redirect spells
setwd("~/data/wp-enwiki-redir-spells/")
redirect.spells <- do.call("rbind", lapply(list.files(), function (x) {load(x); return(redirect.spells)}))

setwd("~/data/rdata")
save(redirect.spells, file="redirect_spells.RData")

