%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Jun 2016 16.46
%%%-------------------------------------------------------------------
-module(geometry).
-author("paolo").
-export([area/1, perimeter/1]).
-import(math, [pi/0, sqrt/1]).

area({rectangle, Width, Height}) -> Width * Height;
area({square, Side}) -> Side * Side;
area({circle, Radius}) -> pi() * Radius * Radius;
area({right_angled_triangle, Width, Height}) ->  (Width * Height) / 2.

perimeter({rectangle, With, Height})
  -> With * 2 + Height * 2;
perimeter({square, Side})
  -> Side * 4;
perimeter({circle, Radius})
  ->  2 * pi() * Radius;
perimeter({right_angled_triangle, With, Height})
  -> Hypotenuse = sqrt(With * With + Height * Height),
  With + Height + Hypotenuse.