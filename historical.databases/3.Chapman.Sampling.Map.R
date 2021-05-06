library(raster)
library(maptools)
library(plyr)
library(readxl)

setwd('~/Dropbox/Chapman/expediciornis')

#	load supporting functions
source('supporting.R.functions/FUN.add.alpha.R', chdir = TRUE)
scale.arbitrary <- function(x,tmin,tmax){ (((x-min(x,na.rm = T))/(max(x,na.rm = T)-min(x,na.rm = T)))*(tmax - tmin)) + tmin }

# Load Data
gaz = read_excel("historical.databases/Gazetteer_Chapman_Colombia_Expeditions.xlsx")
gaz = data.frame(gaz)

counts = read.delim('historical.databases/Chapman1917/Chapman1917.Database.txt',stringsAsFactors=F)

# Combine Data
tmp = aggregate(Count ~ Locality,data=counts,FUN=sum)
data = merge(tmp,gaz[,c('Locality','Lat','Long')],all.x=T)

head(data)

#############################
####	Shapefiles
#############################
alt = raster('layers/COL_msk_alt/COL_msk_alt.grd')
adm0 = readShapeSpatial('layers/COL_adm/COL_adm0_edit.shp')
adm1 = readShapeSpatial('layers/COL_adm/COL_adm1.shp')
proj4string(adm0) = proj4string(adm1) = crs(alt)


png(filename = "historical.databases/Figure.sampling.map.Counts.png",
    width = 7, height = 7, units = "in", pointsize = 12,
     bg = "transparent",  res = 300)

#	plot base map
#dev.new(width=7,height=7)
par(mar=c(0,0,0,0))
breakpoints <- c(minValue(alt),1000,3500,maxValue(alt))
colors <- add.alpha(c("grey100","grey75","grey30"),1)
plot(alt,add=F,breaks=breakpoints,col=colors,useRaster=T,axes=F,box=F,legend=F,interpolate=F,maxpixels= dim(alt)[1]*dim(alt)[2]/1)
plot(adm1,lwd=.25,border='grey',col='transparent',add=T)
plot(adm0,col='transparent',add=T,lwd=.5)

#	add Bogota
points(-74.062330,4.8,pch=8,bg='grey25',cex=1 )
text(-74.2,4.9,'Bogota',pos=4,cex=.75,col='grey1')

#	clean plot data
tmp = data[!is.na(data$Lat) & !is.na(data$Long) & !is.na(data$Count), c('Locality','Lat','Long','Count') ]

#	get total specimnen counts for combined localities
#	NOTE: the counts for each separate locality are plotted below. 
#		The combined counts be plotted instead if desired.
focal = c('Honda','Toche|Laguneta','Aguadita|El Roble|Penon|Fusagasuga','La Morelia|Florencia','Barbacoas|Buenavista','San Agustin|La Candela|La Palma')

combined = c()
for(i in focal){
	foo = tmp[grepl(i,tmp$Locality), ]
	c = data.frame(
			Locality=i,
			Lat=mean(foo$Lat),
			Long=mean(foo$Long),
			Count=sum(foo$Count)	
			)
	combined = rbind(combined,c)
}

#tmp = rbind(tmp[!grepl(paste(focal,collapse='|'),tmp$Locality), ],combined)

#	reorder plot data so smaller circles appear above larger circles and focal localties above everything else
tmp = tmp[order(-tmp$Count),]

tmp = rbind(
	tmp[!grepl(paste(focal,collapse='|'),tmp$Locality), ],
	tmp[grepl(paste(focal,collapse='|'),tmp$Locality), ]
		)

#	xy coordinates
x = tmp$Long
y = tmp$Lat

#	create specimen count ranges 
h = hist(tmp$Count, plot = F,breaks=c(0,50,200,400,800))
tmp$bin = cut(tmp$Count,b=c(0,50,200,400,800))
levels(tmp$bin) = h$mids

#	colors of circles, coral for focal localities, pink (or whatever) for San Antonio
bg = rep('cadetblue1',nrow(tmp))
bg[grepl(paste(focal,collapse='|'),tmp$Locality)] = 'coral3'
bg[tmp$Locality %in% 'San Antonio'] = 'pink'

#	set circle radius and plot each locality
cex = scale.arbitrary(as.numeric(as.character(tmp$bin)),.5,4)
points(x,y,cex=cex,pch=21,col='black',bg=bg,lwd=.5)

#	create legend
key = data.frame(bin=levels(cut(tmp$Count,b=c(0,50,200,400,800))),label=c('<50','51-200','201-400','401-800'),cex=sort(unique(cex)))

x = rep(-78.1,4)
y = rev(seq(2.5, 4.5, length.out = 4)) + 1.25

points(x,y,cex=key[,'cex'],pch=21,col='grey50',bg=add.alpha('cadetblue1',.25))
text(x-.5,y,c('<50','51-200','201-400','401-800'),adj=c(1,.5),cex=.75)
text(unique(x)-.5,max(y)+.5,'N Specimens',cex=.75)

# segments(-75.46989,4.558151,-74.3,2.75)
# text(-74.5,2.75,'Laguneta',pos=4)

# segments(-75.66976,1.551737,-75.2,1)
# text(-75.4,1,'Resurvey',pos=4)
# text(-75.4,.6,'Expeditions',pos=4)

dev.off()




# # png(filename = "historical.databases/sampling.map.Localities.png",
    # width = 7, height = 7, units = "in", pointsize = 12,
     # bg = "transparent",  res = 300)

# #dev.new(width=7,height=7)
# par(mar=c(0,0,0,0))
# breakpoints <- c(minValue(alt),1000,3500,maxValue(alt))
# colors <- add.alpha(c("grey100","grey75","grey30"),1)
# plot(alt,add=F,breaks=breakpoints,col=colors,useRaster=T,axes=F,box=F,legend=F,interpolate=F,maxpixels= dim(alt)[1]*dim(alt)[2]/1)
# plot(adm1,lwd=.25,border='grey',col='transparent',add=T)
# plot(adm0,col='transparent',add=T,lwd=.5)

# tmp = data[!is.na(data$Lat) & !is.na(data$Long) & !is.na(data$Count), c('StndName','Lat','Long','Count') ]
# x = tmp$Long
# y = tmp$Lat

# points(x,y,cex=1,pch=21,col='black',bg='darkgoldenrod1',lwd=.5)

# dev.off()














