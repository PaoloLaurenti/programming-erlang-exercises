-module(exercises).
-author("paolo").
-export([fac/1, area/1]).

-spec fac(integer()) -> integer().
fac(0) -> 1;
fac(N) -> N*fac(N-1).

%% SPEFICATION 1
%%-type shapeName() :: rectangle | square | circle | right_angled_triangle.
%%-type shape() :: {shapeName(), pos_integer()} | {shapeName(), pos_integer(), pos_integer()}.
%%-spec area(shape()) -> integer().

%% SPECIFICATION 2
-spec area(Shape) -> pos_integer() when
  Shape :: {ShapeName,  pos_integer()} | {ShapeName,  pos_integer(),  pos_integer()},
  ShapeName :: rectangle | square | circle | right_angled_triangle.

area({rectangle, Width, Height}) -> Width * Height;
area({square, Side}) -> Side * Side;
area({circle, Radius}) -> math:pi() * Radius * Radius;
area({right_angled_triangle, Width, Height}) ->  (Width * Height) / 2.