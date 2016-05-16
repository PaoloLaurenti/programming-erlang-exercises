%% ---
%%  Excerpted from "Programming Erlang, Second Edition",
%%  published by The Pragmatic Bookshelf.
%%  Copyrights apply to this code. It may not be used to create training material,
%%  courses, books, articles, and the like. Contact us if you are in doubt.
%%  We make no guarantees that this code is fit for any purpose.
%%  Visit http://www.pragmaticprogrammer.com/titles/jaerlang2 for more book information.
%%---
-module(geometry).
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
