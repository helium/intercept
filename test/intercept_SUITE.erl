-module(intercept_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-export([
    all/0
    ,groups/0
    ,init_per_suite/1
    ,end_per_suite/1
]).

-export([
    basic/1
]).

%%--------------------------------------------------------------------
%% COMMON TEST CALLBACK FUNCTIONS
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% @public
%% @doc
%%   Running tests for this suite
%% @end
%%--------------------------------------------------------------------
all() ->
    [{group, intercept}].

%%--------------------------------------------------------------------
%% @public
%% @doc
%%   Tests groups
%% @end
%%--------------------------------------------------------------------
groups() ->
    [{intercept, [], [basic]}].


%%--------------------------------------------------------------------
%% @public
%% @doc
%%   Special init config for suite
%% @end
%%--------------------------------------------------------------------
init_per_suite(Config) ->
    ct:pal("START OF ~p", [?MODULE]),
    Config.

%%--------------------------------------------------------------------
%% @public
%% @doc
%%   Special end config for groups
%% @end
%%--------------------------------------------------------------------
end_per_suite(_Config) ->
    ct:pal("END OF ~p", [?MODULE]),
    ok.

%%--------------------------------------------------------------------
%% TEST CASES
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% @public
%% @doc
%% @end
%%--------------------------------------------------------------------
basic(_Config) ->
    ct:pal("START OF ~p", [?FUNCTION_NAME]),
    ?assertEqual(ok, dummy:simple()),

    intercept:add(dummy, dummy_intercepts, [{{simple, 0}, simple}]),

    ?assertEqual({ok, intercepted}, dummy:simple()),
    ?assertEqual(ok, intercept:clean(dummy)),
    ?assertEqual(ok, dummy:simple()).

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
