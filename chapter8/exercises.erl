%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. May 2016 13.42
%%%-------------------------------------------------------------------
-module(exercises).
-author("paolo").
-export([get_module_with_most_functions/0]).


get_module_with_most_functions() ->
  Modules = code:all_loaded(),
  Map = lists:map(fun get_functions_count/1, Modules),
  [Max | _] = lists:sort(fun({_, C1}, {_, C2}) -> C1 > C2 end, Map),
  Max.

get_functions_count({ModuleName, _}) ->
  Info = erlang:apply(ModuleName, module_info, []),
  [{_, Functions} | _] = lists:filter(fun({InfoType, _}) -> InfoType =:= exports end, Info),
  {ModuleName, length(Functions)}.