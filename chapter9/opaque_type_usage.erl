%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Jun 2016 13.55
%%%-------------------------------------------------------------------
-module(opaque_type_usage).
-author("paolo").
-export([get_codes/1, create/1, is_in_Bologna/1]).

-spec get_codes([test_opaque_type:address()]) -> [string()].
get_codes(Addresses) ->
  [Code || {_, _, Code, _} <- Addresses].

-spec create(string()) -> test_opaque_type:address().
create(Text) ->
  test_opaque_type:create_address(Text).

-spec is_in_Bologna(string()) -> boolean().
is_in_Bologna(Text) ->
  {_, _, _, City} = create(Text),
  string:to_lower(City) =:= "bologna".
