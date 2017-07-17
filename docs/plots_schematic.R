## ----eval=TRUE, message=FALSE, warning = FALSE, results = "hide"---------
# Load results from previous sections
mae <- get(load("mae.rda"))

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

