##################################################
#	This is code used to develop and then convert the outdated taxonomy of the original version
#	of the AMNH database I received from Tom Trombone on 10 Sept 2019.
#
#	Developed by: Glenn F. Seeholzer
#	Date: 2020.05.26
##################################################


library(plyr)
source('~/Dropbox/FUN.name.check.R', chdir = TRUE)
setwd('~/Dropbox/Chapman.Database/AMNH')
files = list.files(pattern='AMNH_Colombia',full.names=T)
files = files[order(files)]
d = read.delim(files[length(files)],stringsAsFactors=F)

tmp = d[!(d$StndName %in% ''), ]

tmp$Name.Verb = paste(tmp$Genus.Verb,tmp$Species.Verb,tmp$Subspecies.Verb)

foo = as.data.frame.matrix(table(tmp$Name.Verb,tmp$StndName))

colnames = c('Name.Verb','Subspecies','Name.Clem','Localities')
key = data.frame(matrix(nrow=nrow(foo),ncol=length(colnames)))
colnames(key) = colnames
x = sapply(strsplit(rownames(foo),' '),'[',1:2)
x = apply(x,2,function(y)paste(y,collapse=' '))
key$Name.Verb = gsub('[ \t]+$','',x)
key$Subspecies = sapply(strsplit(rownames(foo),' '),'[',3)
i = 2
for(i in 1:nrow(key)){
	locality = colnames(foo)[!(foo[i,] %in% 0)]
	n = as.numeric(foo[i,!(foo[i,] %in% 0)])
	tmp = apply(cbind(locality,n),1,function(x) paste(x,collapse='-'))
	tmp = paste(tmp,collapse='; ')
	key[i,'Localities'] = tmp
}

clem = read.csv('~/Dropbox/Clements/Clements-Checklist-v2019-August-2019.csv')

key[key$Name.Verb %in% clem$scientific.name,'Name.Clem'] = key[key$Name.Verb %in% clem$scientific.name,'Name.Verb']
head(key)

write.table(key,'~/Dropbox/Chapman.Database/AMNH/taxonomy.key.txt',row.names=F,col.names=T,sep='\t',quote=F)




library(plyr)
source('~/Dropbox/FUN.name.check.R', chdir = TRUE)
setwd('~/Dropbox/Chapman.Database/AMNH')
files = list.files(pattern='AMNH_Colombia',full.names=T)
files = files[order(files)]
d = read.delim(files[length(files)],stringsAsFactors=F)
d$Verb = trimws(paste(d$Genus.Verb,d$Species.Verb,d$Subspecies.Verb))

tmp = d[!(d$StndName %in% ''), ]

key = read.delim('~/Dropbox/Chapman.Database/AMNH/taxonomy.key.v1.txt',stringsAsFactors=F)
key$Verb = trimws(paste(key$Genus,key$Species,key$Subspecies))

name.check(tmp$Verb, key$Verb)

Name.Clem = mapvalues(tmp$Verb,key[,'Verb'],key[,'Name.Clem']) 
tmp$Genus.Clem = sapply(strsplit(Name.Clem,' '),'[',1)
tmp$Species.Clem = sapply(strsplit(Name.Clem,' '),'[',2)

head(tmp)
new = rbind(tmp,d[(d$StndName %in% ''), ])

write.table(new,paste0('AMNH_Colombia.',gsub(':','.',Sys.time()),'.txt'),quote=F,row.names=F,col.names=T,sep='\t')



#write.table(key,'~/Dropbox/Chapman.Database/AMNH/taxonomy.key.v1.txt',row.names=F,col.names=T,sep='\t',quote=F)



