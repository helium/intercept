-module(httpc_intercepts).

-export([
    request/1
]).

-define(MODULE_ORG, httpc_orig).

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
    erlang:get(Key).

cache(Key, Value) ->
    erlang:put(Key, Value).
