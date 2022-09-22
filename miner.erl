% Miner Master instance
-module(miner). 
-export([server/1,bitcoinRec/1,bitcoinCount/2,supervisor/1,run_forever/2,start/0]). 

sha(S) ->
    %io:fwrite("SHA Input : "),
    %io:fwrite(S),
    io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256,S))]).

get_comparison_string(N,Comp) when N == 1 -> string:concat(Comp,"");
get_comparison_string(N,Comp) when N > 1 -> string:concat(Comp,get_comparison_string(N-1,Comp)).
%to generate string of 0's

get_random_string() ->
    Length = 32,
    AllowedChars = "abcdefghijklmnopqrstABCDEFGHIJKLMNOPQRST1234567890",
    lists:foldl(fun(_, Acc) ->
                        [lists:nth(rand:uniform(length(AllowedChars)),
                                   AllowedChars)]
                            ++ Acc
                end, [], lists:seq(1, Length)).


compute(Compare1,Counter_PID) ->
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
            %io:fwrite("INPUT : "),
            io:fwrite(Input),
            %io:fwrite(" SHA256 : "),
            io:fwrite("\t"),
            io:fwrite(SHARes),
            %io:fwrite(" Flag : "),
            %io:fwrite("~w",[Flag]),
            io:fwrite("\n"),
            Counter_PID ! {appendcountmaster};
        true ->
            Temp=0
        end.

        %append to list if bitcoin
    % LOOP ENDS

run_forever(Compare1,Counter_PID) ->

    compute(Compare1,Counter_PID),
    run_forever(Compare1,Counter_PID).

server(Compare) -> 
    receive
        {request,Return_PID} ->
        io:format("SERVER ~w: Client request received from ~w~n",
                 [self(), Return_PID]),
        Return_PID ! {hit_count,Compare}, 
        server(Compare)
    end.

bitcoinRec(Counter_PID) -> 
    receive
        {bitcoin,Input,SHARes,Flag} ->
            %io:fwrite("INPUT : "),
            io:fwrite(Input),
            %io:fwrite(" SHA256 : "),
            io:fwrite("\t"),
            io:fwrite(SHARes),
            %io:fwrite(" Flag : "),
            %io:fwrite("~w",[Flag]),
            io:fwrite("\n"),
            Counter_PID ! {appendcountworker},
        bitcoinRec(Counter_PID)
    end.

bitcoinCount(MasterCount,WorkerCount) -> 
    receive
        {appendcountmaster} ->
            %io:fwrite(" MCount : "),
            %io:fwrite("~w",[MasterCount]),
            %io:fwrite("\n"),   
            bitcoinCount(MasterCount+1,WorkerCount);

        {appendcountworker} ->
            %io:fwrite(" WCount : "),
            %io:fwrite("~w",[WorkerCount]),
            %io:fwrite("\n"),   
            bitcoinCount(MasterCount,WorkerCount+1);

        {getmastercount,Return_PID} ->
            %io:fwrite(" MCount requested : "),
            %io:fwrite("~w",[MasterCount]),
            %io:fwrite("\n"),
            Return_PID ! {mastercount,MasterCount},   
            bitcoinCount(MasterCount,WorkerCount);

        {getworkercount,Return_PID} ->
            %io:fwrite(" WCount requested : "),
            %io:fwrite("~w",[WorkerCount]),
            %io:fwrite("\n"),
            Return_PID ! {workercount,WorkerCount},   
            bitcoinCount(MasterCount,WorkerCount);
        
        {gettotalcount,Return_PID} ->
            %io:fwrite(" TCount requested : "),
            Total = MasterCount + WorkerCount,
            %io:fwrite("~w",[Total]),
            %io:fwrite("\n"),
            Return_PID ! {totalcount,Total},   
            bitcoinCount(MasterCount,WorkerCount)



    end.
%to maintain count of bitcoins mined by master


loop(0,_,_) ->
    ok;
    loop(Count,Counter_PID,Compare1) ->
        %io:fwrite("Count is : ~w \n",[Count]),
        %io:fwrite("collector through For loop : ~w",[Counter_PID]),
        %io:fwrite(Compare1),

        Miner_PID = spawn(miner,run_forever,[Compare1,Counter_PID]),
        io:fwrite("MINER PID at this worker node : ~w \n",[Miner_PID]),
        %this loop

        loop(Count-1,Counter_PID,Compare1).


supervisor(Counter_PID) ->

    timer:sleep(30000),

    io:fwrite("Supervisor report after 30 Sec : \n"),
    
    Runt=statistics(runtime),
    io:fwrite("Runtime : ~p~n \n",[Runt]),
    
    Wallc=statistics(wall_clock),
    io:fwrite("Wall Clock : ~p~n \n",[Wallc]),

    
    Counter_PID ! {getmastercount, self()},
    receive
        {mastercount,MasterCount} ->
            Mcount = MasterCount
    end,
    io:fwrite("Master Count : ~w \n",[Mcount]),

    Counter_PID ! {getworkercount, self()},
    receive
        {workercount,WorkerCount} ->
            Wcount = WorkerCount
    end,
    io:fwrite("Worker Count : ~w \n",[Wcount]),

    Counter_PID ! {gettotalcount, self()},
    receive
        {totalcount,Total} ->
            Tcount = Total
    end,
    io:fwrite("Total Count : ~w \n",[Tcount]),
    
    supervisor(Counter_PID).


start() ->

    
    {ok, Z} = io:read("Enter the number of leading zeroes : "),
    %io:fwrite("Number of Zeroes : "),
    %io:fwrite("~w",[Z]),

    Compare1=get_comparison_string(Z,"0"),
    %io:fwrite(" get_comparison_string "),
    %io:fwrite(Compare1),

    Server_PID = spawn(miner,server,[Z]),
    %io:fwrite("Server PID : ~w",[Server_PID]),
    register(bigboss,Server_PID),
    Where = whereis(bigboss),
    io:fwrite("Bigboss PID : ~w",[Where]),

    Counter_PID = spawn(miner,bitcoinCount,[1,1]),
    %io:fwrite("Counter PID : ~w",[Counter_PID]),
    register(counter,Counter_PID),
    WhereCo = whereis(counter),
    io:fwrite("Counter PID : ~w",[WhereCo]),

    Reciever_PID = spawn(miner,bitcoinRec,[Counter_PID]),
    %io:fwrite("Reciever PID : ~w",[Reciever_PID]),
    register(collector,Reciever_PID),
    WhereC = whereis(collector),
    io:fwrite("Collector PID : ~w",[WhereC]),

    Supervisor_PID = spawn(miner,supervisor,[Counter_PID]),
    %io:fwrite("Supervisor PID : ~w",[Supervisor_PID]),
    register(supervisor,Supervisor_PID),
    WhereS = whereis(supervisor),
    io:fwrite("Supervisor PID : ~w",[WhereS]),

    io:fwrite("\n"),

    LogicalProcessors = erlang:system_info(logical_processors_available),
    io:fwrite("Logical processors : ~w \n",[LogicalProcessors]),
    %calculate the number of processors for this node which will be used to spawn appropriate number of miners

    loop(LogicalProcessors,Counter_PID,Compare1).
    


    