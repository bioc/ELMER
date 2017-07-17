## ----eval=TRUE, message=FALSE, warning = FALSE, results = "hide"---------
mae <- get(load("mae.rda"))
sig.diff <- get.diff.meth(data = mae, 
                          group.col = "definition",
                          group1 =  "Primary solid Tumor",
                          group2 = "Solid Tissue Normal",
                          minSubgroupFrac = 0.2,
                          sig.dif = 0.3,
                          diff.dir = "hypo", # Search for hypomethylated probes in group 1
                          cores = 1, 
                          dir.out ="result", 
                          pvalue = 0.01)

## ----eval=TRUE, message=FALSE, warning = FALSE---------------------------
head(sig.diff)  %>% datatable(options = list(scrollX = TRUE))
# get.diff.meth automatically save output files. 
# getMethdiff.hypo.probes.csv contains statistics for all the probes.
# getMethdiff.hypo.probes.significant.csv contains only the significant probes which
# is the same with sig.diff
dir(path = "result", pattern = "getMethdiff")  

