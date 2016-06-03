%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Jun 2016 16.47
%%%-------------------------------------------------------------------
-module(geometry_test).
-author("paolo").
-compile(export_all).

all() ->
  area_rectangle(),
  ok.

area_rectangle() ->
  12 = geometry:area({rectangle, 3, 4}),
  ok.
