%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Jun 2016 13.38
%%%-------------------------------------------------------------------
-module(test_opaque_type).
-author("paolo").
-export([create_address/1, is_in_Bologna/1]).

-opaque address() :: {street(), street_number(), code(), city()}.
-export_type([address/0]).

-type street() :: string().
-type street_number() :: pos_integer().
-type code() :: string().
-type city() :: string().

-spec create_address(string()) -> address().
create_address(Text) ->
  Elements = string:tokens(Text, ","),
  list_to_tuple([string:strip(X) || X <- Elements]).

-spec is_in_Bologna(address()) -> boolean().
is_in_Bologna({_, _, _, City}) ->
  string:to_lower(City) =:= "bologna".

