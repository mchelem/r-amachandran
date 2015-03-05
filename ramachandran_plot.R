#!/usr/bin/env Rscript

library(bio3d)

density_traces <- read.table(
  "data/rama500-general.data", 
  skip=6, 
  col.names=c("x", "y", "z")
)

ramachandran.plot <- function (pdb_filepath) {
  plot.new()
  plot.window(xlim=c(-180, 180), ylim=c(-180, 180))
  .filled.contour(
    x=unique(density_traces$x), 
    y=unique(density_traces$y), 
    z=matrix(density_traces$z, 180, 180, byrow=TRUE), 
    col=c("#FFFFFF","#B3E8FF","#7FD9FF"), 
    levels=as.double(c(0, 0.0005, 0.02, 1))
  )

  pdb = read.pdb(pdb_filepath, verbose=FALSE)
  torsion_angles = torsion.pdb(pdb)
  plot.xy(xy.coords(torsion_angles$phi, y=torsion_angles$psi), type="p", pch=20, cex=0.5)

  title(main=paste("Ramachandran Plot for", pdb_filepath), xlab=expression(phi), ylab=expression(psi))
  axis(1, at=c(-180, -90, 0, 90, 180))
  axis(2, at=c(-180, -90, 0, 90, 180))
}

if (!interactive()) {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) < 1) {
    stop("Invalid number of parameters\nUsage: ./ramachandran_plot.R <pdb_file>")
  }
  png(paste(args[1], ".png", ""))
  ramachandran.plot(args[1])
}
