-module(job_centre).
-author("Paolo Laurenti").

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, start_link/0, add_job/1, work_wanted/0, job_done/1, stop/0]).

-compile(export_all).

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
  Update_queue = queue:in({JobNumber, F}, ToDoJobs),
  {reply, JobNumber, {JobNumber, Update_queue, InProgressJobs, DoneJobs}};

handle_call(work_wanted, _From, {Index, ToDoJobs, InProgressJobs, DoneJobs}) ->
  case queue:out(ToDoJobs) of
    {{value, Job}, NewToDoJobs} ->
      {reply, Job, {Index, NewToDoJobs, [Job | InProgressJobs], DoneJobs}};
    {empty, ToDoJobs} ->
      {reply, no, {Index, ToDoJobs, InProgressJobs, DoneJobs}}
  end;

handle_call(statistics, _From, {Index, ToDoJobs, InProgressJobs, DoneJobs}) ->
  {reply, {{toDo, ToDoJobs}, {in_progress, InProgressJobs}, {done, DoneJobs}}, {Index, ToDoJobs, InProgressJobs, DoneJobs}}.

handle_cast({done, JobNumber}, {Index, ToDoJobs, InProgressJobs, DoneJobs}) ->
  case lists:partition(fun({JN, _}) -> JN =:= JobNumber end, InProgressJobs) of
    {[], _} ->
      {noreply, {Index, ToDoJobs, InProgressJobs, DoneJobs}};
    _Else ->
      {[H | _], NewInProgressJobs} = lists:partition(fun({JN, _}) -> JN =:= JobNumber end, InProgressJobs),
      {noreply, {Index, ToDoJobs, NewInProgressJobs, [H | DoneJobs]}}
  end.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.