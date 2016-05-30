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
-export([get_module_with_most_functions/0, get_most_common_function_name_in_modules/0, get_unambiguous_functions/0]).


get_module_with_most_functions() ->
  Map = lists:map(fun({ModuleName, _}) -> get_functions_count(ModuleName) end, code:all_loaded()),
  [Max | _] = lists:sort(fun({_, C1}, {_, C2}) -> C1 > C2 end, Map),
  Max.

get_functions_count(ModuleName) ->
  {ModuleName, length(get_module_functions(ModuleName))}.

get_module_functions(ModuleName) ->
  Info = erlang:apply(ModuleName, module_info, []),
  [{_, Functions} | _] = lists:filter(fun({InfoType, _}) -> InfoType =:= exports end, Info),
  Functions.

get_most_common_function_name_in_modules() ->
  max_value(get_functions_occurrences(), {"", 0}).

max_value(Dictionary, FirstValue) ->
  [Result | _] = dict:fold(fun(Key, Value, AccIn) ->
                              [{_, CurrentMax} | _] = AccIn,
                              case CurrentMax < Value of
                                true ->[{Key, Value} | AccIn];
                                false -> AccIn
                              end
                           end, [FirstValue], Dictionary),
  Result.

get_functions_occurrences() ->
  Functions = lists:flatmap(fun({ModuleName, _}) -> get_module_functions(ModuleName) end, code:all_loaded()),
  FunctionsNames = lists:map(fun({Name, _}) -> Name end, Functions),
  lists:foldl(fun(X, Acc) -> dict:update_counter(X, 1, Acc) end, dict:new(), FunctionsNames).

get_unambiguous_functions() ->
  UnambiguosFunctions = dict:filter(fun(_, Occurrence) -> Occurrence =:= 1 end, get_functions_occurrences()),
  lists:map(fun({FunctionName, _}) -> FunctionName end, dict:to_list(UnambiguosFunctions)).

