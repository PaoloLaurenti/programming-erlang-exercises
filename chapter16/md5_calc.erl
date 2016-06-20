%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Jun 2016 13.35
%%%-------------------------------------------------------------------
-module(md5_calc).
-author("paolo").

%% API
-export([calc_md5/1]).

calc_md5(File) ->
  {ok, Content} = file:read_file(File),
  erlang:md5(Content).