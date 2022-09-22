# Distributed Bitcoin Mining using Erlang 

COP5615 - Distributed Operating Systems Principles : Project 1

Bitcoins (seehttp://en.wikipedia.org/wiki/Bitcoin) are the most popular crypto-currency in common use. At their heart, bitcoins use the hardness of cryptographic hashing (for a reference seehttp://en.wikipedia.org/wiki/Cryptographichashfunction)to ensure a limited “supply” of coins.  In particular, the key component in a bit-coin is an input that, when “hashed” produces an output smaller than a target value.  In practice, the comparison values have leading  0’s, thus the bitcoin is required to have a given number of leading 0’s (to ensure 3 leading 0’s, you look for hashes smaller than0x001000... or smaller or equal to 0x000ff....The hash you are required to use is SHA-256.  You can check your version against this online hasher:http://www.xorbin.com/tools/sha256-hash-calculator. For example, when the text “COP5615 is a boring class” is hashed, the value fb4431b6a2df71b6cbad961e08fa06ee6fff47e3bc14e977f4b2ea57caee48a4 is obtained.  For the coins, you find, check your answer with this calculator to ensure correctness. The goal of this first project is to use Erlang and the Actor Model to build a good solution to this problem that runs well on multi-core machines.

## Authors

* **Saijayanth Chidirala** - *UF ID: 2649 6282* - [Github](https://github.com/jayant0010)
* **Omkar Parab** - *UF ID: 0000 0000* - [Github](https://github.com/)

## Size of the work unit 

This erlang implementation uses a master - worker architecture to mine bitcoins efficiently. The primary function of the master is to control the worker nodes, accept connection requests from worker nodes, pass the user input to worker nodes and accept mined bitcoins from worker nodes. Along with said primary functions, the master node also mines bitcoins and is capable of doing so in a standalone configuration. At the worker nodes, the number of mining threads is one less than total number of logic cores present on that physical node. This is done to make sure that each node can mine as many bitcoins as possible. The mined bitcoins are sent to the master node via message passing.

## Sample Output for Standalone Master

saijayanthchidirala@darth ~ % cd Desktop 
saijayanthchidirala@darth Desktop % cd miner
saijayanthchidirala@darth miner % erl -name master@192.168.0.138 -setcookie dospsj

Erlang/OTP 25 [erts-13.0.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit] [dtrace]

Eshell V13.0.4  (abort with ^G)
(master@192.168.0.138)1> c(miner).
{ok,miner}
(master@192.168.0.138)2> miner:start().
Enter the number of leading zeroes : 4.
Bigboss PID : <0.93.0>Counter PID : <0.94.0>Collector PID : <0.95.0>Supervisor PID : <0.96.0>
saijayanchidira;CfMd7GKBP2AeAbQ2lLT5NbITI4lM56gt        0000af0e40896118b85467e5bcdaffe2246156d4836df578c0361683a1b08218
saijayanchidira;AIES5jcjiffG5ad8cRE07bataA10DDb3        0000db6b99954766c86076660266d3b8ba33ff8b6df43f302e0d4efe948b41a1
saijayanchidira;4KfmB9AmNdkSic56GbJeSqGeONR524ft        0000ab1e93b6d3ea47f223a2ca0fb3bc206fc62632ba8848fcb4c9decfb28c63
saijayanchidira;qEBmpPRmrb3n4GEB7aK9BHDgjH64QRj1        00003eefab39fb5809bcdd119085cce28039e4294d92fee13b466deb2398fa97
saijayanchidira;Gom7D0mTICHcIF4IT1L9IkjjGP92IQh4        0000d9367da991fd6125671ab712eec640ff9038b6dac79e92e3d2590ee2f596
saijayanchidira;MmBdDfahgdPSQmBrHPar97EmEASNR8H8        000024414956ac2c2867f47656e239acba66b5bceb6d230b4a6f4a691620bf81
saijayanchidira;eIKRR5TfGqorcI0f0TQp2NR49cnr39Ee        0000d8dac009c8292ca80053a16b0343a3ea0a03f5670b328d9752ec820f90ad
saijayanchidira;SAsfoNlCRI3eN9M27hLNq0e7NN9heFmH        000066fe093624246073171175066700a9488477256949273815f1ccbb872d25
saijayanchidira;DqbS9MsGajfmpLiHMBg8i8SfSSJKtbgs        0000b2a5d3e900e20cfe594c49f959dae1f14041d86ed036f1ab26347034fc73
saijayanchidira;PGDRAKQkFqREDl7Rm1J0K5EAIOjPi0QI        0000b31fd4376f47279751d08beabc1f63e72e0e379110d24f6e12a723b934c9
saijayanchidira;PpJNTEte05NO84OgijgF5RI1dOboNRjl        0000df63ff0d08e595c9e6df020856baa40081a8ade0dc973770e18df822da23
saijayanchidira;KId766R9GTOms0Is7amRTfRHPhibMDgI        00002e3d7b41f3851a83f2f371e691c4cddd73ecd04ecd83499558f504a44915
saijayanchidira;MiBgkcO1K8DM20o7mkRrrg0Hk0hFLOqk        0000d3a49afb81a496ead14cf9225015173ca14a2d177283c34eb66de8aa84bc
saijayanchidira;i4AMC8BEceItSNKoOKfmrP452JTErBlT        00000330c935bc9f0db37f4f7893365d6b3f40e8e59fe74a2b4cca635a665981
saijayanchidira;8ATHrRG8lr1eAoOiBIItFh4bCKAn03Jt        00009ce7a4070bd7b5252240ae9acf68a143cee9c840effa1cf05733365a9743
saijayanchidira;gOMC0dTODps005NIBf7ceeoi1NfqPoMp        00004551a78ad13c1cb91d631382a188ad653da56799058a0bb38da59e24bdd4
saijayanchidira;i4EbJGRaI9E6DrD996g5htKQdcNtb2fp        0000d9b5b2a9ec86f2e57df79aeca90426392a783fa71b7855454fb2a792547d
saijayanchidira;R1JblTRFFJr4sPBkcthTq9pIdmNj7T8S        00007ed1f53e135b9935e11ab9795d28ed6d6ba874d7a9c2d7065c0811fa58f7
saijayanchidira;cDE2jCa1molD6BBoKpaNK2titF8BME5k        00005bd1dd97b0fc37e122f60f52e3324d01327c62899985f46992bfff924481
saijayanchidira;dTQiSMQIpr3mirJfjkegjGOas4BRNIHg        0000ebb06801799f712a0c4d4014738dccb58104ac1a24cb8373eb2e36e0b94d
saijayanchidira;lisPaDT5i8G1SpNL2D62HnScIe87qDf6        000085c71565e593d689a80e07fb4d88558d49354bed89c0b092e6c30b82c699
saijayanchidira;mOH94jamc7ncc7M8D38fp2b6Qbt39a5e        000033410838b16698650803bf468401aaaada3c87df2b7dd7ad007e19d44ff6


## Sample Output for Master with Workers



## Running Time

Runtime : {177520,177520} [CPU_Time]
 
Wall Clock : {39282,39282} [Real_Time]

CPU_Time/Real_Time=4.51

## Coin with most zeroes (7) :

saijayanchidira;fJSKjsrqnADPDa0gln4KGDrq2Smgc7Qs        00000004be2b4ba40dd2af7ac326c5ac4747828b5ecd0b771fdba914f26d00cb   


## Largest number of working machines on which the code was run

The code was simultaneously run on 7 machines with one functioning as server and the other 6 as workers.

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
* [Github](https://github.com/jayant_0010) - Dependency Management
