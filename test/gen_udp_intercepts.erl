-module(gen_udp_intercepts).

-export([
    send/4
]).

-define(MODULE_ORG, gen_udp_orig).

send(Socket, Ip, Port, Msg) ->
    case cache(Msg) of
        {Socket2, Ip2, Port2, Msg2} ->
            self() ! {udp, Socket2, Ip2, Port2, Msg2};
        undefined ->
            ok = ?MODULE_ORG:send_orig(Socket, Ip, Port, Msg),
            receive
                {udp, Socket2, Ip2, Port2, Msg2} ->
                    cache(Msg, {Socket2, Ip2, Port2, Msg2}),
                    self() ! {udp, Socket2, Ip2, Port2, Msg2}
            end
    end,
    ok.

cache(Key) ->
    erlang:get(Key).

cache(Key, Value) ->
    erlang:put(Key, Value).
