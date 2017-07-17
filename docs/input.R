## ---- fig.height=6,echo=FALSE, message=FALSE, warning=FALSE, include=TRUE----
data(elmer.data.example)
data(LUSC_meth_refined)
data(LUSC_RNA_refined)
library(DT)

## ------------------------------------------------------------------------
# Example of DNA methylation data input
datatable(Meth[1:10, 1:10], 
          options = list(scrollX = TRUE, keys = TRUE, pageLength = 5), 
          rownames = TRUE)

## ------------------------------------------------------------------------
# Example of Gene expression data input
datatable(GeneExp[1:10, 1:2], 
          options = list(scrollX = TRUE, keys = TRUE, pageLength = 5), 
          rownames = TRUE)

## ---- message=FALSE------------------------------------------------------
library(MultiAssayExperiment)
data <- createMAE(exp = GeneExp, 
                  met = Meth,
                  met.platform = "450K",
                  genome = "hg19",
                  save = FALSE,
                  TCGA = TRUE)
data
as.data.frame(colData(data)[,c("patient","definition","TN")]) %>% 
  datatable(options = list(scrollX = TRUE,pageLength = 5)) 

# Adding sample information for non TCGA samples
# You should have two objects with one for DNA methylation and 
# one for gene expression. They should have the same number of samples and the names of the 
# sample in the gene expression object and in hte DNA methylation matrix 
# should be the same
not.tcga.exp <- GeneExp # 234 samples
colnames(not.tcga.exp) <- substr(colnames(not.tcga.exp),1,15)
not.tcga.met <- Meth # 268 samples
colnames(not.tcga.met) <- substr(colnames(not.tcga.met),1,15)
# Number of samples in both objects (234)
table(colnames(not.tcga.met) %in% colnames(not.tcga.exp)) 

# Our sample information must have as row names the samples information
phenotype.data <- data.frame(row.names = colnames(not.tcga.exp), 
                             samples = colnames(not.tcga.exp), 
                             group = c(rep("group1", ncol(GeneExp)/2),
                                       rep("group2", ncol(GeneExp)/2)))

data.hg19 <- createMAE(exp = not.tcga.exp, 
                       met =  not.tcga.met, 
                       TCGA = FALSE, 
                       met.platform = "450K",
                       genome = "hg19", 
                       colData = phenotype.data)
data.hg19

# The samples that does not have data for both DNA methylation and Gene exprssion will be removed even for the phenotype data
phenotype.data <- data.frame(row.names = colnames(not.tcga.met), 
                             samples = colnames(not.tcga.met), 
                             group = c(rep("group1", ncol(Meth)/4),
                                       rep("group2", ncol(Meth)/4),
                                       rep("group3", ncol(Meth)/4),
                                       rep("group4", ncol(Meth)/4)))

data.hg38 <- createMAE(exp = not.tcga.exp, 
                       met =  not.tcga.met, 
                       TCGA = FALSE, 
                       save = FALSE,
                       met.platform = "450K",
                       genome = "hg38", 
                       colData = phenotype.data)
data.hg38
as.data.frame(colData(data.hg38)[1:20,]) %>%
  datatable(options = list(scrollX = TRUE,pageLength = 5)) 

## ---- message=FALSE------------------------------------------------------
library(SummarizedExperiment, quietly = TRUE)
rowRanges(getMet(data))[1:3,1:8]

## ------------------------------------------------------------------------
rowRanges(getExp(data))

## ---- message=FALSE------------------------------------------------------
data <- createMAE(exp = GeneExp, 
                  met = Meth,
                  genome = "hg19",
                  save = FALSE,
                  met.platform = "450K",
                  TCGA = TRUE)

# For TGCA data 1-12 represents the patient and 1-15 represents the sample ID (i.e. primary solid tumor samples )
all(substr(colnames(getExp(data)),1,15) == substr(colnames(getMet(data)),1,15))

# See sample information for data
as.data.frame(colData(data)) %>% datatable(options = list(scrollX = TRUE)) 
          
# See sample names for each experiment
as.data.frame(sampleMap(data)) %>% datatable(options = list(scrollX = TRUE)) 

## ---- message=FALSE------------------------------------------------------
# NON TCGA example: matrices has diffetrent column names
gene.exp <- DataFrame(sample1 = c("ENSG00000141510"=2.3,"ENSG00000171862"=5.4),
                      sample2 = c("ENSG00000141510"=1.6,"ENSG00000171862"=2.3))
dna.met <- DataFrame(sample1 = c("cg14324200"=0.5,"cg23867494"=0.1),
                     sample2 =  c("cg14324200"=0.3,"cg23867494"=0.9))
sample.info <- DataFrame(sample.type = c("Normal", "Tumor"))
rownames(sample.info) <- colnames(gene.exp)

mae <- createMAE(exp = gene.exp,
                 met = dna.met,
                 save = FALSE,
                 met.platform = "450K",
                 colData = sample.info, 
                 genome = "hg38") 

# NON TCGA example: matrices has diffetrent column names
rownames(sample.info) <- c("sample1","sample2")

sampleMap <- DataFrame(primary = c("sample1","sample1","sample2","sample2"), 
                       colname = c("sample1.exp","sample1.met","sample2.exp","sample2.met"))

mae <- createMAE(exp = gene.exp, 
                 met = dna.met, 
                 sampleMap = sampleMap, 
                 colData = sample.info, 
                 save = FALSE,
                 met.platform = "450K",
                 genome = "hg38") 

