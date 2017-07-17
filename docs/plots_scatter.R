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

## ----eval=TRUE, warning=FALSE, fig.cap="Each scatter plot shows the average  methylation level of sites with the TP53 motif in all LUSC samples plotted against the expression of the transcription factor TP53, TP63, TP73 respectively."----
load("result/getMotif.hypo.enriched.motifs.rda")
scatter.plot(data = mae,
             byTF = list(TF = c("TP53","TP63","TP73"),
                         probe = enriched.motif[["P73_HUMAN.H10MO.A"]]), 
             category = "definition",
             save = TRUE, 
             lm_line = TRUE)

