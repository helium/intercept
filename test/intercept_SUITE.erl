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
    ,gen_udp/1
    ,cassette/1
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
    [{intercept, [], [basic, gen_udp, cassette]}].


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

%%--------------------------------------------------------------------
%% @public
%% @doc
%% @end
%%--------------------------------------------------------------------
gen_udp(_Config) ->
    ct:pal("START OF ~p", [?FUNCTION_NAME]),
    intercept:add(gen_udp, gen_udp_intercepts, [{{send, 4}, send}]),
    {ok, Socket} = gen_udp:open(0, [{active, true}, inet, binary]),
    Message = <<"udp message">>,
    ?assertEqual(ok, gen_udp:send(Socket, "127.0.0.1", 4000, Message)),
    receive
        {udp, _Sock, _Ip, _Port, Message} -> ok
    after 2000 ->
        ct:fail("timeout")
    end,
    ?assertEqual(ok, intercept:clean(gen_udp)),
    ?assertEqual(ok, gen_udp:send(Socket, "127.0.0.1", 4000, Message)),
    ?assertEqual(ok, gen_udp:close(Socket)).

%%--------------------------------------------------------------------
%% @public
%% @doc
%% @end
%%--------------------------------------------------------------------
cassette(_Config) ->
    ct:pal("START OF ~p", [?FUNCTION_NAME]),
    intercept:add(gen_udp, gen_udp_intercepts, [{{send, 4}, send}]),

    _ = server(4000),
    {ok, Socket} = gen_udp:open(0, [{active, true}, inet, binary]),

    true = os:putenv("RECORDING", "true"),
    Message = <<"udp message">>,
    ?assertEqual(ok, gen_udp:send(Socket, "127.0.0.1", 4000, Message)),
    receive
        {udp, _, _, _, <<"ok">>} -> ok
    after 2000 ->
        ct:fail("timeout")
    end,

    true = os:putenv("RECORDING", "false"),
    ?assertEqual(ok, gen_udp:send(Socket, "127.0.0.1", 4000, Message)),
    receive
        {udp, _, _, _, <<"ok">>} -> ok
    after 2000 ->
        ct:fail("timeout")
    end,

    ?assertEqual(ok, intercept:clean(gen_udp)),

    ?assertEqual(ok, gen_udp:send(Socket, "127.0.0.1", 4000, Message)),
    receive
        {udp, _, _, _, <<"ok">>} -> ok
    after 2000 ->
        ct:fail("timeout")
    end.


%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
server(Port) ->
    erlang:spawn(fun() ->
        {ok, Socket} = gen_udp:open(Port, [binary]),
        loop(Socket)
    end).

loop(Socket) ->
    receive
        {udp, Socket, Host, Port, _Bin} = Msg ->
            ct:pal("server received: ~p",[Msg]),
            gen_udp:send(Socket, Host, Port, <<"ok">>),
            loop(Socket)
    end.
