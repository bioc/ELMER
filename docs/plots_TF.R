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

