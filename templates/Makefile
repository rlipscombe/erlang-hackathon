PROJECT = myproject
REBAR ?= ./rebar

all: get-deps compile eunit run

get-deps:
	$(REBAR) get-deps

compile:
	$(REBAR) compile

qcompile:
	$(REBAR) skip_deps=true compile

eunit:
	$(REBAR) skip_deps=true eunit

run:
	erl -pa ebin -pa deps/*/ebin \
		-sname $(PROJECT) \
		-setcookie $(PROJECT) \
		-config $(PROJECT) \
		-s $(PROJECT)
