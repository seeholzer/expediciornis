##################################################
#	This is code used to explore the extent and history of Chapman Colombia 
#	that were exchanged to other institutions
#
#	Developed by: Glenn F. Seeholzer
#	Date: 2020.11.02
##################################################

data = read.delim('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/Specimen.Database.v1.txt',stringsAsFactors=F)
data$Name = paste(data$Genus.Clem,data$Species.Clem)

#total number of AMNH specimens sent to other institutions
length(which(data$Institution %in% 'AMNH' & data$DeaccessionNotes != ''))
#AMNH Chapman Expedition specimens sent to other institutions 
length(which(data$Institution %in% 'AMNH' & data$DeaccessionNotes != '' & !data$Locality %in% ''))





nmnh = read.csv('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/NMNH/nmnhsearch-20201102195557.csv',stringsAsFactors=F)

tmp = data[grep('Exch. sent to U.S. National Museum',data$DeaccessionNotes), ]
dim(tmp)


amnh.collectors = c('Richardson','Chapman','Kerr','Miller','Allen','Cherrie','Gonazalez','Boyle')
x = nmnh[grepl(paste(amnh.collectors,collapse='|'),nmnh$Collector), ]
dim(x)



#	Question: do the AMNH numbers in the nmnh database correspond to AMNH numbers that are indicated to have been exchanged?

#	1. Parse AMNH numbers from NMNH database
tmp = nmnh[grep('AMNH',nmnh$FieldNumber),'FieldNumber']
x = sapply(strsplit(tmp,';'),'[')
x = trimws(unlist(lapply(x,function(x) x[grep('AMNH',x)])))
x = trimws(sapply(strsplit(x,'AMNH'),'[',2))
x = trimws(gsub('-|BIS','',x))

#	2. subset AMNH database with the parsed AMNH numbers above
data[data$CatalogNumber %in% x, 'DeaccessionNotes']

#	3. check to see if exchanged





