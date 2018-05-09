-module(gen_udp_intercepts).

-export([
    send/4
]).

-define(MODULE_ORG, gen_udp_orig).
-define(R, "RECORDING").
-define(ENV, "RECORD").

send(Socket, Ip, Port, Msg) ->
    case os:getenv(?R, "false") of
        "false" ->
            case erlang:get(?R) of
                undefined ->
                    self() ! {udp, Socket, Ip, Port, Msg};
                {Socket2, Ip2, Port2, Msg2} ->
                    self() ! {udp, Socket2, Ip2, Port2, Msg2}
            end;
        "true" ->
            ok = ?MODULE_ORG:send_orig(Socket, Ip, Port, Msg),
            receive
                {udp, Socket2, Ip2, Port2, Msg2} ->
                    erlang:put(?R, {Socket2, Ip2, Port2, Msg2}),
                    self() ! {udp, Socket2, Ip2, Port2, Msg2}
            end
    end,
    ok.
