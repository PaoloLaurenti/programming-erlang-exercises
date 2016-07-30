-module(job_centre).
-author("Paolo Laurenti").

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, start_link/0, add_job/1, work_wanted/0, job_done/1, stop/0, statistics/0]).

-define(SERVER, ?MODULE).

start_link() ->
  case gen_server:start_link({local, ?SERVER}, ?MODULE, [], []) of
    {ok, _} -> true;
    {error, {already_started, _}} -> true
  end.

add_job(F) ->
  gen_server:call(?MODULE, {add, F}).

work_wanted() ->
  gen_server:call(?MODULE, work_wanted).

job_done(JobNumber) ->
  gen_server:cast(?MODULE, {done, JobNumber}).

statistics() ->
  gen_server:call(?MODULE, statistics).

stop() ->
  gen_server:stop(?MODULE).

init([]) ->
  {ok, {0, queue:new(), [], []}}.

handle_call({add, F}, _From, {Index, ToDoJobs, InProgressJobs, DoneJobs}) ->
  JobNumber = Index + 1,
  NewToDoJobs = queue:in({number, JobNumber, {job, F}}, ToDoJobs),
  {reply, JobNumber, {JobNumber, NewToDoJobs, InProgressJobs, DoneJobs}};

handle_call(work_wanted, {WorkerPid, _}, {Index, ToDoJobs, InProgressJobs, DoneJobs}) ->
  case queue:out(ToDoJobs) of
    {{value, Job}, NewToDoJobs} ->
      NewInProgressJobs = get_new_in_progress_jobs(WorkerPid, Job, InProgressJobs),
      {reply, Job, {Index, NewToDoJobs, NewInProgressJobs, DoneJobs}};
    {empty, ToDoJobs} ->
      {reply, no, {Index, ToDoJobs, InProgressJobs, DoneJobs}}
  end;

handle_call(statistics, _From, {Index, ToDoJobs, InProgressJobs, DoneJobs}) ->
  {reply, {{to_do, ToDoJobs}, {in_progress, InProgressJobs}, {done, DoneJobs}}, {Index, ToDoJobs, InProgressJobs, DoneJobs}};

handle_call({done, JobNumber}, {Pid, _}, {Index, ToDoJobs, InProgressJobs, DoneJobs}) ->
  case lists:partition(fun({{worker, {_, WorkerPid}}, {number, JN, _}}) -> JN =:= JobNumber andalso WorkerPid =:= Pid end, InProgressJobs) of
    {[], _} ->
      {reply, {Index, ToDoJobs, InProgressJobs, DoneJobs}};
    {[J = {{worker, {WorkerRef, WorkerPid}}, _ } | _], NewInProgressJobs} ->
      case lists:any(fun({{worker, {_, WPid}}, _}) -> WPid =:= WorkerPid end, NewInProgressJobs) of
        false ->
          erlang:demonitor(WorkerRef);
        _Else ->
          nothing
      end,
      {noreply, {Index, ToDoJobs, NewInProgressJobs, [J | DoneJobs]}}
  end.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info({'DOWN', Ref, process, Pid, _}, State = {Index, ToDoJobs, InProgressJobs, DoneJobs}) ->
  case lists:partition(fun({{worker, {WorkerRef, WorkerPid}}, _}) -> WorkerRef =:= Ref andalso WorkerPid =:= Pid end, InProgressJobs) of
    {[], _} ->
      {noreply, State};
    {JobsToEnqueueAgain, NewInProgressJobs} ->
      NewToDoJobs = lists:foldl(fun({_, Job}, Queue) -> queue:in(Job, Queue) end, ToDoJobs, JobsToEnqueueAgain),
      {noreply, {Index, NewToDoJobs, NewInProgressJobs, DoneJobs}}
  end;

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

get_new_in_progress_jobs(WorkerPid, Job, InProgressJobs) ->
  WorkerRef = erlang:monitor(process, WorkerPid),
  Worker = {worker, {WorkerRef, WorkerPid}},
  [{Worker, Job} | InProgressJobs].