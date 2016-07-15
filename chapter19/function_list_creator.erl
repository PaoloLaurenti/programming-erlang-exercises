%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Jul 2016 13.54
%%%-------------------------------------------------------------------
-module(function_list_creator).
-author("paolo").
-export([create_ets_list/0, create_dets_list/1]).

create_ets_list() ->
  TableId = ets:new(lookup, [duplicate_bag]),
  lists:foreach(fun({ModuleName, Functions}) -> insertModuleFunctions(ModuleName, Functions, insert_ets_item(TableId)) end, get_module_functions()),
%%  List = ets:tab2list(TableId),
%%  io:format("~p~n", [List]),
  ets:delete(TableId).

insert_ets_item(TableName) ->
  fun(Key, Value) -> ets:insert(TableName, {Key, Value}) end.

create_dets_list(File) ->
  case dets:open_file(?MODULE, [{file, File}]) of
    {ok, ?MODULE} ->
      lists:foreach(fun({ModuleName, Functions}) -> insertModuleFunctions(ModuleName, Functions, insert_dets_item(?MODULE)) end, get_module_functions());
    {error, Reason} ->
      io:format("cannot open dets table~n"),
      exit({eDetsOpen, File, Reason})
  end,

  List = dets:lookup(?MODULE, File),
  io:format("~p~n", [List]),

  dets:close(?MODULE).

insert_dets_item(Name) ->
  fun(Key, Value) -> dets:insert(Name, {Key, Value}) end.

get_module_functions() ->
  lists:map(fun({ModName, _}) -> {ModName, erlang:apply(ModName, module_info, [exports])} end, code:all_loaded()).

insertModuleFunctions(ModuleName, Functions, InsertOperation) ->
   lists:foreach(fun({FunctionName, FunctionArity}) -> InsertOperation({FunctionName, FunctionArity}, ModuleName) end, Functions).