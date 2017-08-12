%%%-------------------------------------------------------------------
%%% @author Zvika Ekhous
%%% @copyright (C) 2017, https://github.com/zvoykish
%%% @doc
%%%
%%% @end
%%% Created : 11. Aug 2017 9:25 PM
%%%-------------------------------------------------------------------
-module(http_utils).
-author("Zvika").

%% API
-export([get_headers/0]).

get_headers() -> [{"Authorization", (get_auth_header())}, {"User-Agent", "Zvoykish_Git_Walker/0.1.0"}].

get_auth_header() ->
    {ok, User} = application:get_env(git_walker, github_user),
    {ok, Token} = application:get_env(git_walker, github_token),
    "Basic " ++ base64:encode_to_string(iolist_to_binary([User, <<":">>, Token])).
