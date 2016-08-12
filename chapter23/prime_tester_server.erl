%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Aug 2016 18.50
%%%-------------------------------------------------------------------
-module(prime_tester_server).
-author("Paolo Laurenti").

-behaviour(gen_server).

-export([start_link/0, is_prime/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

init([]) ->
  process_flag(trap_exit, true),
  io:format("~p starting~n",[?MODULE]),
  {ok, 0}.

handle_call({is_prime, N}, _From, State) ->
  {reply, lib_primes:is_prime(N), State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(Reason, _State) ->
  io:format("~p stopping, reason ~p~n",[?MODULE, Reason]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

is_prime(N) ->
  gen_server:call(?MODULE, {is_prime, N}, 15000).