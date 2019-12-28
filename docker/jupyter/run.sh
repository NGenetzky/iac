#!/bin/sh
docker run -it --rm -p 8888:8888 jupyter/datascience-notebook start.sh jupyter lab
