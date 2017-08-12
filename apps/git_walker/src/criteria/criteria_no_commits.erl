%%%-------------------------------------------------------------------
%%% @author Zvika Ekhous
%%% @copyright (C) 2017, https://github.com/zvoykish
%%% @doc
%%%
%%% @end
%%% Created : 11. Aug 2017 9:07 PM
%%%-------------------------------------------------------------------
-module(criteria_no_commits).
-author("Zvika").

-behavior(criteria).

%% API
-export([satisfies/2]).

satisfies(Json, _Params) -> jsonpath:search(<<"commits">>, Json) =:= [].
