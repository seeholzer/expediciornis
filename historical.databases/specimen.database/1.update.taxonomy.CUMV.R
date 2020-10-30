##################################################
#	This is code used to develop and then convert the taxonomy of the CUMV vernet
#	Colombia database (download 2020.10.30) to Clements
#
#	Developed by: Glenn F. Seeholzer
#	Date: 2020.10.30
##################################################
setwd('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV')

library(plyr)
source('~/Dropbox/Chapman/expediciornis/supporting.R.functions/FUN.name.check.R', chdir = TRUE)

# clem = read.csv('~/Dropbox/Chapman/expediciornis/Clements-Checklist-v2019-August-2019.csv',stringsAsFactors=F)

# d = read.delim('CUMV_Colombia.2020-10-30.v4.txt',stringsAsFactors=F)

# d$Name.Verb = trimws(paste(trimws(d$Genus.Verb),trimws(d$Species.Verb),trimws(d$Subspecies.Verb)))
# Name.Verb = unique(d$Name.Verb)

# which(!Name.Verb %in% d$Name.Verb)

# colnames = c('Name.Verb','Subspecies','Name.Clem','Localities')
# key = data.frame(matrix(nrow=length(Name.Verb),ncol=length(colnames)))
# colnames(key) = colnames
# x = sapply(strsplit(Name.Verb,' '),'[',1:2)
# x = apply(x,2,function(y)paste(y,collapse=' '))
# key$Name.Verb = gsub('[ \t]+$','',x)
# key$Subspecies = sapply(strsplit(Name.Verb,' '),'[',3)
# 345
# for(i in 1:nrow(key)){
	# locs = d[grep(key$Name.Verb[i],d$Name.Verb),'Locality']
	# locs = table(locs)
	# counts = apply(cbind(names(locs),locs),1,paste,collapse='-')
	# tmp = paste(counts,collapse='; ')
	# key[i,'Localities'] = tmp
# }

# clem = read.csv('~/Dropbox/Clements/Clements-Checklist-v2019-August-2019.csv')

# #transfer all names that are perfect matches to a Clements Name to Clements column
# key[key$Name.Verb %in% clem$scientific.name,'Name.Clem'] = key[key$Name.Verb %in% clem$scientific.name,'Name.Verb']


# write.table(key,'CUMV.taxonomy.key.raw.txt',row.names=F,col.names=T,sep='\t',quote=F)





##################################################
#	Use completed taxonomy key to convert to Clements

d = read.delim('CUMV_Colombia.2020-10-30.v4.txt',stringsAsFactors=F)
clem = read.csv('~/Dropbox/Chapman/expediciornis/Clements-Checklist-v2019-August-2019.csv',stringsAsFactors=F)

key = read.delim('CUMV.taxonomy.key.txt',stringsAsFactors=F)
key$Verb = trimws(paste(key$Name.Verb,key$Subspecies))

Name.Verb = trimws(paste(trimws(d$Genus.Verb),trimws(d$Species.Verb),trimws(d$Subspecies.Verb)))

name.check(unique(Name.Verb),key$Verb)

Name.Clem = trimws(mapvalues(Name.Verb,key[,'Verb'],key[,'Name.Clem']))

d$Genus.Clem = sapply(strsplit(Name.Clem,' '),'[',1)
d$Species.Clem = sapply(strsplit(Name.Clem,' '),'[',2)

Name = paste(d$Genus.Clem,d$Species.Clem)
unique(Name)[!unique(Name) %in% clem$scientific.name]


write.table(d,'CUMV_Colombia.2020-10-30.v5.txt',col.names=T,row.names=F,quote=F,sep='\t')








