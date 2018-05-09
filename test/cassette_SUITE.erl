-module(cassette_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-export([
    all/0
    ,groups/0
    ,init_per_suite/1
    ,end_per_suite/1
]).

-export([
    udp/1
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
    [{group, cassette}].

%%--------------------------------------------------------------------
%% @public
%% @doc
%%   Tests groups
%% @end
%%--------------------------------------------------------------------
groups() ->
    [{cassette, [], [udp]}].


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
udp(_Config) ->
    ct:pal("START OF ~p", [?FUNCTION_NAME]),
    intercept:add(gen_udp, gen_udp_intercepts, [{{send, 4}, send}]),

    _ = server(4000),
    {ok, Socket} = gen_udp:open(0, [{active, true}, inet, binary]),

    Message = <<"udp message">>,
    ?assertEqual(ok, gen_udp:send(Socket, "127.0.0.1", 4000, Message)),
    receive
        {udp, _, _, _, <<"ok">>} -> ok
    after 2000 ->
        ct:fail("timeout")
    end,

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
        server_loop(Socket)
    end).

server_loop(Socket) ->
    receive
        {udp, Socket, Host, Port, _Bin} = Msg ->
            gen_udp:send(Socket, Host, Port, <<"ok">>),
            server_loop(Socket)
    end.
