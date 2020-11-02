# Historical Databases

This repository contains files, scripts, and data products for the historical databases of Chapman 1917.

Excel spreadsheets beginning with "Sampling" are the summary tables for historical specimen counts for each expedition. 
Created using ./1.historical.sampling.R

**Gazetteer_Chapman_Colombia_Expeditions.xlsx** - Gazetteer for Chapman 1917 localities. 

########################################################################################


## Basic Information on Historical Databases

There are two historical databases.

**Specimen Database** - combined AMNH and CUMV. 
		AMNH - transcribed and digitized from the original handwritten AMNH specimen ledgers by AMNH volunteers. 
		CUMV - Downloaded from Vertnet (2020-10-30).

	The working specimen database for the project is currently 
	- ./specimen.database/Specimen.Database.v1.txt


**Chapman 1917** - database derived from the specimen counts per locality that appear below each species' account in the Chapman 1917 monograph.

	The working database for the Chapman 1917 counts is currently
	- ./Chapman1917/Chapman1917.Database.txt
	
	This can be created using the code in 
	- ./Chapman1917/1.generate.Chapman1917.specimen.counts.R
	


########################################################################################

#### Taxonomy
All taxonomy has been standardized to eBird/Clements 2019. The working databases for both Specimens and Chapman 1917 retain their original species-level taxonomy columns as well as the eBird/Clement synonyms. 

	The original taxonomic column names for each database are as follows

	Specimen Database
	- "Genus.Verb" and "Species.Verb"

	Chapman 1917
	- "Chapman"



Clements, J. F., T. S. Schulenberg, M. J. Iliff, S. M. Billerman, T. A. Fredericks, B. L. Sullivan, and C. L. Wood. 2019. The eBird/Clements Checklist of Birds of the World: v2019. Downloaded from https://www.birds.cornell.edu/clementschecklist/download/ 

	

 
 