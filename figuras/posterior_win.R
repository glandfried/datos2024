oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"),width = 8, height = 5 )
setwd(this.dir)
###############################

par(mar=c(3.75,3.75,0.25,0.25))


beta <- 25/6
#caso Equiop muy superior
mu <- c(25,30,25,25)
sigma <- c(8,1,1,1)
mu1_grilla <- seq(mu[1]-25,mu[1]+25,by=0.1)
posterior_ganador <- function(s_1_f,s_1_p,mu= c(25,20,20,20),sigma=c(8,1,1,1),beta=25/6){
  return(dnorm(s_1_f,mu[1],sigma[1])*pnorm(s_1_p,sum(mu[3:4])-(sum(mu[1:2])-mu[1]),sqrt(sum(sigma^2+beta^2)-sigma[1]^2)))
  
}
posterior_ganador2 <- function(s_1_f,s_1_p,mu= c(25,20,20,20),sigma=c(8,1,1,1),beta=25/6){
  return(dnorm(s_1_f,mu[1],sigma[1])*pnorm(0,sum(mu[3:4])-(sum(mu[1:2])-mu[1]+s_1_p),sqrt(sum(sigma^2+beta^2)-sigma[1]^2)))
}
posterior_ganador2 <- function(s_1_f,s_1_p,mu= c(25,20,20,20),sigma=c(8,1,1,1),beta=25/6){
  delta_s1 <- sum(mu[1:2])-sum(mu[3:4])-mu[1]+s_1_p
  vartheta1 <-sqrt(sum(sigma^2+beta^2)-sigma[1]^2)
  return(dnorm(s_1_f,mu[1],sigma[1])*pnorm(delta_s1/vartheta1))
}

m <- outer(mu1_grilla,mu1_grilla,posterior_ganador)
m2 <- outer(mu1_grilla,mu1_grilla,posterior_ganador2)
#m[250,250] ;m2[250,250]

levels <- seq(min(m),max(m),length.out = 11)

#abline(v=max_post,lty=2)
#axis(lwd=0,side=1, at=max_post,labels="max" ,las=0,cex.axis=1,line=-0.9)


beta <- 25/6

posterior_ganador <- function(s_1,mu,sigma,beta=25/6){
  return(dnorm(s_1,mu[1],sigma[1])*pnorm(s_1,sum(mu[3:4])-(sum(mu[1:2])-mu[1]),sqrt(sum(sigma^2+beta^2)-sigma[1]^2)))
}
prior <- function(s_1,mu,sigma,beta=25/6){
  return(dnorm(s_1,mu[1],sigma[1]))
}
sorpresa_de_ganar <- function(s_1,mu,sigma,beta=25/6){
  return(pnorm(s_1,mu[1]-(sum(mu[1:2])-sum(mu[3:4])),sqrt(sum(sigma^2+beta^2)-sigma[1]^2)))
}

posterior <- apply(diag(dim(m)[1],dim(m)[1])*m,2,sum)
index_max <- which.max(posterior)
max_post <- mu1_grilla[index_max]

ejes <- function(){
  axis(side=2, labels=NA,cex.axis=0.6,tck=0.015)
  axis(side=1, labels=NA,cex.axis=0.6,tck=0.015)
  axis(lwd=0,side=1, at=0, labels=0,cex.axis=1.25,line=-0.3)
  axis(lwd=0,side=1, at=mu[1], labels=expression(mu[1]),cex.axis=1.25,line=-0.85,tck=0.015)
  abline(v=mu[1],lty=3)
  mtext(text= expression(s[1]),side =1,line=2,cex=1.75)
  mtext(text ="Densidad" ,side =2,line=1,cex=1.75)
  
}

plot(mu1_grilla, prior(mu1_grilla,mu,sigma)/max(prior(mu1_grilla,mu,sigma)),lty=2,lwd=2,type="l",axes = F,ann = F)
ejes()
legend(mu1_grilla[12*length(mu1_grilla)%/%20],0.95,lty = c(2),lwd=c(2),
       legend = c("Priori"),bty = "n",cex = 1.5)



plot(mu1_grilla, prior(mu1_grilla,mu,sigma)/max(prior(mu1_grilla,mu,sigma)),lty=2,lwd=2,type="l",axes = F,ann = F)
lines(mu1_grilla, sorpresa_de_ganar(mu1_grilla,mu,sigma),lty=1,lwd=2)
ejes()
legend(mu1_grilla[12*length(mu1_grilla)%/%20],0.95,lty = c(2,1),lwd=c(2,2),
       legend = c("Priori","Predicción" ),bty = "n",cex = 1.5)
mid = mu[1]-(sum(mu[1:2])-sum(mu[3:4]))





plot(mu1_grilla, prior(mu1_grilla,mu,sigma)/max(prior(mu1_grilla,mu,sigma)),lty=2,lwd=2,type="l",axes = F,ann = F)
lines(mu1_grilla, sorpresa_de_ganar(mu1_grilla,mu,sigma),lty=1,lwd=2)
ejes()
legend(mu1_grilla[12*length(mu1_grilla)%/%20],0.95,lty = c(2,1),lwd=c(2,2),
       legend = c("Priori","Predicción" ),bty = "n",cex = 1.5)
mid = mu[1]-(sum(mu[1:2])-sum(mu[3:4]))

yy <- c(sorpresa_de_ganar(mu1_grilla,mu,sigma),rep(1,length(mu1_grilla)))
xx <- c(mu1_grilla,rev(mu1_grilla))      
polygon(xx,yy,col=rgb(0,0,0,0.2),border=F)
segments(x0=10,x1=10, y0=sorpresa_de_ganar( 10,mu,sigma),y1=1)
text(8.5,0.575,"Sorpresa = 1 - predicción",srt=90, cex=1.5)


