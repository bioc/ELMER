## ---- fig.height = 6, eval = FALSE---------------------------------------
#  TCGA.pipe("LUSC",
#            wd = "./ELMER.example",
#            cores = parallel::detectCores()/2,
#            mode = "unsupervised"
#            permu.size = 300,
#            Pe = 0.01,
#            analysis = c("distal.probes","diffMeth","pair","motif","TF.search"),
#            diff.dir = "hypo",
#            rm.chr = paste0("chr",c("X","Y")))

## ---- fig.height = 6, eval = FALSE---------------------------------------
#  TCGA.pipe("LUSC",
#            wd = "./ELMER.example",
#            cores = parallel::detectCores()/2,
#            mode = "supervised"
#            genes = "TP53",
#            group.col = "TP53",
#            group1 = "Mutant",
#            group2 = "WT",
#            permu.size = 300,
#            Pe = 0.01,
#            analysis = c("download","diffMeth","pair","motif","TF.search"),
#            diff.dir = "hypo",
#            rm.chr = paste0("chr",c("X","Y")))

## ----sessioninfo, eval=TRUE----------------------------------------------
sessionInfo()

