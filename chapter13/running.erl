%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jun 2016 13.44
%%%-------------------------------------------------------------------
-module(running).
-author("paolo").
-export([print_status/0, run_status_interval_notifier/0, start_monitor/0]).

print_status() ->
  io:format("I'm still running~n", []).

run_status_interval_notifier() ->
  Pid = spawn(fun() ->
                timer:apply_interval(10000, running, print_status, []),
                receive
                  _ -> true
                end
              end),
  register(notifier, Pid).

start_monitor() ->
  spawn(fun() ->
          Pid = whereis(notifier),
          Ref = monitor(process, Pid),
          receive
            {'DOWN', Ref, process, Pid, _Why} ->
              run_status_interval_notifier(),
              io:format("Received!", []),
              start_monitor()
          end
        end).



