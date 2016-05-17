-module(exercises).
-export([my_tuple_to_list/1, my_time_func/1]).

my_tuple_to_list({}) -> [];
my_tuple_to_list(T) -> my_tuple_to_list_acc(T, 1, []).

my_tuple_to_list_acc(T, Index, Acc) when Index > tuple_size(T) -> lists:reverse(Acc);
my_tuple_to_list_acc(T, Index, Acc) -> my_tuple_to_list_acc(T, Index + 1, [element(Index, T) | Acc]).

 my_time_func(F) ->
   Start = time(),
   Result = F(),
   End = time(),
   {Result, {element(1, End) - element(1, Start), element(2, End) - element(2, Start), element(3, End) - element(3, Start)}}.
