-module(myproject).
-export([start/0]).

%% @doc start/0 is called in *development* mode.
%%
%% It's a convention, rather than something that a real Erlang daemon uses, so
%% put initialization code in myproject_app:start/2.
start() ->
    application:ensure_all_started(myproject).
