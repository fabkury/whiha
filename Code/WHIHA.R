## WHIHA
# -------
# Wireless Health in HIMSS Analytics
#
# By Raymonde Uy, MD, MBA, and Fabricio Kury, MD, Paul Fontelo, MD, MPH
# Project start: May 2015
# 

#
## Globals
data_dir <- "../Data/"
output_dir <- "../Output/"

load.libraries <- function(libraries_needed) {
  for(library_needed in libraries_needed)
    if(!library(library_needed, quietly=TRUE, logical.return=TRUE, character.only=TRUE)) {
      install.packages(library_needed)
      if(!library(library_needed, quietly=TRUE, logical.return=TRUE, character.only=TRUE))
        stop(paste("Unable to load library '", library_needed, "'.", sep=""))
    }
}

makeVennDiagramForYear <- function(year) {
  message("Connecting to Dorenfest database...")
  mdbconn <- odbcConnectAccess(paste0(data_dir, 'HADB ', year, '.mdb'))    
  
  A = unlist(sqlQuery(mdbconn, 
                      "select distinct HAEntityId from HandheldInfo where Value = 'Clinical Documentation';"))
  B = unlist(sqlQuery(mdbconn, 
                      "select distinct HAEntityId from HandheldInfo where Value = 'Email Access';"))
  C = unlist(sqlQuery(mdbconn, 
                      "select distinct HAEntityId from HandheldInfo where Value = 'Imaging';"))
  D = unlist(sqlQuery(mdbconn, 
                      "select distinct HAEntityId from HandheldInfo where Value = 'Practitioner Order Entry (CPOE)';"))
  E = unlist(sqlQuery(mdbconn, 
                      "select distinct HAEntityId from HandheldInfo where Value = 'View Patient Results';"))
  
  filename <- paste0('whiha_figure_4_y', year, '.tiff')
  message(paste0('Producing Venn diagram into file ', filename, '...'))
  venn.diagram(x = list(
    `Clinical Documentation` = A,
    `Email\nAccess` = B,
    `Imaging` = C,
    `CPOE` = D,
    `View Patient\nResults` = E),
    filename = paste0(output_dir, filename), col = "black",
    fill = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3", "orchid3"),   
    cex = c(1.5, 1.5, 1.5, 1.5, 1.5, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8, 
            1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8, 1, 1, 1, 1, 1, 1.5),
    cat.col = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3", "orchid3"),
    alpha = 0.50, cat.cex = 1.5, cat.fontface = "bold", margin = 0.1)
  message('Completed.')
  
  close(mdbconn)
}

#
## Execution starts here.

message("Codename: WHIHA - Wireless Health in HIMSS Analytics (c)")
message("By Raymonde Uy, MD, MBA, and Fabricio Kury, MD, Paul Fontelo, MD, MPH")
message("Code available at: http://github.com/fabkury")
message("Project start: May 2015")

message("Loading libraries...")
load.libraries(c('RODBC', 'VennDiagram'))

year_list <- c(2012, 2011, 2010, 2009, 2008, 2007, 2006, 2005);
for(year in year_list)
  makeVennDiagramForYear(year)

message('WHIHA program completed.\n')