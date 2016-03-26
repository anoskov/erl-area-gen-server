%%%-------------------------------------------------------------------
%%% @author Andrew Noskov
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Февраля 2016 03:13
%%%-------------------------------------------------------------------
-module(area_supervisor).
-author("Andrew Noskov").

-behaviour(supervisor).

%% API
-export([start/0, start_in_shell/0, start_link/1, init/1]).

start() ->
  spawn(fun() ->
    supervisor:start_link({local,?MODULE}, ?MODULE, _Arg = [])
  end).

start_in_shell() ->
  {ok, Pid} = supervisor:start_link({local,?MODULE}, ?MODULE, _Arg = []),
  unlink(Pid).

start_link(Args) ->
  supervisor:start_link({local,?MODULE}, ?MODULE, Args).

init([]) ->
  gen_event:swap_handler(alarm_handler,
    {alarm_handler, swap},
    {my_alarm_handler, xyz}),

  {ok, {{one_for_one, 3, 10},
    [{tag1,
      {area_server, start_link, []},
      permanent,
      10000,
      worker,
      [area_server]}
    ]}}.