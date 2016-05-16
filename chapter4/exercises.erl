-module(exercises).
-export([my_tuple_to_list/1]).

my_tuple_to_list({}) -> [];
my_tuple_to_list(T) -> my_tuple_to_list_acc(T, 1, []).

my_tuple_to_list_acc(T, Index, Acc) when Index > tuple_size(T) -> lists:reverse(Acc);
my_tuple_to_list_acc(T, Index, Acc) -> my_tuple_to_list_acc(T, Index + 1, [element(Index, T) | Acc]).
