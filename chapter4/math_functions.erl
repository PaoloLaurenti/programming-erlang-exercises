-module (math_functions).
-export([even/1, odd/1, filter/2, splitf/1,  splita/1]).

even(N) when N rem 2 =:= 0 -> true;
even(_) -> false.

odd(N) when N rem 2 =/= 0 -> true;
odd(_) -> false.

filter(F, L) -> [X || X <- L, F(X) =:= true].

splitf(L) -> splitf_acc(L, [], []).

splitf_acc([], E, O) -> {lists:reverse(E), lists:reverse(O)};
splitf_acc([H|T], E, O) ->
  case even(H) of
    true -> splitf_acc(T, [H|E], O);
    false -> splitf_acc(T, E, [H|O])
  end.

splita(L) -> { filter(fun even/1, L), filter(fun odd/1, L)}.
