-module(catalog_spec_check).

-export([
	 start/0,
	 %% Support
	 all_files/0,
	 all_info/0
	]).


-define(Dir,".").
-define(FileExt,".catalog").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    
    check(all_info()),
    init:stop(),
    ok.

check([])->
    io:format("Success, OK ! ~n");
check([{ok,Info}|T])->
    io:format("Checking ~p~n",[Info]),
    ok=check_map(Info),
   check(T).

check_map([])->
    ok;    
check_map([Map|T])->
    L=[maps:get(id,Map),maps:get(git_path,Map),maps:get(dir,Map)],
    
    ok=case lists:member(undefined,L) of
	  false->
	       ok;
	   true ->
	       {error,[L]}
       end,
    check_map(T).

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
all_files()->
    {ok,Files}=file:list_dir(?Dir),
    FileNames=[filename:join(?Dir,Filename)||Filename<-Files,
					     ?FileExt=:=filename:extension(Filename)],
    FileNames.    
all_info()->
    [file:consult(File)||File<-all_files()].
	    
    
