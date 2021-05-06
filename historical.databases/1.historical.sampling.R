##################################################
#	This is code to collate and summarize the two databases
#	
#	1. Specimen Database - Combined AMNH and Cornell databases.
#		AMNH data transcribed and digitized from the original 
#		handwritten AMNH specimen ledgers by AMNH volunteers.
#	2. Chapman 1917 - database derived from the specimen 
#		counts per locality that appear below each species' account 
#		in the Chapman 1917 monograph.
#	
#	Developed by: Glenn F. Seeholzer
#	Date: 2020.10.29
##################################################
#Set working directory
setwd('~/Dropbox/Chapman/expediciornis/historical.databases/')

#load packages and supporting functions
library(plyr)
library(readxl)


#Observed specimen counts: AMNH database
o = read.delim('specimen.database/Specimen.Database.v1.txt',stringsAsFactors=F)
#o = read.delim('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/AMNH_Colombia.2020-10-29.txt',stringsAsFactors=F)
o = o[!o$Locality %in% '', ]
o$Name = paste(o$Genus.Clem,o$Species.Clem)

#Reported specimen counts: Chapman 1917
r = read.delim('Chapman1917/Chapman1917.Database.txt',stringsAsFactors=F)

r[r$Locality %in% 'La Candela', ]

#convert AMNH DB into specimen count format of Chapman 1917
loc = c('Aguadita','Los Robles','El Penon','Fusagasuga')
foo = o[o$Locality %in% loc, ]
foo = split(foo$Name,f=foo$Locality) #split only specimen names into a list of separate dataframes by locality 
foo = lapply(foo,function(x)data.frame(table(x))) #create table of specimen counts for each locality in this list
for(l in 1:length(foo)){
	foo[[l]]$Locality = names(foo)[l] #add locality column
	colnames(foo[[l]]) = c('Name','Count','Locality') #Change column names
	foo[[l]] = foo[[l]][,c('Name','Locality','Count')]
}	
foo = do.call(rbind,foo)
rownames(foo) = NULL

spec = foo
chap = r[r$Locality %in% loc, ]
tmp = merge(spec,chap,by=c('Name','Locality'),all=T)
colnames(tmp) = c('Name','Locality','Count.spec','Count.chap')
tmp[is.na(tmp)] = 0
tmp$dif = tmp$Count.spec - tmp$Count.chap
tmp = tmp[order(tmp$dif), ]
tmp[order(tmp$Name), ]

comp = merge(spec[,c('Name','spec')],chap[,c('Name','chap')],by='Name',all=T)
comp[is.na(comp)] = 0
comp$dif = comp$spec - comp$chap
comp = comp[order(comp$dif), ]
comp[!comp$dif %in% 0 & !comp$spec %in% 0 & !comp$chap %in% 0, ]
comp[comp$spec %in% 0 | comp$chap %in% 0, ]


length(which(comp$dif != 0))
length(which(comp$spec %in% 0 | comp$chap %in% 0))
length(which(comp$spec %in% 0))
length(which(comp$chap %in% 0))



source('~/Dropbox/FUN.add.alpha.R', chdir = TRUE)
plot(jitter(tmp$Count.spec),jitter(tmp$Count.chap),pch=21,bg=add.alpha('black',0.1),col='transparent',cex=2,)








##################################################
##################################################
#Compare Specimen Counts for each species at a given locality between AMNH database and Chapman 1917
# some possibilities below

#Pilot Expedition
loc = c('Laguneta','Rio Toche')
filename = "Sampling.ExpPiloto.Laguneta-RioToche.xlsx"

#Expedition 1 - Fusagasuga
loc = c('Aguadita','Los Robles','El Penon','Fusagasuga')
filename = "Sampling.Exp1.Fusugasuga.xlsx"

#Expedition 2 - Honda
loc = c('W of Honda','Honda','El Consuelo')
filename = "Sampling.Exp2.Honda.xlsx"

###############

#Expedition - San Agustin
loc = c('San Agustin','La Palma','La Candela')
filename = "Sampling.Exp.SanAgustin.xlsx"

#Expedition - Barbacoas
loc = c('Barbacoas','Buenavista')
filename = "Sampling.Exp.Barbacoas.xlsx"

