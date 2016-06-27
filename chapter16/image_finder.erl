%%%-------------------------------------------------------------------
%%% @author paolo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Jun 2016 21:53
%%%-------------------------------------------------------------------
-module(image_finder).
-author("paolo").
-export([get_identical_images/1, get_images/1]).
-import(lib_find, [files/3, files/5]).

get_identical_images(Dir) ->
  Map = files(Dir, "*.jpg", true, fun index_image/2, dict:new()),
  Identical = dict:filter(fun(_Key, Value) -> length(Value) > 1 end, Map),
  lists:map(fun({_Key, Val}) -> Val end , dict:to_list(Identical)).

index_image(Image, ImagesMap) ->
  ImageMd5 = md5_calc:calc_md5(Image),
  dict:update(ImageMd5, fun(V) -> [Image|V] end, [Image], ImagesMap).

get_images(Dir) ->
  F = files(Dir, "*.jpg", true),
  lists:map(fun(I) -> binary_to_list(md5_calc:calc_md5(I)) end, F).