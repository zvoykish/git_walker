%%%-------------------------------------------------------------------
%%% @author Zvika Ekhous
%%% @copyright (C) 2017, https://github.com/zvoykish
%%% @doc
%%%
%%% @end
%%% Created : 11. Aug 2017 9:07 PM
%%%-------------------------------------------------------------------
-module(criteria).
-author("Zvika").

-callback satisfies(
    Json :: jiffy:json_object(),
    Params :: proplists:proplist())
        -> boolean().
