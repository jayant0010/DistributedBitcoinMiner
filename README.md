# Distributed Bitcoin Mining using Erlang 

COP5615 - Distributed Operating Systems Principles : Project 1

Bitcoins (seehttp://en.wikipedia.org/wiki/Bitcoin) are the most popular crypto-currency in common use. At their heart, bitcoins use the hardness of cryptographic hashing (for a reference seehttp://en.wikipedia.org/wiki/Cryptographichashfunction)to ensure a limited “supply” of coins.  In particular, the key component in a bit-coin is an input that, when “hashed” produces an output smaller than a target value.  In practice, the comparison values have leading  0’s, thus the bitcoin is required to have a given number of leading 0’s (to ensure 3 leading 0’s, you look for hashes smaller than0x001000... or smaller or equal to 0x000ff....The hash you are required to use is SHA-256.  You can check your version against this online hasher:http://www.xorbin.com/tools/sha256-hash-calculator. For example, when the text “COP5615 is a boring class” is hashed, the value fb4431b6a2df71b6cbad961e08fa06ee6fff47e3bc14e977f4b2ea57caee48a4 is obtained.  For the coins, you find, check your answer with this calculator to ensure correctness. The goal of this first project is to use Erlang and the Actor Model to build a good solution to this problem that runs well on multi-core machines.

## Authors

* **Saijayanth Chidirala** - *UF ID: 2649 6282* - [Github](https://github.com/jayant0010)
* **Omkar Parab** - *UF ID: 1134 4522* - [Github](https://github.com/omcar04)

## Size of the work unit 

This erlang implementation uses a master - worker architecture to mine bitcoins efficiently. The primary function of the master is to control the worker nodes, accept connection requests from worker nodes, pass the user input to worker nodes and accept mined bitcoins from worker nodes. Along with said primary functions, the master node also mines bitcoins and is capable of doing so in a standalone configuration. At the worker nodes, the number of mining threads is one less than total number of logic cores present on that physical node. This is done to make sure that each node can mine as many bitcoins as possible. The mined bitcoins are sent to the master node via message passing.

## Sample Output

saijayanthchidirala@darth ~ % cd Desktop/miner 
saijayanthchidirala@darth miner % erl -name master@192.168.0.138 -setcookie dospsj

Erlang/OTP 25 [erts-13.0.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit] [dtrace]

Eshell V13.0.4  (abort with ^G)
(master@192.168.0.138)1> c(miner).
{ok,miner}
(master@192.168.0.138)2> miner:start().
Enter the number of leading zeroes : 4.
Bigboss PID : <0.96.0>Counter PID : <0.97.0>Collector PID : <0.98.0>Supervisor PID : <0.99.0>
Logical processors : 8 
MINER PID at this master node : <0.100.0> 
MINER PID at this master node : <0.101.0> 
MINER PID at this master node : <0.102.0> 
MINER PID at this master node : <0.103.0> 
MINER PID at this master node : <0.104.0> 
MINER PID at this master node : <0.105.0> 
MINER PID at this master node : <0.106.0> 
MINER PID at this master node : <0.107.0> 
ok
saijayanchidira;fkNlNjTdp2ST7MHQepfL1NT0HogfEjGG        0000ed7aa6571d6ae68ccfa8bd8e4ea0b8576fc79b750947092e31979920919e                         
saijayanchidira;lASCltr2PB0kn36sBOCNhjqrdjBofOAn        0000987cb9fedd6b7f7f3f8dcc7fa0faf01a20f7ef10154c656ed030036420ab                         
saijayanchidira;25G6DkF8ICCR8tHSO0Jc6erTcFqE1AAS        00005253737559215914f0a1c7a5a4454c2d26909eaba71d943ea335738a063f                         
saijayanchidira;H4ECrojbcKHomB82ECoSEJL8QB5PHdNS        000099251b5536fde47cd613a5df8ceae3a93d6675686584091f428099bb020e                         
saijayanchidira;JC1DgMajTF9tnt0nAEAJgSHQRNnO7D34        0000ed4f660f95ea1d038bb5d52a1d1fa9ceed7ad3ef323b8d3e23caf265a6a7                         
saijayanchidira;1jGSed1cBGKCcRkfoAcHLgJch84FDMcP        0000d78781733a173b85106cda77f095c9adfde2707c00a5128ea02f9eff131c                         
saijayanchidira;dO8T6t2HOqEJsB11PHsfhFrgmmJR2oCF        00003b7011264cd7d51cc468103981b3d1cca5026e9f05556928fe28312a9c97                         
saijayanchidira;H2mtmStS5aL1l3SSaENgEIkEc52cbrDI        0000fbb5f4fd85558d5fa8b1ff5e4f174cbc96c9212a79fb1781e0d6a11ba5a4                         
saijayanchidira;3p9HQL0BnJtFaQENrIBJq8osBEDeiSsI        000023e99776f0c9ba1bff1b065bb5b8657dc4c736cd998eaed9ce8b88f4806b                         
saijayanchidira;jCAMcMT4HHNnj3AqHdddirJ8nas23ed7        00001c32f4576f46c64e90c6812470bedd7b628afd98aa0fc5e9d26ae82875f2                         
saijayanchidira;StorR7p2qtQM5Ce78Id5hSTpRdnJH02n        000017b9e3bb37ae5fb427b582c01fa77c363e5873c4d2170c0655e80b5aabdf                         
SERVER <0.96.0>: Client request received from <9334.86.0>
saijayanchidira;Dq3pLHbkjH1t2MOHd96F4TrP5LqdHBFs        0000c58394980e5e8b807433e7d2fd450844a2473b68a0c94cea14fe0381109f                         
saijayanchidira;Q5nABpjaReNn9JDpktH0F0L2rrqbqH81        00002c17959dc0fa1402688c800769de0eda27f8483831f70eca7c7f471c4e72                         


## Running Time

Runtime : {239193,117856} [CPU_Time]
 
Wall Clock : {101837,30001} [Real_Time]

CPU_Time/Real_Time=2.34

## Coin with most zeroes (7) :

saijayanchidira;fJSKjsrqnADPDa0gln4KGDrq2Smgc7Qs        00000004be2b4ba40dd2af7ac326c5ac4747828b5ecd0b771fdba914f26d00cb   


## Largest number of working machines on which the code was run

The code was simultaneously run on 6 machines with one functioning as server and the other 5 as workers.

# Getting Started/Prerequisites

Follow these instructions to get the implementation up and running.

## Erlang

Please use Erlang >= 20.0, available at <https://www.erlang.org/downloads>.

## Initiate Master Node

saijayanthchidirala@darth ~ % cd Desktop 
saijayanthchidirala@darth Desktop % erl -name master@192.168.0.138 -setcookie dospsj
Erlang/OTP 25 [erts-13.0.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit] [dtrace]

Eshell V13.0.4  (abort with ^G)
(master@192.168.0.138)1> c(miner).
{ok,miner}
(master@192.168.0.138)2> miner:start().

The master node asks for a user input through the command line 'Enter the number of leading zeroes :'. This is the only user input needed in the entire system including for the worker nodes. This input needs to be an integer. On successful entry, the master hashes random strings using SHA256 and prints the hashes with the number of leading zeroes as entered by the user. The master also spawns the handshake server, counter server and the collector server before registering them.

## Initiate Worker Nodes

saijayanthchidirala@darth ~ % cd Desktop 
saijayanthchidirala@darth Desktop % erl -name worker@192.168.0.138 -setcookie dospsj
Erlang/OTP 25 [erts-13.0.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit] [dtrace]

Eshell V13.0.4  (abort with ^G)
(worker@192.168.0.138)1> net_adm:ping('master@192.168.0.138').
pong
(worker@192.168.0.138)2> c(minerclient).
{ok,minerclient}
(worker@192.168.0.138)3> minerclient:start().
 
A worker node, on initiation, looks up the register for the handshake server and the collector server. Once the worker node has the PIDs of required servers, it contacts the handshake server and recieves the user input(leading zeroes) from the master. Once the said information is recieved, the worker starts mining bitcoins of the required specification and sends mined bitcoins to the master via the collector PID. All communication between the master and the server happen through message passing. The worker is capable of identifying the number of logical cores available on the node and spawns multiple mining processes the total of which is one less than the number of available logical cores.

## Built With

* [Erlang](https://www.erlang.org) - Erlang is a dynamic, functional language designed for building scalable and efficient distributed applications.
* [Visual Studio Code](https://code.visualstudio.com/) - Code Editor
* [Github](https://github.com/jayant_0010/DistributedBitcoinMiner) - Dependency Management
