debug:
	@docker run --rm -it -v "${shell pwd}:/data" --name skull-goblet -w /data --entrypoint "/bin/bash" yababay/swipl:historian

prolog:
	@docker run --rm yababay/swipl:skull-goblet

build:
	@docker build . -t yababay/swipl:skull-goblet

