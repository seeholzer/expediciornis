##################################################
#	This is code to create KML file of Chapman Localities
#	The specimen count is appened to each locality's name in the final KML
#
#	Developed by: Glenn F. Seeholzer
#	Date: 2020.11.02
##################################################
#set working directory
setwd('~/Dropbox/Chapman/expediciornis/historical.databases')

#load packages, settings, and functions
library(plotKML)
library(sp)
library(readxl)
library(plyr)
options(scipen=999)
source('~/Dropbox/Chapman/expediciornis/supporting.R.functions/FUN.name.check.R', chdir = TRUE)


#Chapman 1917 Locality Gazetteer
locs = as.data.frame(read_excel('Gazetteer_Chapman_Colombia_Expeditions.xlsx'))

#Reported specimen counts: Chapman 1917
#Most complete for the most localities
data = read.delim('Chapman1917/Chapman1917.Database.txt',stringsAsFactors=F)


#check to make sure all localities in Chapman 1917 are in Gazetteer
all(unique(data$Locality) %in% locs$Locality)
#which localities in Chapman 1917 aren't in Gazetteer
unique(data$Locality)[!unique(data$Locality) %in% locs$Locality]


#plotting data
#merge Chapman 1917 and Gazetteer Lat Long
x = split(data[,c('Name','Count')],f=data$Locality)
x = unlist(lapply(x,function(x)sum(x[,2])))
foo = data.frame(Locality = names(x), SpecimenCount = as.numeric(x),stringsAsFactors=F)
foo = merge(foo,locs[,c('Locality','Lat','Long')],all.x=T)

########
##Create KML
#######

	foo = foo[!is.na(foo$Lat), ]
	file = paste0('Localidades.Chapman.kml')
	
	colnames(foo)[grep('Lat',colnames(foo))] = 'LAT'
	colnames(foo)[grep('Long',colnames(foo))] = 'LONG'
	coordinates(foo) = ~LONG+LAT #represents X+Y
	proj4string(foo) <- CRS("+proj=longlat +datum=WGS84")

	shape = "http://maps.google.com/mapfiles/kml/pal2/icon18.png"
		
	foo$labels[!is.na(foo$SpecimenCount)] = paste0(foo$Locality[!is.na(foo$SpecimenCount)],'_',foo$SpecimenCount[!is.na(foo$SpecimenCount)])
	foo$labels[is.na(foo$SpecimenCount)] = foo$Locality[is.na(foo$SpecimenCount)]
		
	kml.name = 'Localidades.Chapman'
	point.size = 0.5
	label.size = 0.75
	label.color = '#ff3f8ff4'

	#create base kml file
		kml(obj=foo,shape=shape,labels=foo$labels,file.name=file)
	#Edit base kml html code
		lines = readLines(file)
	#Point size
		indices = grep('<color>',lines)+1
		lines[indices] = gsub('0.5',point.size,lines[indices])
	#Label size
		indices = grep('<LabelStyle>',lines)+1
		lines[indices] = gsub('0.5',label.size,lines[indices])
	#Label color
		indices = grep('<color>',lines)
		new.color.html = paste0('<color>', label.color,'</color>') 
		lines[indices] = gsub('<color>.*</color>',new.color.html,lines[indices])
	#kml name
		indices = grep('<name>.*</name>',lines)[1]
		new.name.html = paste0('<name>',kml.name,'</name>') 
		lines[indices] = gsub('<name>.*</name>',new.name.html,lines[indices])
	#write lines
		writeLines(lines,file)

