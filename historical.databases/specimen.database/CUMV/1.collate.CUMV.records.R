setwd('~/Dropbox/Chapman/expediciornis/historical.databases/specimen.database/CUMV')
files = list.files()

cumv = c()
for(i in files){
	tmp = read.delim(i,stringsAsFactors=F)
	cumv = rbind(cumv,tmp)
}


write.table(cumv,'CUMV_Colombia.2020-10-30.txt',col.names=T,row.names=F,quote=F,sep='\t')