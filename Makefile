run:
	Rscript esquisse.R "test_data/longform.csv"

run_gnps:
	wget "https://www.dropbox.com/s/6r75bt0l85gm3xv/longform.csv?dl=1" --output-document=longdata.csv
	Rscript esquisse.R "longdata.csv"