## ----eval=TRUE, message=FALSE, warning = FALSE, results = "hide"---------
# Load results from previous sections
mae <- get(load("mae.rda"))

## ----results='hide', echo=TRUE, message=FALSE, warning=FALSE, fig.height=5, fig.cap="Each scatter plot shows the methylation level of an example  probe cg19403323 in all LUSC samples plotted against the expression of one of  20 adjacent genes."----
scatter.plot(data = mae,
             byProbe = list(probe = c("cg19403323"), numFlankingGenes = 20), 
             category = "definition", 
             lm = TRUE, # Draw linear regression curve
             save = FALSE) 

## ----results='hide',eval=TRUE, fig.cap="Scatter plot shows the methylation level of an example probe cg19403323 in all LUSC samples plotted against the expression of the putative  target gene SYT14."----
scatter.plot(data = mae,
             byPair = list(probe = c("cg19403323"), gene = c("ENSG00000143469")), 
             category = "definition", save = TRUE, lm_line = TRUE) 

## ----eval=TRUE, fig.cap="Each scatter plot shows the average  methylation level of sites with the TP53 motif in all LUSC samples plotted against the expression of the transcription factor TP53, TP63, TP73 respectively."----
load("result/getMotif.hypo.enriched.motifs.rda")
scatter.plot(data = mae,
             byTF = list(TF = c("TP53","TP63","TP73"),
                         probe = enriched.motif[["P73_HUMAN.H10MO.A"]]), 
             category = "definition",
             save = TRUE, 
             lm_line = TRUE)

## ----results='hide', eval=TRUE,fig.height=5,  fig.cap="The schematic plot shows probe colored in blue and the location of nearby 20 genes. The genes significantly linked to the probe  were shown in red.", message=FALSE, warning=FALSE----
schematic.plot(pair = pair, 
               data = data,
               group.col = "definition",
               byProbe = "cg25312122",
               save = FALSE)

## ----results='hide', eval=TRUE, fig.width=6, fig.height=10, fig.cap="The schematic plot shows the gene colored in red and all blue colored probes, which are significantly linked to the  expression of this gene."----
pair <- read.csv("result/getPair.hypo.pairs.significant.csv")
schematic.plot(pair = pair, 
               data = mae,   
               group.col = "definition", 
               byGene = "ENSG00000143469", 
               save = FALSE)

## ----results='hide', eval=TRUE, fig.width=6,fig.cap="The plot shows the Odds Ratio (x axis) for the selected motifs with OR above 1.3 and lower boundary of OR above 1.3. The range shows the 95% confidence interval for each Odds Ratio."----
motif.enrichment.plot(motif.enrichment = "result/getMotif.hypo.motif.enrichment.csv", 
                      significant = list(OR = 1.3,lowerOR = 1.3), 
                      label = "hypo", 
                      save = TRUE)  ## different signficant cut off.

## ----eval=TRUE,fig.cap="Shown are TF ranking plots based on the score (-log(P value)) of association between TF expression and DNA methylation of the SOX2 motif in the LUSC cancer type. The dashed line indicates the boundary of the top 5% association score. The top 3 associated TFs and the TF family members=(dots in red) that are associated with that specific motif are labeled in the plot"----
load("result/getTF.hypo.TFs.with.motif.pvalue.rda")
motif <- "SOX2_HUMAN.H10MO.B"
TF.rank.plot(motif.pvalue = TF.meth.cor, 
             motif = motif,
             save = FALSE) 

## ----eval=TRUE,fig.cap="Shown are TF ranking plots based on the score (-log(P value)) of association between TF expression and DNA methylation of the SOX2 motif in the LUSC cancer type. The dashed line indicates the boundary of the top 5% association score. The top 3 associated TFs and the TF sub-family members=(dots in red) that are associated with that specific motif are labeled in the plot"----
load("result/getTF.hypo.TFs.with.motif.pvalue.rda")
motif <- "SOX2_HUMAN.H10MO.B"
TF.rank.plot(motif.pvalue = TF.meth.cor,  
            motif = motif, 
            TF.label = createMotifRelevantTfs("subfamily")[motif],
            save = FALSE)

## ----sessioninfo, eval=TRUE----------------------------------------------
sessionInfo()

