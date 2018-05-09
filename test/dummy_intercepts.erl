-module(dummy_intercepts).

-export([
    simple/0
]).

-define(MODULE_ORG, dummy_orig).

simple() ->
    {?MODULE_ORG:simple_orig(), intercepted}.
