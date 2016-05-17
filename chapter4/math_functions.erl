-module (math_functions).
-export([even/1, odd/1, filter/2]).

even(N) when N rem 2 =:= 0 -> true;
even(_) -> false.

odd(N) when N rem 2 =/= 0 -> true;
odd(_) -> false.

filter(F, L) -> [X || X <- L, F(X) =:= true].
