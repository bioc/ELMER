## ----results='hide', eval=TRUE, fig.width=6,fig.cap="The plot shows the Odds Ratio (x axis) for the selected motifs with OR above 1.3 and lower boundary of OR above 1.3. The range shows the 95% confidence interval for each Odds Ratio."----
motif.enrichment.plot(motif.enrichment = "result/getMotif.hypo.motif.enrichment.csv", 
                      significant = list(OR = 1.3,lowerOR = 1.3), 
                      label = "hypo", 
                      save = TRUE)  

