This version of Esquisse will enable file uploads and not require GNPS as file input.

http://localhost:8348/?filename=longform.csv

## Installation

1. Conda Install
1. Install R environment - ```conda create -n r_env r-essentials r-base```
1. Switch to R environment - ```conda activate r_env```
1. Install Esquisse - ```conda install -c conda-forge r-esquisse```


## Running

1. Edit Makefile, replace GNPS task
1. Activate conda environment
1. ```make run_server```