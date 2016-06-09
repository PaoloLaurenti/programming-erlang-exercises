%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Jun 2016 18.36
%%%-------------------------------------------------------------------
-module(multi_monitor_killer).
-author("paolo").
-export([start/1, spawn_monitored_processes/1, do_something/1]).

start(N) ->
  seed_random_generation(),
  case N > erlang:system_info(process_limit) of
    true ->
      exit(self(), too_many_processes_requested);
    false ->
      spawn(multi_monitor_killer, spawn_monitored_processes, [N])
  end.

seed_random_generation() ->
  random:seed(erlang:phash2([node()]), erlang:monotonic_time(), erlang:unique_integer()).

spawn_monitored_processes(N) ->
  monitor_all(spawn_processes(N)).

spawn_processes(N) ->
  [spawn_monitored_process((random:uniform(10) + 5) * 1000) || _ <- lists:seq(1, N)].

monitor_all(Processes) ->
  receive
    {'DOWN', Ref, process, Pid, _Why} ->
      io:format("Process {~p, ~p} terminated. Kill and restart all processes~n", [Pid, Ref]),
      OtherProcesses = lists:filter(fun({P, R}) -> P =/= Pid andalso R =/= Ref end, Processes),
      lists:foreach(fun exit_monitored_process/1, OtherProcesses),
      spawn_monitored_processes(length(Processes));
    shutdown ->
      lists:foreach(fun({P, R}) -> demonitor(R) andalso exit(P, shutdown) end, Processes),
      io:format("All processes terminated~n", [])
  end.

exit_monitored_process({Process, Ref}) ->
  demonitor(Ref),
  exit(Process, stop).

spawn_monitored_process(Timeout) ->
  spawn_monitor(multi_monitor_killer, do_something, [Timeout]).

do_something(Time) ->
  receive
    _ -> true
  after Time ->
    false
  end.