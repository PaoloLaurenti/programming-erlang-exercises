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
-export([calc_md5/1, calc_md5_large/1]).

calc_md5(File) ->
  {ok, Content} = file:read_file(File),
  erlang:md5(Content).

calc_md5_large(File) ->
  Context = erlang:md5_init(),
  {ok, F} = file:open(File, [read,binary,raw]),
  calc_chunk(F, Context, 1),
  erlang:md5_final(Context).

calc_chunk(File, Context, Location) ->
  case file:pread(File, Location, 100) of
    {ok, Chunk} ->
      erlang:md5_update(Context, Chunk),
      calc_chunk(File, Context, Location + 1000);
    eof ->
      ok
  end.