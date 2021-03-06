library(MASS)
momestimator<-function(vec0,funcname){
  n=length(vec0)
  meanv=mean(vec0)
  snv=sum((vec0-meanv)^2)
  sumv=sum(vec0)
  sqrv=sum(vec0^2)

  if (funcname=="Pointmass"){
    ahat<-sumv/n
    cat("ahat=",ahat)
  }

  else if (funcname=="Bernoulli" | funcname=="Chisq"){
    phat<-sumv/n
    cat("phat=",phat)
  }

  else if (funcname=="Binomial"){
    #np=sumv/N
    #np(1-p)=snv/N
    #1-p=snv/N/(sumv/N)
    #p=1-snv/sumv
    phat=1-(snv/sumv)
    nhat=sumv/(n*phat)
    #n=sumv/N*phat
    cat("phat=",phat,"nhat=",nhat)
  }

  else if (funcname=="Geometric"){
    #In R rgenom is return failure time before success so E=(1-p)/p
    #phat=1/((sumv/n)+1)
    phat=1/((sumv/n)+1)
    cat("phat=",phat)
  }

  else if (funcname=="Poisson"){
    lambdahat=sumv/n
    cat("lambdahat=",lambdahat)
  }

  else if (funcname=="Uniform"){
    #(a+b)/2=sumv/N
    #b=(2*sumv/N)-a
    #(b-a)^2/12=snv/N
    #(((2*sumv/N)-a)-a)^2/12=snv/N
    #(sumv/N-a)^2/3=snv/N
    #sumv/N-a=sqrt(snv*3/N)
    #a=sumv/N-sqrt(snv*3/N)
    #b=sumv/N+sqrt(snv*3/N)
    a=sumv/n-(sqrt(3*snv/n))
    b=sumv/n+(sqrt(3*snv/n))
    cat("alpha=",a,"beta=",b)
  }

  else if (funcname=="Normal"){
    mu=sumv/n
    sig2=snv/n
    cat("mu=",mu,"sigmasquare=",sig2)
  }

  else if (funcname=="Exponential"){
    beta=sumv/n
    cat("beta=",beta)
  }

  else if (funcname=="Gamma"){
    #a*b=sumv/n
    #(sumv/n)*b=snv/n
    #b=snv/sumv
    #a=sumv^2/n*snv
    b=snv/sumv
    a=(sumv^2)/(snv*n)
    cat("alpha=",a,"beta=",b)
  }

  else if (funcname=="Beta"){
    #a/(a+b)=sumv/n
    #b=a*(1-sumv/n)/(sumv/n)...1
    #snv/n=a*b/(a+b)^2*(a+b+1)...2
    #put1 in 2->snv/n=(sumv/n)^2*(1-(sumv/n))/(a+sumv/n)
    #a=(sumv/n)*(((sumv/n)*(1-(sumv/n)))/(snv/n)-1)
    #b=a(1-sumv/n)/(sumv-n)
    a=(sumv/n)*(((sumv/n)*(1-(sumv/n)))/(snv/n)-1)
    b=(1-sumv/n)*(((sumv/n)*(1-(sumv/n)))/(snv/n)-1)
    cat("alpha=",a,"beta=",b)
  }

  else if (funcname=="T"){
    #mu^2+sig^2=sqrv/n
    #mu=0
    #sig^2=sqrv/n
    #v/(v-2)=sqrv/n
    #v=(sqrv/n)*v-2*sqrv/n
    #(1-sqrv/n)*v=-2*sqrv/n
    v=-(2*sqrv/n)/(1-sqrv/n)
    cat("v=",v)
  }

  else if(funcname=="Multinomial"){
    phat<-NULL
    n=length(vec0[1,])
    snv<-NULL
    meanv<-NULL
    sumv<-NULL
    sqrv<-NULL
    for (i in 1:nrow(vec0)){
      meanv<-c(meanv,mean(vec0[i,]))
      snv<-c(snv,sum((vec0[i,]-meanv[i])^2))
      sumv<-c(sumv,sum(vec0[i,]))
      phat<-c(phat,1-(snv[i]/sumv[i]))
    }
    cat("phat=",phat)
  } 
  
  else if (funcname=="Multivariate Normal"){
    mu=apply(vec0,2,mean)
    print(mu)
    sumi=t(vec0-mu)%*%(vec0-mu)
    sumi=sumi/1000
    cat("muhat",mu,"sigmahat",sumi)
  }

  else if (funcname=="Hypergeometric"){
    n0 = 13 # as per the problem, number of samples taken out is known

    num<-100*((sqrv/meanv) - n0)
    denom<-((sqrv/meanv) -meanv) - (1 - (meanv/n0))

    Nhat<-num / denom   # parameter N = population size

    Chat<- (Nhat * meanv) / n0  # parameter C = subclass 1 of 2 subclasses
    
    cat("Nhat",Nhat,"Chat",Chat)
  }

  else{
    print("Unknown distribution")
  }
}

momestimator(rbinom(1000,1,0.6),"Bernoulli")

momestimator(rbinom(1000,100,0.6),"Binomial")

momestimator(rgeom(1000,0.6),"Geometric")

momestimator(rpois(1000,3),"Poisson")

momestimator(runif(1000,1,4),"Uniform")

momestimator(rnorm(1000,1,4),"Normal")

momestimator(rexp(1000,1/6),"Exponential")

momestimator(rgamma(1000,3,1/15),"Gamma")

momestimator(rbeta(1000,3,15),"Beta")

momestimator(rchisq(1000,3),"Chisq")

momestimator(rt(1000,3),"T")

momestimator(rmultinom(1000,100,c(0.3,0.3,0.4)),"Multinomial")

# generate covariance matrix
Sigma <- matrix(c(10,3,3,2),2,2)
mvn=mvrnorm(n=1000, rep(0, 2), Sigma)
momestimator(mvn,"Multivariate Normal")

momestimator(rhyper(1000, 25, 45, 13),"Hypergeometric")   # 13 (fixed) is the known number of samples taken out
