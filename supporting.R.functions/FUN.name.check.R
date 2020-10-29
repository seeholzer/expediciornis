#determine which elements in vector x are not in vector y and vice versa

name.check = function(x,y){
	x = as.character(x)
	y = as.character(y)
	#cat('which x not in y:')
	
	x.not.in.y = x[!(x %in% y)]
		
	#cat('\n')	
	#	for(i in x.not.in.y){
	#		cat(i,'\n')
	#	}
		
		
	#cat('\n')
	#cat('which y not in x:')
	y.not.in.x = y[!(y %in% x)]
	
	#cat('\n')
	
	#	for(i in y.not.in.x){
	#		cat(i,'\n')
	#	}
	
	xx = list(x.not.in.y, y.not.in.x)
	names(xx) = c('x.not.in.y','y.not.in.x')
	return(xx)
}