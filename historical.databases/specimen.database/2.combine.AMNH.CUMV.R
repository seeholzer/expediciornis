source('~/Dropbox/Chapman/expediciornis/supporting.R.functions/FUN.name.check.R', chdir = TRUE)

setwd('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/')
amnh = read.delim('AMNH_Colombia.2020-10-29.txt',stringsAsFactors=F)
cumv = read.delim('CUMV/CUMV_Colombia.2020-10-30.v5.txt',stringsAsFactors=F)

name.check(colnames(amnh),colnames(cumv))
all(colnames(amnh) == colnames(cumv))

data = rbind(amnh,cumv)

write.table(data,'AMNH.CUMV.database.2020-10-30.v1.txt',col.names=T,row.names=F,quote=F,sep='\t')




