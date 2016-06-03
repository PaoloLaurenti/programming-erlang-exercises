%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Jun 2016 17.17
%%%-------------------------------------------------------------------
-module(exercises).
-author("paolo").
-export([start/2, do_nothing/1]).

start(AnAtom, Function) ->
  register(AnAtom, spawn(Function)).

do_nothing(Time) ->
  receive
    _ -> true
  after Time ->
    false
  end.