#
# plot(mu1_grilla, prior(mu1_grilla,mu,sigma)/max(prior(mu1_grilla,mu,sigma)),lty=2,lwd=2,type="l",axes = F,ann = F)
# lines(mu1_grilla, sorpresa_de_ganar(mu1_grilla,mu,sigma),lty=1,lwd=2)
# ejes()
# mid = mu[1]-(sum(mu[1:2])-sum(mu[3:4]))
#
# yy <- c(sorpresa_de_ganar(mu1_grilla,mu,sigma),rep(1,length(mu1_grilla)))
# xx <- c(mu1_grilla,rev(mu1_grilla))
# polygon(xx,yy,col=rgb(0,0,0,0.2),border=F)
# segments(x0=10,x1=10, y0=sorpresa_de_ganar( 10,mu,sigma),y1=1)
# text(8.5,0.575,"Sorpresa = 1 - likelihood",srt=90, cex=1.5)
#
# posterior2 <- sorpresa_de_ganar(mu1_grilla,mu,sigma)*prior(mu1_grilla,mu,sigma)/max(prior(mu1_grilla,mu,sigma))
# lines(mu1_grilla,posterior2 ,lty=4,lwd=2)
#
# legend(mu1_grilla[12*length(mu1_grilla)%/%20],0.95,lty = c(2,1,4),lwd=c(2,2,2),
#        legend = c("Priori","Predicción",expression("Posteriori"%prop%"") ),bty = "n",cex = 1.5)
#
#
# plot(mu1_grilla, prior(mu1_grilla,mu,sigma)/max(prior(mu1_grilla,mu,sigma)),lty=2,lwd=2,type="l",axes = F,ann = F)
# lines(mu1_grilla, sorpresa_de_ganar(mu1_grilla,mu,sigma),lty=1,lwd=2)
# ejes()
# mid = mu[1]-(sum(mu[1:2])-sum(mu[3:4]))
#
# yy <- c(sorpresa_de_ganar(mu1_grilla,mu,sigma),rep(1,length(mu1_grilla)))
# xx <- c(mu1_grilla,rev(mu1_grilla))
# polygon(xx,yy,col=rgb(0,0,0,0.2),border=F)
# segments(x0=10,x1=10, y0=sorpresa_de_ganar( 10,mu,sigma),y1=1)
# text(8.5,0.575,"Sorpresa = 1 - likelihood",srt=90, cex=1.5)
#

#
#
# posterior2 <- sorpresa_de_ganar(mu1_grilla,mu,sigma)*prior(mu1_grilla,mu,sigma)/max(prior(mu1_grilla,mu,sigma))
# lines(mu1_grilla,posterior2 ,lty=4,lwd=2)
#
# legend(mu1_grilla[12*length(mu1_grilla)%/%20],0.95,lty = c(2,1,4),lwd=c(2,2,2),
#        legend = c("Priori","Predicción",expression("Posteriori"%prop%"") ),bty = "n",cex = 1.5)
#
#
# points(mu[1],sorpresa_de_ganar(mu[1],mu,sigma),pch=19,cex=1.5)
# points(max_post,posterior2[index_max],cex=1.5)
#
#
# #abline(v=mid,lty=3)
# #abline(h=sorpresa_de_ganar(mu[1],mu,sigma),lty=3)
#
# #y <- 0.1
# #segments(mid,y,mu[1],y,lwd=2)
# #segments(mid,y+.01,mid,y-0.01,lwd=2)
# #segments(mu[1],y+.01,mu[1],y-.01,lwd=2)
# #text(mid + (mu[1]-mid)/2, y+0.02,expression(delta) ,cex=1.33)

plot(mu1_grilla, prior(mu1_grilla,mu,sigma)/max(prior(mu1_grilla,mu,sigma)),lty=2,lwd=2,type="l",axes = F,ann = F)
lines(mu1_grilla, sorpresa_de_ganar(mu1_grilla,mu,sigma),lty=1,lwd=2)
ejes()
mid = mu[1]-(sum(mu[1:2])-sum(mu[3:4]))

yy <- c(sorpresa_de_ganar(mu1_grilla,mu,sigma),rep(1,length(mu1_grilla)))
xx <- c(mu1_grilla,rev(mu1_grilla))      
polygon(xx,yy,col=rgb(0,0,0,0.2),border=F)

segments(x0=10,x1=10, y0=sorpresa_de_ganar( 10,mu,sigma),y1=1)
text(8.5,0.575,"Sorpresa = 1 - predicción",srt=90, cex=1.5)

posterior2 <- sorpresa_de_ganar(mu1_grilla,mu,sigma)*prior(mu1_grilla,mu,sigma)/max(prior(mu1_grilla,mu,sigma))
lines(mu1_grilla,posterior2 ,lty=4,lwd=2)

legend(mu1_grilla[12*length(mu1_grilla)%/%20],0.95,lty = c(2,1,4),lwd=c(2,2,2),
       legend = c("Priori","Predicción",expression("Posteriori"%prop%"") ),bty = "n",cex = 1.5)


points(mu[1],sorpresa_de_ganar(mu[1],mu,sigma),pch=19,cex=1.5)
points(max_post,posterior2[index_max],cex=1.5)

yy <- c(posterior2,rep(0,length(mu1_grilla)))
xx <- c(mu1_grilla,rev(mu1_grilla))      
polygon(xx,yy,col=rgb(0,0,0,0.1),border=F)


#text(max_post,0.15,"Evidencia",srt=0, cex=1.33)


#######################################
# end 
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
#########################################
