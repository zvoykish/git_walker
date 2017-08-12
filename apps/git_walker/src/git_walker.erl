%%%-------------------------------------------------------------------
%%% @author Zvika Ekhous
%%% @copyright (C) 2017, https://github.com/zvoykish
%%% @doc
%%%
%%% @end
%%% Created : 11. Aug 2017 8:42 PM
%%%-------------------------------------------------------------------
-module(git_walker).
-author("Zvika").

%% API
-export([process/2]).

process(Owner, Repository) ->
    Url = "https://api.github.com/repos/" ++ Owner ++ "/" ++ Repository ++ "/events",
    process_url(Owner, Repository, Url, []).

process_url(Owner, Repository, Url, Acc) ->
    io:format("+++ Querying: ~p~n", [Url]),
    handle_response(ibrowse:send_req(Url, http_utils:get_headers(), get), Owner, Repository, Acc).

handle_response({ok, "200", RH, RB}, Owner, Repository, Acc) ->
    Events_Page_Json = jiffy:decode(RB),
    New_Acc = lists:foldl(
        fun(Event_Json, Mid_Acc) ->
            Event_Time = jsonpath:search(<<"created_at">>, Event_Json),
            Event_Id = jsonpath:search(<<"id">>, Event_Json),
            Actor = jsonpath:search(<<"actor.login">>, Event_Json),
            Event_Type = jsonpath:search(<<"type">>, Event_Json),
            io:format("[~p] ~p ~p by ~p~n", [Event_Time, Event_Id, Event_Type, Actor]),
            case Event_Type of
                <<"PushEvent">> ->
                    Params = [{owner, Owner}, {repository, Repository}],
                    Fun = fun(Criteria_CB) -> Criteria_CB:satisfies(Event_Json, Params) end,
                    case ec_lists:find(Fun, get_criteria_list()) of
                        {ok, Satisfied_Criteria_CB} ->
                            io:format("Push satisfied reason: ~p~n~p~n", [Satisfied_Criteria_CB, Event_Json]),
                            [{Satisfied_Criteria_CB, Event_Json} | Mid_Acc];
                        error -> Mid_Acc
                    end;
                _ -> Mid_Acc
            end
        end, Acc, Events_Page_Json),
    Link_Str = proplists:get_value("Link", RH, "<>"),
    Tokens = string:tokens(Link_Str, ","),
    case ec_lists:find(fun(Token) -> string:str(Token, "\"next\"") > 0 end, Tokens) of
        {ok, Token} ->
            [Url0 | _Junk] = string:tokens(Token, "<"),
            [Next_Url | _Junk2] = string:tokens(Url0, ">"),
            process_url(Owner, Repository, Next_Url, New_Acc);
        error -> New_Acc
    end;
handle_response({error, Reason}, _Owner, _Repo, Acc) ->
    io:format("Github bad response: ~p~n", [Reason]),
    [{error, Reason} | Acc].

get_criteria_list() ->
    [
        criteria_no_commits,
        criteria_size_is_zero,
        criteria_distinct_size_is_zero,
        criteria_time_travel
    ].
