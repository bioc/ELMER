## get differential methylated probes-------------------------
#' Stat.diff.meth
#' @param meth A matrix contain DNA methylation data.
#' @param groups A vector of category of samples.
#' @param group1 Group 1 label in groups vector
#' @param group2 Group 2 label in groups vector
#' @param test A function specify which statistic test will be used.
#' @param percentage A number specify the percentage of normal and tumor 
#' samples used in the test.
#' @param Top.m A logic. If to identify hypomethylated probe Top.m should be FALSE. 
#' hypermethylated probe is TRUE.
#' @param min.samples Minimun number of samples to use in the analysis. Default 5.
#' If you have 10 samples in one group, percentage is 0.2 this will give 2 samples 
#' in the lower quintile, but then 5 will be used.
#' @importFrom stats sd t.test wilcox.test
#' @return Statistic test results to identify differentially methylated probes.
Stat.diff.meth <- function(
    meth,
    groups,
    group1,
    group2,
    test = t.test,
    min.samples = 5,
    percentage = 0.2,
    Top.m = NULL
){
  
  if(percentage < 1){
    g1 <- meth[groups %in% group1]
    g2 <- meth[groups %in% group2]
    group1.nb <- ifelse(round(length(g1) * percentage) < min.samples, min(min.samples,length(g1)), round(length(g1) * percentage))
    group2.nb <- ifelse(round(length(g2) * percentage) < min.samples, min(min.samples,length(g2)), round(length(g2) * percentage))
    
    group1.tmp <- sort(g1, decreasing = Top.m)
    group2.tmp <- sort(g2, decreasing = Top.m)
    
    group1.tmp <- group1.tmp[1:group1.nb]
    group2.tmp <- group2.tmp[1:group2.nb]
  } else {
    group1.tmp <- meth[groups %in% group1]
    group2.tmp <- meth[groups %in% group2]
  }
  
  
  if(sd(meth,na.rm=TRUE) > 0 & !all(is.na(group1.tmp)) & !all(is.na(group2.tmp))){
    if(!is.na(Top.m)){
      alternative <- ifelse(Top.m,"greater","less")
    } else {
      alternative <- "two.sided"
    }
    # If hyper (top. TRUE alternative greater) group 1 > group 2
    # If hypo  (top. FALSE alternative greater) group 1 < group 2
    out <- tryCatch({
      TT <- test(x = group1.tmp, y = group2.tmp, alternative = alternative, conf.int = TRUE)
      MeanDiff <- ifelse(length(TT$estimate) == 2, TT$estimate[1]-TT$estimate[2],TT$estimate)
      PP <- TT$p.value
      data.frame(PP=PP,MeanDiff=MeanDiff, stringsAsFactors = FALSE)
    }, error = function(e) {
      data.frame(PP=NA,MeanDiff=NA,stringsAsFactors = FALSE)
    })
  } else{
    out <- data.frame(PP=NA,MeanDiff=NA,stringsAsFactors = FALSE)
  }
  return(out)
}

#'Stat.nonpara.permu
#' @param Probe A character of name of Probe in array.
#' @param Gene A vector of gene ID.
#' @param Top A number determines the percentage of top methylated/unmethylated samples.
#' Only used if unmethy and methy are not set.
#' @param correlation Type of correlation to evaluate (negative or positive).
#' Negative (default) checks if hypomethylated region has a upregulated target gene. 
#' Positive checks if region hypermethylated has a upregulated target gene. 
#' @param Meths A matrix contains methylation for each probe (row) and each sample (column).
#' @param Exps A matrix contains Expression for each gene (row) and each sample (column).
#' @param methy Index of M (methylated) group.
#' @param unmethy Index of U (unmethylated) group.
#' @return U test results
#' @importFrom utils head tail
Stat.nonpara.permu <- function(
    Probe,
    Gene,
    Top = 0.2,
    correlation = "negative",
    unmethy = NULL,
    methy  = NULL,
    Meths = Meths,
    Exps = Exps
){
  
  if(is.null(methy) & is.null(unmethy)){
    idx <- order(Meths)
    nb <- round(length(Meths) * Top)
    unmethy <- head(idx, n = nb) 
    methy <- tail(idx, n = nb) 
  }
  
  test.p <- unlist(
    lapply(
      splitmatrix(Exps),
      function(x) {
        tryCatch({
          wilcox.test(
            x[unmethy],
            x[methy],
            alternative = ifelse(correlation == "negative","greater","less"),
            exact = FALSE
          )$p.value
        }, error = function(e){
          NA
        })                            
      }
      
    ))
  
  test.p <- data.frame(
    GeneID = Gene,
    Raw.p = test.p[match(Gene, names(test.p))], 
    stringsAsFactors = FALSE
  ) 
  
  return(test.p)
}

