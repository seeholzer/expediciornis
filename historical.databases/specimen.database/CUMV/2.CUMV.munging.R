
##################################################
##################################################
#create Date

for(i in 1:50) cat('#',sep='')

# d = read.delim('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV/CUMV_Colombia.2020-10-30.v1.txt',stringsAsFactors=F)
# str(d)

# d[,c('Year','Month','Day')] = apply(d[,c('Year','Month','Day')],2,as.character)

# unique(d[,c('Year','Month','Day')])

# d$Day[grep('\\b\\d\\b',d$Day)] = paste0('0',gsub(' ','',d$Day[grep('\\b\\d\\b',d$Day)]))
# d$Month[which(d$Month == '')] = NA
# d$Month[grep('\\b\\d\\b',d$Month)] = paste0('0',gsub(' ','',d$Month[grep('\\b\\d\\b',d$Month)]))

# d$Date = paste(d$Year,d$Month,d$Day,sep='.')

# write.table(d,'~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV_Colombia.2020-10-30.v2.txt',col.names=T,row.names=F,quote=F,sep='\t')

##################################################
##################################################

# #create locality key
# d = read.delim('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV/CUMV_Colombia.2020-10-30.v2.txt',stringsAsFactors=F)
# head(d)


# PreciseLocation.Verbatim = sort(unique(d[d$Year %in% c('1910','1911','1912','1913','1914','1915','1916','1917'),'PreciseLocation.Verbatim']))

# colnames = c('PreciseLocation.Verbatim','Locality')
# key = data.frame(matrix(nrow=length(PreciseLocation.Verbatim),ncol=length(colnames)))
# colnames(key) = colnames

# key$PreciseLocation.Verbatim = PreciseLocation.Verbatim

# write.table(key,'~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV/CUMV.locality.key.txt',col.names=T,row.names=F,sep='\t',quote=F)


##################################################
##################################################
#standardize locality names
# library(plyr)
# d = read.delim('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV/CUMV_Colombia.2020-10-30.v2.txt',stringsAsFactors=F)
# years = c('1910','1911','1912','1913','1914','1915','1916','1917')

# key = read.delim('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV/CUMV.locality.key.txt',stringsAsFactors=F)


# d[d$Year %in% years,'Locality'] = mapvalues(d[d$Year %in% years,'PreciseLocation.Verbatim'], key[,1],key[,2],)

# write.table(d,'~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV/CUMV_Colombia.2020-10-30.v3.txt',col.names=T,row.names=F,quote=F,sep='\t')


##################################################
##################################################
#	remove non-aves
d = read.delim('CUMV_Colombia.2020-10-30.v3.txt',stringsAsFactors=F)
key = read.delim('CUMV_Colombia.2020-10-30_draft.txt',stringsAsFactors=F)

bird.nums = key[key$class %in% 'Aves','catalognumber']

d = d[d$CatalogNumber %in% bird.nums,]

write.table(d,'~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV/CUMV_Colombia.2020-10-30.v4.txt',col.names=T,row.names=F,quote=F,sep='\t')




