# This is code to create 100 page pdf subsets of the species accounts in Chapman 1917
# The pdfs are then converted to text using https://www.pdf2go.com/pdf-to-text
# Developed by: Glenn F. Seeholzer
# Date: 2020.06.10

library(pdftools)

setwd('~/Dropbox/Chapman/database.historical/Chapman1917/')
pdf = 'Chapman1917.pdf'

start = c(269,seq(301,701,50))
end = c(seq(300,700,50),730)
pages = data.frame(start=start,end=end)

i = 1
for(i in 1:nrow(pages)){
	start = pages[i,'start']
	end = pages[i,'end']
	out = gsub('.pdf',paste0('.',start,'-',end,'.pdf'),pdf)	
	pdf_subset(pdf, pages = start:end, output = out)	
}
