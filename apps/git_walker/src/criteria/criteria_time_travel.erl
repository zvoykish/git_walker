%%%-------------------------------------------------------------------
%%% @author Zvika Ekhous
%%% @copyright (C) 2017, https://github.com/zvoykish
%%% @doc
%%%
%%% @end
%%% Created : 11. Aug 2017 9:24 PM
%%%-------------------------------------------------------------------
-module(criteria_time_travel).
-author("Zvika").

-behavior(criteria).

%% API
-export([satisfies/2]).

satisfies(Json, Params) ->
    Old_Head = jsonpath:search(<<"payload.before">>, Json),
    New_Head = jsonpath:search(<<"payload.head">>, Json),
    Owner = proplists:get_value(owner, Params),
    Repository = proplists:get_value(repository, Params),
    Old_Date = get_commit_timestamp(Owner, Repository, Old_Head),
    New_Date = get_commit_timestamp(Owner, Repository, New_Head),
    Old_Date > New_Date.

get_commit_timestamp(Owner, Repo, Commit_Sha) ->
    Url = binary_to_list(iolist_to_binary(["https://api.github.com/repos/", Owner, "/", Repo, "/git/commits/", Commit_Sha])),
    {ok, "200", _RH, RB} = ibrowse:send_req(Url, http_utils:get_headers(), get),
    Commit_Json = jiffy:decode(RB),
    {Date_Part, {HH, MM, SS, _MS}} = ec_date:parse(binary_to_list(jsonpath:search(<<"committer.date">>, Commit_Json))),
    calendar:datetime_to_gregorian_seconds({Date_Part, {HH, MM, SS}}).
