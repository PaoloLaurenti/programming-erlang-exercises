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
-export([my_spawn/3, do_nothing/1, my_spawn2/3]).

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

on_exit(Pid, Fun) ->
  spawn(fun() ->
          Ref = monitor(process, Pid),
          receive
            {'DOWN', Ref, process, Pid, Why} ->
              Fun(Why)
          end
        end).

my_spawn2(Mod, Fun, Args) ->
  Pid = spawn(Mod, Fun, Args),
  Start = erlang:monotonic_time(),
  on_exit(Pid, fun(Why) ->
                End = erlang:monotonic_time(),
                io:format("Process ~p died due to: ~p~n", [Pid, Why]),
                io:format("Duration: ~p~n", [erlang:convert_time_unit(End - Start, native, seconds)])
               end),
  Pid.