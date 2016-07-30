-module(worker).
-author("Paolo Laurenti").

-export([start/0, listen/0]).

start() ->
  spawn(?MODULE, listen, []).

listen() ->
  receive
    work_wanted ->
      work_wanted(),
      listen();
    {job_done, JobNumber} ->
      job_done(JobNumber),
      listen()
  end.

work_wanted() ->
  gen_server:call(job_centre, work_wanted).

job_done(JobNumber) ->
  gen_server:call(job_centre, {done, JobNumber}).
