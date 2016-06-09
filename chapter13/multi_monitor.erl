%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Jun 2016 13.27
%%%-------------------------------------------------------------------
-module(multi_monitor).
-author("paolo").
-export([spawn_all/1, start/1, do_something/1, spawn_monitored_processes/1]).

start(N) ->
  spawn(multi_monitor, spawn_all, [N]).

spawn_all(N) ->
  case N > erlang:system_info(process_limit) of
    true ->
      exit(self(), too_many_processes_requested);
    false ->
      spawn(multi_monitor, spawn_monitored_processes, [N])
  end.

spawn_monitored_processes(N) ->
  Processes = [spawn_monitored_process() || _ <- lists:seq(1, N)],
  monitor_all(Processes).

monitor_all(Processes) ->
  receive
    {'DOWN', Ref, process, Pid, _Why} ->
      io:format("Process {~p, ~p} terminated and restarted~n", [Pid, Ref]),
      NewProcessesCatalog = lists:delete({Pid, Ref}, Processes),
      NewProcess = spawn_monitored_process(),
      monitor_all([NewProcess | NewProcessesCatalog]);
    shutdown ->
      lists:foreach(fun({P, R}) -> demonitor(R) andalso exit(P, shutdown) end, Processes),
      io:format("All processes terminated~n", [])
  end.

spawn_monitored_process() ->
  spawn_monitor(multi_monitor, do_something, [10000]).

do_something(Time) ->
  receive
    _ -> true
  after Time ->
    false
  end.

