#!/bin/bash
source activate r_env

R -e "shiny::runApp('.', port=8351, host='0.0.0.0')"