#Expedition - Florencia
loc = c('Florencia','La Morelia')
filename = "Sampling.Exp.Florencia.xlsx"

#Expedition - Valle de Cauca
loc = c('Miraflores','La Manuelita','Palmira','Florida','Guengue')
filename = "Sampling.Exp.ValleDeCauca.xlsx"

#Expedition - Valle de Cauca
loc = c("Paramo Santa Isabel")
filename = "Sampling.Exp.SantaIsabel.xlsx"

#check to ensure they are spelled as in the databases
	loc %in% unique(o$Locality) #AMNH database
	loc %in% unique(r$Locality) #Chapman 1917

###########
#	create table of specimens counts for each species per locality for observed and reported

#AMNH - observed in AMNH specimen database
#must merge specimen count tables for combination localities
	if(length(loc) > 1){ 
	foo = o[o$Locality %in% loc, ]
	foo = split(foo$Name,f=foo$Locality)
	foo = lapply(foo,function(x)data.frame(table(x)))
	for(l in 1:length(foo))	colnames(foo[[l]]) = c('Name',names(foo)[l]) #Change column names
	foo = join_all(foo,by='Name',type='full')
	#foo = data.frame(Name = foo$Name, Regional = apply(foo[,-1],1,sum,na.rm=T),foo[,-1])
	}else{
	foo = data.frame(table(o[o$Locality %in% loc,'Name']))
	colnames(foo) = c('Name',loc)
	}
	
	spec = foo[order(foo$Name), ]
	colnames(spec)[-1] = paste0(colnames(spec)[-1],'.spec')

#chap - reported in Chapman 1917
#must merge specimen count tables for combination localities
	if(length(loc) > 1){ 
	foo = r[r$Locality %in% loc, ]
	x = split(foo[,c('Name','Count')],f=foo$Locality)
	for(l in 1:length(x))	colnames(x[[l]])[2] = names(x)[l] #Change column names
	foo = join_all(x,by='Name',type='full')
	#foo = data.frame(Name = foo$Name, Regional = apply(foo[,-1],1,sum,na.rm=T),foo[,-1])
	}else{
	foo = r[r$Locality %in% loc,c('Name','Count')]
	colnames(foo) = c('Name',loc)
	}
	
	chap = foo[order(foo$Name), ]
	colnames(chap)[-1] = paste0(colnames(chap)[-1],'.chap')




###########
#	Create a summary table of specimen counts per species for each locality or regional meta-locality
#	When the counts from the spec db and Chapman 1917 differ:
#	- used highest count for the 'final' count, and included the alternative count as a note
#	- gegional count total is the sum of the highest count total from each locality
	tmp = merge(spec,chap,by='Name',all=T)
	tmp[is.na(tmp)] = 0
	
	colnames = c('Name',c(rbind(loc,paste0('note.',loc))))
	sum = data.frame(matrix(nrow=nrow(tmp),ncol=length(colnames)))
	colnames(sum) = colnames
	sum$Name = tmp$Name
	
	i = loc[1]
	for(i in loc){
		x = tmp[,colnames(tmp)[grep(i,colnames(tmp))]]
		colnames(x) = c('spec','chap')
		dif = x[,1] - x[,2]
		count = rep(NA,length(dif))
		note = rep('',length(dif))
		for(f in 1:length(dif)){
			if(dif[f] == 0){ note[f] = ''; count[f] = x[f,'spec'] } 
			if(dif[f] > 0){ note[f] = paste0(x[f,'chap'],'-chap'); count[f] = x[f,'spec'] }
			if(dif[f] < 0){ note[f] = paste0(x[f,'spec'],'-spec'); count[f] = x[f,'chap'] }
		}
		sum[,i] = count
		sum[,paste0('note.',i)] = note
	}


#Add families and a taxonomic sort 
	path_to_clements = '~/Dropbox/Chapman/expediciornis/Clements-Checklist-v2019-August-2019.csv' 
	clem = read.csv(path_to_clements)
	
	#add families
	fam = as.character(mapvalues(sum$Name,clem$scientific.name,clem$family,warn_missing = F))
	fam[grep('NA',fam)] = ''
	fam = sapply(strsplit(fam,' '),'[',1)
	#fam[duplicated(fam)] = ''
	sum = cbind(Family = fam, sum)

	#taxonomic sort
	sum[,'Name'] = as.character(sum[,'Name'])
	sort = as.numeric(mapvalues(sum$Name,clem$scientific.name,clem$sort.v2019,warn_missing = F))
	sum = cbind(Sort=sort,sum)
	sum = sum[order(sum$Sort),]	
	
	
