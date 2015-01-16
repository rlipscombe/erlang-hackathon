# We use a newer version of rebar than the main project, at least for now.
REBAR ?= ./rebar
NAME ?= hack

all:
	$(REBAR) get-deps compile
	-rm priv/templates.zip
	zip -r priv/templates.zip templates
	$(REBAR) escriptize

clean:
	$(REBAR) clean
	-rm -rf ebin/
	-rm $(NAME)
