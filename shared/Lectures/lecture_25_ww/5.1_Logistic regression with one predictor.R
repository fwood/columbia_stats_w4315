## Read the data
# Data are at http://www.stat.columbia.edu/~gelman/arm/examples/nes

# The R codes & data files should be saved in the same directory for
# the source command to work

source("4.7_Fitting a series of regressions.R") # where data was cleaned; set the directory to be where this file is

yr <- 1992
  ok <- nes.year==yr & presvote<3
  vote <- presvote[ok] - 1
  income <- data$income[ok]

 # Estimation
fit.1 <- glm (vote ~ income, family=binomial(link="logit"))
display(fit.1)

female <- data$gender[ok] - 1
fit.2 <- glm(vote ~ income * female, family=binomial(link="logit"))
display(fit.2)

pdf("fitted_model.pdf")
                                        # Graph figure 5.1 (a)
curve (invlogit(fit.1$coef[1] + fit.1$coef[2]*x), 1, 5, ylim=c(-.01,1.01),
       xlim=c(-2,8), xaxt="n", xaxs="i", mgp=c(2,.5,0),
       ylab="Pr (Republican vote)", xlab="Income", lwd=4)
curve (invlogit(fit.1$coef[1] + fit.1$coef[2]*x), -2, 8, lwd=.5, add=T)
axis (1, 1:5, mgp=c(2,.5,0))
mtext ("(poor)", 1, 1.5, at=1, adj=.5)
mtext ("(rich)", 1, 1.5, at=5, adj=.5)
points (jitter (income, .5), jitter (vote, .08), pch=20, cex=.1)
dev.off()

pdf("fitted_model_compare.pdf")
curve (invlogit(fit.2$coef[1] + fit.2$coef[2]*x + fit.2$coef[3] +
                fit.2$coef[4]*x), 1, 5, ylim=c(-.01,1.01),  xlim=c(0,6),
       xaxt="n", xaxs="i", mgp=c(2,.5,0),
       ylab="Pr (Republican vote)", xlab="Income", lwd=4)
curve (invlogit(fit.2$coef[1] + fit.2$coef[2]*x), 1, 5, lwd=4, lty=2, add = T )
axis (1, 1:5, mgp=c(2,.5,0))
mtext ("(poor)", 1, 1.5, at=1, adj=.5)
mtext ("(rich)", 1, 1.5, at=5, adj=.5)
points (jitter (income, .5), jitter (vote, .08), pch=20, cex=.1)
dev.off()

 # Graph figure 5.1 (b)
sim.1 <- sim(fit.1)
curve (invlogit(fit.1$coef[1] + fit.1$coef[2]*x), .5, 5.5, ylim=c(-.01,1.01),
         xlim=c(.5,5.5), xaxt="n", xaxs="i", mgp=c(2,.5,0),
         ylab="Pr (Republican vote)", xlab="Income", lwd=1)
  for (j in 1:20){
    curve (invlogit(sim.1$coef[j,1] + sim.1$coef[j,2]*x), col="gray", lwd=.5, add=T)
  }
  curve (invlogit(fit.1$coef[1] + fit.1$coef[2]*x), add=T)
  axis (1, 1:5, mgp=c(2,.5,0))
  mtext ("(poor)", 1, 1.5, at=1, adj=.5)
  mtext ("(rich)", 1, 1.5, at=5, adj=.5)
  points (jitter (income, .5), jitter (vote, .08), pch=20, cex=.1)

 # Graph figure 5.2(a)
 pdf('logistic_curve.pdf')
 ylab <- expression(plain(logit)^{-1}*(x))
 main <- expression(paste("y=",plain(logit)^{-1}*(x)))
 curve(invlogit(x), -6, 6, ylim=c(-.01, 1.01), xlim=c(-6,6), mgp=c(2,.5,0), ylab=ylab, main=main)
 text(1.5, .5, "slope=1/4")
 points(c(-6, 0), c(.5,.5), type='l', lty=2)
 points(c(0,0), c(0,.5), type='l', lty=2)
 dev.off()


# Residual plot and binned residual plot
pdf("residual.pdf")
plot(c(0,1), c(-1,1), xlab="Estimated  Pr (Republican)", ylab="Observed - estimated", type="n", main="Residual plot", mgp=c(2,.5,0))
abline (0,0, col="gray", lwd=.5)
points(jitter(fit.1$fit,1), jitter(vote[!is.na(vote)]-fit.1$fit,1), pch=20, cex=.2)
dev.off()

# Define binned residual plot
binned.resids <- function (x, y, nclass=sqrt(length(x))){
  breaks.index <- floor(length(x)*(1:(nclass-1))/nclass)
  breaks <- c (-Inf, sort(x)[breaks.index], Inf)
  output <- NULL
  xbreaks <- NULL
  x.binned <- as.numeric (cut (x, as.numeric(breaks)))
  for (i in 1:nclass){
    items <- (1:length(x))[x.binned==i]
    x.range <- range(x[items])
    xbar <- mean(x[items])
    ybar <- mean(y[items])
    n <- length(items)
    sdev <- sd(y[items])
    output <- rbind (output, c(xbar, ybar, n, x.range, 2*sdev/sqrt(n)))
  }
  colnames (output) <- c ("xbar", "ybar", "n", "x.lo", "x.hi", "2se")
  return (list (binned=output, xbreaks=xbreaks))
}

 ## Binned residuals vs. estimated probability of switching (Figure 5.13 (b))
x <- fit.1$fit+rnorm(length(fit.1$fit), 0, .01)
y <- vote[!is.na(vote)]-fit.1$fit + rnorm(length(x), 0, .01)
br.8 <- binned.resids (x,y)[[1]]
pdf("binned_residual.pdf")
plot(range(br.8[,1]), range(br.8[,2],br.8[,6],-br.8[,6]), xlab="Estimated  Pr (Republican)", ylab="Average residual", type="n", main="Binned residual plot", mgp=c(2,.5,0))
abline (0,0, col="gray", lwd=.5)
lines (br.8[,1], br.8[,6], col="gray", lwd=.5)
lines (br.8[,1], -br.8[,6], col="gray", lwd=.5)
points (br.8[,1], br.8[,2], pch=19, cex=.5)
dev.off()
