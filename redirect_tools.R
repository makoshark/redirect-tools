# EDIT ME: Configuration options are in the stanza below
#######################################################################
redirect.data.dir <- "output/redir"
spells.data.dir <- "output/spells"
output.data.dir <- "output"

# functions and code used elsewhere
#######################################################################
Sys.setenv(TZ = "UTC")

library(data.table)

# options(cores = 20)
# options(mc.cores = 20)
# Sys.setenv(GOTO_NUM_THREADS=05)

generate.spells <- function (page, d) {

    x <- d[page,mult="all"]
    x <- as.data.frame(x)
    x <- x[sort.list(x$timestamp),]

    # transform the target because there are some differences that don't matter
    x$target <- gsub('_', ' ', x$target)
    x$target <- gsub("(^[[:alpha:]])", "\\U\\1", x$target, perl=TRUE)
    x$target <- gsub('\\#.*$', '', x$target)

    if (dim(x)[1] > 1) {
        x$redirect.prev <- c(FALSE, x$redirect[1:(length(x$redirect)-1)])
        x$target.prev <- c(NA, x$target[1:(length(x$redirect)-1)])
    } else {
        x$redirect.prev <- FALSE
        x$target.prev <- NA
    }
    
    # get a list of transitions
    x <- x[x$redirect != x$redirect.prev |
           ((!is.na(x$target) & !is.na(x$target.prev)) &
            x$target != x$target.prev),]

   # if there is only one transition it stays that way
    if (dim(x)[1] > 1) {
        x$end <- c(x$timestamp[2:dim(x)[1]], NA)
    } else {
        x$end <- NA
    }

    x <- x[x$redirect == TRUE,]

    # relabel the columsn
    x <- x[,c("page.id", "timestamp", "end", "page.title", "target")]
    colnames(x) <- c("page.id", "start", "end", "page.title", "target")
    
    return(x)
}

filename.to.spells <- function (filename) {
    con <- pipe(paste("bzcat", filename))

    d <- read.delim(con, stringsAsFactors=FALSE, header=FALSE, skip=1,
                    encoding="UTF-8", quote="")

    colnames(d) <- c("page.id", "revision.id", "page.title", "timestamp",
                     "deleted", "redirect", "target")

    d$timestamp <- as.POSIXct(d$timestamp, tz="UTC", origin="1970-01-01 00:00:00")
    
    d <- d[!d$deleted,]

    redirected.pages <- unique(d$page.title[d$redirect])

    # convert to data.table
    d <- as.data.table(d)
    setkey(d, "page.title")

    redirect.spells <- rbindlist(lapply(redirected.pages, generate.spells, d))

    return(redirect.spells)
}
