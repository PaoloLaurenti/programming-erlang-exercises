%%%-------------------------------------------------------------------
%%% @author paolo
%%% @end
%%% Created : 26. May 2016 13.19
%%%-------------------------------------------------------------------
-module(exercises).
-author("paolo").

-export([reverse_bytes/1]).

reverse_bytes(B) ->
  Binary_list = binary_to_list(B),
  list_to_binary(lists:reverse(Binary_list)).