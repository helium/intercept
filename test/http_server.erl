-module(http_server).

-behaviour(elli_handler).

-include_lib("elli/include/elli.hrl").

-export([
    handle/2
    ,handle_event/3
]).

handle(_Req, _Args) ->
    {ok, [], <<"ok">>}.

handle_event(_Event, _Data, _Args) ->
    ok.
