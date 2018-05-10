-module(httpc_intercepts).

-export([
    request/1
]).

-define(MODULE_ORG, httpc_orig).
-define(CACHE, "data/test.data").

request(Url) ->
    case cache(Url) of
        {ok, _}=Result ->
            Result;
        undefined ->
            Result = ?MODULE_ORG:request_orig(Url),
            cache(Url, Result),
            Result
    end.

cache(Key) ->
    case file:read_file(?CACHE) of
        {error, Reason} -> undefined;
        {ok, Bin} ->
            Map = erlang:binary_to_term(Bin),
            maps:get(Key, Map, undefined)
    end.

cache(Key, Value) ->
    ok = filelib:ensure_dir("data/"),
    case file:read_file(?CACHE) of
        {error, Reason} ->
            Data = maps:put(Key, Value, maps:new()),
            Bin = erlang:term_to_binary(Data),
            ok = file:write_file(?CACHE, Bin);
        {ok, Bin} ->
            Map = erlang:binary_to_term(Bin),
            Data = maps:put(Key, Value, Map),
            Bin = erlang:term_to_binary(Data),
            ok = file:write_file(?CACHE, Bin)
    end.
