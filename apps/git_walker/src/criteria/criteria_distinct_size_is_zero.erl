%%%-------------------------------------------------------------------
%%% @author Zvika Ekhous
%%% @copyright (C) 2017, https://github.com/zvoykish
%%% @doc
%%%
%%% @end
%%% Created : 11. Aug 2017 9:20 PM
%%%-------------------------------------------------------------------
-module(criteria_distinct_size_is_zero).
-author("Zvika").

-behavior(criteria).

%% API
-export([satisfies/2]).

satisfies(Json, _Params) -> jsonpath:search(<<"payload.distinct_size">>, Json).