#' U test (non parameter test) for permutation. This is one probe vs nearby gene 
#' which is good for computing each probes for nearby genes.
#' @param Probe A character of name of Probe in array.
#' @param NearGenes A list of nearby gene for each probe which is output of GetNearGenes function.
#' @param Top A number determines the percentage of top methylated/unmethylated samples. 
#' Only used if unmethy and methy are not set.
#' @param correlation Type of correlation to evaluate (negative or positive).
#' Negative (default) checks if hypomethylated region has a upregulated target gene. 
#' Positive checks if region hypermethylated has a upregulated target gene. 
#' @param Meths A matrix contains methylation for each probe (row) and each sample (column).
#' @param Exps A matrix contains Expression for each gene (row) and each sample (column).
#' @param methy Index of M (methylated) group.
#' @param unmethy Index of U (unmethylated) group.
#' @importFrom stats wilcox.test
#' @importFrom utils head tail
#' @return U test results
Stat.nonpara <- function(
    Probe,
    NearGenes,
    Top = NULL,
    correlation = "negative",
    unmethy = NULL,
    methy  = NULL,
    Meths = Meths,
    Exps = Exps
){
  
  if(!length(Probe) == 1) stop("Number of  Probe should be 1")
  
  NearGenes.set <- NearGenes[NearGenes$ID == Probe,]
  Gene <- NearGenes.set[,2]
  Exp <- Exps[Gene,,drop = FALSE]
  Meth <- Meths
  if(is.null(methy) & is.null(unmethy)){
    idx <- order(Meth)
    nb <- round(length(Meth) * Top)
    unmethy <- head(idx, n = nb) 
    methy <- tail(idx, n = nb) 
  } 
  # Here we will test if the Expression of the unmethylated group is higher than the exptression of the methylated group
  test.p <- unlist(
    lapply(
      splitmatrix(Exp),
      function(x) {
        tryCatch({
          wilcox.test(
            x[unmethy],
            x[methy],
            alternative = ifelse(correlation == "negative","greater","less"),
            exact = FALSE
          )$p.value},
          error = function(x){
            NA
          })
      }
    )
  )
  
  if(length(Gene)==1){
    Raw.p <- test.p
  } else {
    Raw.p <- test.p[match(Gene, names(test.p))]
  }
  
  # In case Symbol is not in the input file
  if(!"Symbol" %in% colnames(NearGenes.set)) NearGenes.set$Symbol <- NA
  
  out <- data.frame(
    Probe    = rep(Probe,length(Gene)),
    GeneID   = Gene,
    Symbol   = NearGenes.set$Symbol, 
    Distance = NearGenes.set$Distance, 
    Sides    = NearGenes.set$Side,
    Raw.p    = Raw.p, 
    stringsAsFactors = FALSE
  )
  
  return(out)
}


#' Calculate empirical Pvalue
#' @param U.matrix A data.frame of raw pvalue from U test. Output from .Stat.nonpara
#' @param permu data frame of permutation. Output from .Stat.nonpara.permu
#' @return A data frame with empirical Pvalue.
Get.Pvalue.p <- function(U.matrix,permu){
  .Pvalue <- function(x,permu){
    Raw.p <- as.numeric(x["Raw.p"])
    Gene <- as.character(x["GeneID"])
    if(is.na(Raw.p)){
      out <- NA
    } else {
      #       num( Pp <= Pr) + 1
      # Pe = ---------------------
      #            x + 1
      # Pp = pvalue probe (Raw.p)
      # Pr = pvalue random probe (permu matrix)
      # We have to consider that floating Point Numbers are Inaccurate
      out <- (sum(permu[as.character(Gene),] - Raw.p < 10^-100, na.rm=TRUE) + 1) / (sum(!is.na(permu[Gene,])) + 1)
    } 
    return(out)
  }
  message("Calculate empirical P value.\n")
  Pvalue <- unlist(apply(U.matrix,1,.Pvalue,permu=permu))
  U.matrix$Pe <- Pvalue
  return(U.matrix)
}
