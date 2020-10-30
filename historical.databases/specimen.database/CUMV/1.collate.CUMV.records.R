setwd('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV')
files = list.files(pattern='vertnet_CUMV_')

data = c()
for(i in files){
	tmp = read.delim(i,stringsAsFactors=F)
	data = rbind(data,tmp)
}

colnames.to.remove = readLines('vertnet.colnames.to.remove.txt')

data = data[ ,!colnames(data) %in% colnames.to.remove]

write.table(data,'CUMV_Colombia.2020-10-30_draft.txt',col.names=T,row.names=F,quote=F,sep='\t')