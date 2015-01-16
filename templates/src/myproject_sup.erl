-module(myproject_sup).

%% This module defines the top-level supervisor for your application. Any
%% worker processes or child supervisors should be added in this file.

-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% @doc start_link/0 is called from myproject_app:start/2; it is responsible
%% for returning the application's top-level supervisor.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% @doc init/1 returns the list of worker processes and child supervisors used
%% in this application.
init([]) ->
    Children = [],
    {ok, { {one_for_one, 5, 10}, Children} }.
