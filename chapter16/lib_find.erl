%% ---
%%  Excerpted from "Programming Erlang, Second Edition",
%%  published by The Pragmatic Bookshelf.
%%  Copyrights apply to this code. It may not be used to create training material,
%%  courses, books, articles, and the like. Contact us if you are in doubt.
%%  We make no guarantees that this code is fit for any purpose.
%%  Visit http://www.pragmaticprogrammer.com/titles/jaerlang2 for more book information.
%%---
-module(lib_find).
-export([files/3, files/5]).
-import(lists, [reverse/1]).

-include_lib("kernel/include/file.hrl").

files(Dir, Re, Flag) ->
  reverse(files(Dir, Re, Flag, fun(File, Acc) ->[File|Acc] end, [])).

files(Dir, Reg, Recursive, Fun, Acc) ->
  case file:list_dir(Dir) of
    {ok, Files} -> find_files(Files, Dir, Reg, Recursive, Fun, Acc);
    {error, _}  -> Acc
  end.

find_files([File|T], Dir, Reg, Recursive, Fun, Acc0) ->
  Re1 = xmerl_regexp:sh_to_awk(Reg),
  FullName = filename:join([Dir,File]),
  case file_type(FullName) of
    regular ->
      case re:run(FullName, Re1, [{capture,none}]) of
        match  ->
          Acc = Fun(FullName, Acc0),
          find_files(T, Dir, Reg, Recursive, Fun, Acc);
        nomatch ->
          find_files(T, Dir, Reg, Recursive, Fun, Acc0)
      end;
    directory ->
      case Recursive of
        true ->
          Acc1 = files(FullName, Reg, Recursive, Fun, Acc0),
          find_files(T, Dir, Reg, Recursive, Fun, Acc1);
        false ->
          find_files(T, Dir, Reg, Recursive, Fun, Acc0)
      end;
    error ->
      find_files(T, Dir, Reg, Recursive, Fun, Acc0)
  end;
find_files([], _, _, _, _, A) ->
  A.

file_type(File) ->
  case file:read_file_info(File) of
    {ok, Facts} ->
      case Facts#file_info.type of
        regular   -> regular;
        directory -> directory;
        _         -> error
      end;
    _ ->
      error
  end.

