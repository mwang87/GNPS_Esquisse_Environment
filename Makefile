run:
	Rscript esquisse.R "test_data/longform.csv"

run_gnps:
	wget "https://gnps.ucsd.edu/ProteoSAFe/DownloadResultFile?task=67357355dae54e7ebf07a8986f07a7f6&file=feature_statistics/data_long.csv" --output-document=longdata.csv
	Rscript esquisse.R "longdata.csv"