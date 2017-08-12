%%%-------------------------------------------------------------------
%%% @author Zvika Ekhous
%%% @copyright (C) 2017, https://github.com/zvoykish
%%% @doc
%%%
%%% @end
%%% Created : 11. Aug 2017 10:09 PM
%%%-------------------------------------------------------------------
-module(ugly_cache).
-author("Zvika").

%% API
-export([lookup/1, store/2]).

-type key()     :: term().
-type value()   :: term().

-spec lookup(key()) -> undefined | value().
lookup(Key) -> proplists:get_value(Key, get_cache_impl()).

-spec store(key(), value()) -> value().
store(Key, Value) ->
    Current_Cache = get_cache_impl(),
    New_Cache = lists:keystore(Key, 1, Current_Cache, {Key, Value}),
    set_cache_impl(New_Cache),
    Value.

get_cache_impl() -> get_cache_impl(erlang:get(ugly_cache)).

get_cache_impl(undefined) ->
    set_cache_impl([]),
    [];
get_cache_impl(Current_Cache) ->
    Current_Cache.

set_cache_impl(Cache) -> erlang:put(ugly_cache, Cache).
