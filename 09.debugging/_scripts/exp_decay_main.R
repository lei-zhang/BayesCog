# =============================================================================
#### Info #### 
# =============================================================================
# debugging excercise: simple exponential decay model for memory retention task
#
# Lei Zhang, UKE, Hamburg, DE
# lei.zhang@uke.de
#
# Adapted from Lee & Wagenmakers, 2013

# =============================================================================
#### Construct Data #### 
# =============================================================================
# clear workspace
rm(list=ls(all=TRUE))

intervals <- c(1, 2, 4, 7, 12, 21, 35, 59, 99)
nt        <- length(intervals)
ns        <- 3
nItem     <- 18

k <- matrix(c(18, 18, 16, 13, 9, 6, 4, 4, 4,
              17, 13,  9,  6, 4, 4, 4, 4, 4,
              14, 10,  6,  4, 4, 4, 4, 4, 4), nrow=ns, ncol=nt, byrow=T)


dataList  <- list(k         = k,          # items remmebered
                  nItem     = nItem,      # total number of items
                  intervals = intervals,  # time intervals
                  ns        = ns,         # number of subjects
                  nt        = nt)         # number of trials


# =============================================================================
#### Running Stan #### 
# =============================================================================
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = 2)

nIter     <- 2000
nChains   <- 4 
nWarmup   <- floor(nIter/2)
nThin     <- 1

modelFile <- '_scripts/exp_decay_model_debugged.stan'

cat("Estimating", modelFile, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_mem <- stan(modelFile, 
                  data    = dataList, 
                  chains  = nChains,
                  iter    = nIter,
                  warmup  = nWarmup,
                  thin    = nThin,
                  init    = "random")#,
                  #seed    = 1450154626)

cat("Finishing", modelFile, "model simulation ... \n")
endTime = Sys.time(); print(endTime)  
cat("It took",as.character.Date(endTime - startTime), "\n")
