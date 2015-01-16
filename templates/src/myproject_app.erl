-module(myproject_app).

%% This module is called in order to start the application.

-behaviour(application).
-export([start/2, stop/1]).

%% @doc start/2 is called to start the application. It should return the
%% top-level supervisor for the application.
start(_StartType, _StartArgs) ->
    myproject_sup:start_link().

%% @doc stop/1 is called when the application is stopped.
stop(_State) ->
    ok.
