# We use a newer version of rebar than the main project, at least for now.
REBAR ?= ./rebar
NAME ?= hack

all:
	$(REBAR) get-deps compile escriptize

clean:
	$(REBAR) clean
	-rm -rf ebin/
	-rm $(NAME)
