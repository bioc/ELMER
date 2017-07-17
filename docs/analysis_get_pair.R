## ---- eval = TRUE, message = FALSE, warning = FALSE, results = "hide"----
# Load results from previous sections
mae <- get(load("mae.rda"))
sig.diff <- read.csv("result/getMethdiff.hypo.probes.significant.csv")

nearGenes <- GetNearGenes(data = mae, 
                         probes = sig.diff$probe, 
                         numFlankingGenes = 20, # 10 upstream and 10 dowstream genes
                         cores = 1)

Hypo.pair <- get.pair(data = mae,
                      group.col = "definition",
                      group1 =  "Primary solid Tumor",
                      group2 = "Solid Tissue Normal",
                      nearGenes = nearGenes,
                      minSubgroupFrac = 0.4, # % of samples to use in to create groups U/M
                      permu.dir = "result/permu",
                      permu.size = 100, # Please set to 100000 to get significant results
                      pvalue = 0.05,   
                      Pe = 0.01, # Please set to 0.001 to get significant results
                      filter.probes = TRUE, # See preAssociationProbeFiltering function
                      filter.percentage = 0.05,
                      filter.portion = 0.3,
                      dir.out = "result",
                      cores = 1,
                      label = "hypo")

## ---- eval = TRUE, message = FALSE, warning = FALSE----------------------
Hypo.pair %>% datatable(options = list(scrollX = TRUE))
# get.pair automatically save output files. 
#getPair.hypo.all.pairs.statistic.csv contains statistics for all the probe-gene pairs.
#getPair.hypo.pairs.significant.csv contains only the significant probes which is 
# same with Hypo.pair.
dir(path = "result", pattern = "getPair") 

