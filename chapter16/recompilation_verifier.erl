  %%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Jun 2016 13.46
%%%-------------------------------------------------------------------
-module(recompilation_verifier).
-author("paolo").
-include_lib("kernel/include/file.hrl").
-export([does_module_need_recompiling/2]).

does_module_need_recompiling(ErlFile, BeamFile) ->
  {ok, ErlFileInfo} = file:read_file_info(ErlFile, [{time, posix}]),
  {ok, BeamFileInfo} = file:read_file_info(BeamFile, [{time, posix}]),
  ErlFileInfo#file_info.mtime > BeamFileInfo#file_info.mtime.




