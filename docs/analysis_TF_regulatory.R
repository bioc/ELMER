## ----eval=TRUE, message=FALSE, warning = FALSE, results = "hide"---------
# Load results from previous sections
mae <- get(load("mae.rda"))
load("result/getMotif.hypo.enriched.motifs.rda")

## identify regulatory TF for the enriched motifs
TF <- get.TFs(data = mae, 
              group.col = "definition",
              group1 =  "Primary solid Tumor",
              group2 = "Solid Tissue Normal",
              minSubgroupFrac = 0.4,
              enriched.motif = enriched.motif,
              dir.out = "result", 
              cores = 1, 
              label = "hypo")

## ----eval=TRUE, message=FALSE, warning = FALSE---------------------------
# get.TFs automatically save output files. 
# getTF.hypo.TFs.with.motif.pvalue.rda contains statistics for all TF with average 
# DNA methylation at sites with the enriched motif.
# getTF.hypo.significant.TFs.with.motif.summary.csv contains only the significant probes.
dir(path = "result", pattern = "getTF")  

# TF ranking plot based on statistics will be automatically generated.
dir(path = "result/TFrankPlot_family/", pattern = "pdf") 

