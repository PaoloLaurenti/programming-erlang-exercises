%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Jun 2016 18:37
%%%-------------------------------------------------------------------
-module(exercises).
-author("paolo").
-export([my_spawn/3, do_nothing/1]).

my_spawn(Mod, Fun, Args) ->
  spawn(fun() ->
          {Pid, Ref} = spawn_monitor(Mod, Fun, Args),
          Start = erlang:monotonic_time(),
          receive
            {'DOWN', Ref, process, Pid, Why} ->
              End = erlang:monotonic_time(),
              io:format("Process ~p died due to: ~p~n", [Pid, Why]),
              io:format("Duration: ~p~n", [erlang:convert_time_unit(End - Start, native, seconds)])
          end
        end).

do_nothing(Time) ->
  receive
    _ -> true
  after Time ->
    false
  end.

