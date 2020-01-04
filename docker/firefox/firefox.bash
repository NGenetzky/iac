#!/bin/bash

d_firefox(){
	docker run -d \
        --rm \
		--name=firefox \
		-p 5800:5800 \
		-v "$(pwd):/config:rw" \
		--shm-size 2g \
		jlesage/firefox
		"$@"
}
