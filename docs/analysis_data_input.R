## ---- echo = FALSE,hide=TRUE, message=FALSE, warning=FALSE---------------
library(ELMER)
library(DT)
library(dplyr)
dir.create("result",showWarnings = FALSE)
library(BiocStyle)

## ---- message=FALSE------------------------------------------------------
# get distal probes that are 2kb away from TSS on chromosome 1
distal.probes <- get.feature.probe(genome = "hg19", 
                                   met.platform = "450K", 
                                   rm.chr = paste0("chr",c(2:22,"X","Y")))

## ----eval=TRUE, message=FALSE--------------------------------------------
library(MultiAssayExperiment)
GeneExp[1:5,1:5]
Meth[1:5,1:5]
mae <- createMAE(exp = GeneExp, 
                  met = Meth,
                  save = TRUE,
                  linearize.exp = TRUE,
                  save.filename = "mae.rda",
                  filter.probes = distal.probes,
                  met.platform = "450K",
                  genome = "hg19",
                  TCGA = TRUE)
as.data.frame(colData(mae)[1:5,])  %>% datatable(options = list(scrollX = TRUE))
as.data.frame(sampleMap(mae)[1:5,])  %>% datatable(options = list(scrollX = TRUE))
as.data.frame(assay(getMet(mae)[1:5,1:5]))  %>% datatable(options = list(scrollX = TRUE))
as.data.frame(assay(getMet(mae)[1:5,1:5])) %>% datatable(options = list(scrollX = TRUE))