#split matrix up into analysis units
#	analysis unit = a locality or cluster of localities that will be grouped together for 
#		genetic or community analysis
#	metalocality = name of a cluster of localities grouped together in an analysis unit

gaz = read_excel('Gazetteer_Chapman_Colombia_Expeditions.xlsx')

key = data.frame(gaz[gaz$Locality %in% loc, c('Locality','MetaLocality')])
key[is.na(key$MetaLocality),'MetaLocality'] = key[is.na(key$MetaLocality),'Locality']

#create empty list to store the summary table for each analysis unit
locs = vector(mode = "list", length = length(unique(key$MetaLocality)))
names(locs) = unique(key$MetaLocality)

i = names(locs)[2]
for(i in names(locs)){
	
	locnames = key[key$MetaLocality %in% i,'Locality']
	column.indices = which(colnames(sum) %in% c(locnames,paste0('note.',locnames)))
	tmp = sum[,c(1:3,column.indices)]

	#remove species not recorded in analysis unit
	if(length(locnames) > 1){
			tmp = tmp[apply(tmp[,locnames],1,sum) != 0, ] 
		}else{
			tmp = tmp[tmp[,locnames] != 0, ]
	}
	#create Regional summary column for meta-localities
	if(length(locnames) > 1){
		tmp$Regional = apply(tmp[,locnames],1,sum,na.rm=T)
		tmp = tmp[,c('Sort','Family','Name','Regional',colnames(tmp)[grep(paste(loc,collapse='|'),colnames(tmp))])]
	}
	
	#add formatted 
	locs[[i]] = tmp
	
}

#examine results
lapply(locs,head)

###########
#make Excel workbook
library('openxlsx')
wb = createWorkbook()

## Loop through the list of split tables as well as their names
##   and add each one as a sheet to the workbook
names = names(locs)
#names = c('La Manuelita and others','Miraflores','Rio Frio')
Map(function(data, name){
    addWorksheet(wb, name)
    writeData(wb, name, data)
	}, locs, names)
 
## Save workbook to working directory
saveWorkbook(wb, file = filename, overwrite = TRUE)








#######
#	analyze count differentials between databases
#merge databases and determine count differential for each species

loc = 


if(length(loc) > 1){
	spec$spec = apply(spec[,grep('spec',colnames(spec))],1,sum,na.rm=T)
	chap$chap = apply(chap[,grep('chap',colnames(chap))],1,sum,na.rm=T)
}else{
	colnames(spec)[2] = 'spec'
	colnames(chap)[2] = 'chap'
	}

comp = merge(spec[,c('Name','spec')],chap[,c('Name','chap')],by='Name',all=T)
comp[is.na(comp)] = 0
comp$dif = comp$spec - comp$chap
comp = comp[order(comp$dif), ]
comp[!comp$dif %in% 0 & !comp$spec %in% 0 & !comp$chap %in% 0, ]
comp[comp$spec %in% 0 | comp$chap %in% 0, ]


length(which(comp$dif != 0))
length(which(comp$spec %in% 0 | comp$chap %in% 0))
length(which(comp$spec %in% 0))
length(which(comp$chap %in% 0))


dev.new(width=5,height=5)
par(mar=c(5,5,1,1))

max = max(abs(comp$dif))
breaks = c(-max:max)
#labels = sort(unique(c(seq(from=0,to=c(-max),-2),seq(from=0,to=c(max),2))))

hist(comp$dif, xaxt='n',xlim=range(breaks),breaks=breaks,main='',xlab='',ylab='Species')
axis(side=1, at=breaks-0.5, labels=breaks,cex.axis=.75)
mtext('More in AMNH DB >',1,line=2,cex=.75,at=.65*par('usr')[2])
mtext('< More in Chapman 1917',1,line=2,cex=.75,at=.65*par('usr')[1])
mtext('Specimen Count differences btwn. databases',1,line=3.5)
mtext(paste(loc,collapse='-'),3)



