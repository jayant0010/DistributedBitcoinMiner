% minerclient sigle instance
-module(minerclient). 
-export([server/1,run_forever/2,compute/2,get_random_string/0,start/0]). 

sha(S) ->
    %io:fwrite("SHA Input : "),
    %io:fwrite(S),
    io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256,S))]).

get_comparison_string(N,Comp) when N == 1 -> string:concat(Comp,"");
get_comparison_string(N,Comp) when N > 1 -> string:concat(Comp,get_comparison_string(N-1,Comp)).

get_random_string() ->
    Length = 32,
    AllowedChars = "abcdefghijklmnopqrstABCDEFGHIJKLMNOPQRST1234567890",
    lists:foldl(fun(_, Acc) ->
                        [lists:nth(rand:uniform(length(AllowedChars)),
                                   AllowedChars)]
                            ++ Acc
                end, [], lists:seq(1, Length)).

compute(Compare1,Collector_PID) ->
    %LOOP STARTS
        Random = get_random_string(),
        %io:fwrite("Random string is : "),
        %io:fwrite(Random),
        %generate string
        
        Input = string:concat("saijayanchidira;",Random),
        %io:fwrite("INPUT String : "),
        %io:fwrite(Input),
        SHARes=sha(Input),
        %io:fwrite(" SHA256 : "),
        %io:fwrite(SHARes),
        %compute SHA
        
        Index1 = string:str(SHARes,Compare1),
        %io:fwrite(" INDEX : "),
        %io:fwrite("~w",[Index1]),
        if Index1==1 ->
            Flag=1;
        true ->
            Flag=0
        end,

        %io:fwrite(" Flag : "),
        %io:fwrite("~w",[Flag]),
        %check for Zeroes

        if Flag==1 ->
            io:fwrite("INPUT : "),
            io:fwrite(Input),
            io:fwrite(" SHA Output : "),
            io:fwrite(SHARes),
            %io:fwrite(" Flag : "),
            %io:fwrite("~w",[Flag]),
            %io:fwrite("Master PID : ~w",[Collector_PID]),
            Temp = 0,%to indicate bitcoins mined by workers
            Collector_PID ! {bitcoin,Input,SHARes,Temp},
            io:fwrite("\n");
        true ->
            Temp=0
        end.

        %append to list if bitcoin
    % LOOP ENDS

run_forever(Compare1,Collector_PID) ->

    compute(Compare1,Collector_PID),
    run_forever(Compare1,Collector_PID).

server(Compare) -> 
    receive
        {request,Return_PID} ->
        io:format("SERVER ~w: Client request received from ~w~n",
                 [self(), Return_PID]),
        Return_PID ! {hit_count,Compare}, 
        server(Compare)
    end.

loop(0,_,_) ->
    ok;
    loop(Count,Collector_PID,Compare1) ->
        %io:fwrite("Count is : ~w \n",[Count]),
        %io:fwrite("collector through For loop : ~w",[Collector_PID]),
        %io:fwrite(Compare1),

        Miner_PID = spawn(minerclient,run_forever,[Compare1,Collector_PID]),
        io:fwrite("MINER PID at this worker node : ~w \n",[Miner_PID]),
        %this loop

        loop(Count-1,Collector_PID,Compare1).

start() ->
    
    
    Server_PID=rpc:call('master@192.168.0.138',erlang,whereis,[bigboss]),
    io:fwrite("bigboss through RPC : ~w",[Server_PID]),
    %fetch PID of handshake server

    Collector_PID=rpc:call('master@192.168.0.138',erlang,whereis,[collector]),
    io:fwrite("collector through RPC : ~w",[Collector_PID]),
    %fetch PID of bitcoin collector
    
    Counter_PID=rpc:call('master@192.168.0.138',erlang,whereis,[counter]),
    io:fwrite("counter through RPC : ~w",[Counter_PID]),
    %fetch PID of bitcoin counter

    LogicalProcessors = erlang:system_info(logical_processors_available),
    io:fwrite("Logical processors : ~w \n",[LogicalProcessors]),
    %calculate the number of processors for this node which will be used to spawn appropriate number of miners

    Server_PID ! {request, self()},
    receive
        {hit_count,Compare} ->
            Comp=Compare
    end,
    io:fwrite("Comp RPC : ~w",[Comp]),
    %recieve input from handshake server


    Compare1=get_comparison_string(Comp,"0"),
    io:fwrite(" get_comparison_string "),
    io:fwrite(Compare1),
    io:fwrite("\n"),
    loop(LogicalProcessors,Collector_PID,Compare1).
    


    