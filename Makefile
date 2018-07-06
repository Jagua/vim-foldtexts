.PHONY: all lint test

all: lint test

lint:
	@vint autoload plugin
	@vimlparser plugin/*.vim autoload/*.vim autoload/*/*.vim autoload/*/*/*.vim > /dev/null

test:
	@rake test
