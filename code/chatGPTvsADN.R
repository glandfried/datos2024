oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"), width = 8, height = 5  )
setwd(this.dir)
##################################################



radio <- function(area){
    return(sqrt(area/pi))
}

radio(50)

plot(0,0,pch=19,cex=1,axes=F,xlab="",ylab="",lwd=3, col=rgb(0.2,0.6,0.2), xlim=c(-3,3), ylim=c(-3,3))
points(1,0,pch=19,cex=16)

# Define the radius of the circle
r <- 5  # You can change this value for a different radius

# Generate values from 0 to 2*pi for the angle
theta <- seq(0, 2 * pi, length.out = 100)

# Calculate x and y coordinates of the circle
x <- 8 * cos(theta)
y <- 8 * sin(theta)

# Plot the circle
plot(x, y, type = 'l', asp = 1, col = 'blue', main = paste('Circle with radius', r))


x <- 1 * cos(theta)
y <- 1 * sin(theta)

# Plot the circle
lines(x, y)


######
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)
