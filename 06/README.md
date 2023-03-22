# 1. Создал модуль protocol.erl и заголовоный файл protocol.hrl

1> c(protocol).                                                                                          
{ok,protocol}
2> rr("protocol.hrl").
[ipv4]
3> DataWrongFormat = <<4:4, 6:4, 0:8, 0:3>>.
<<70,0,0:3>>
4> DataWrongVer = <<6:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello">>.
<<102,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
5> Data1 = <<4:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello">>.
<<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
6> Data2 = <<4:4, 6:4, 1:8, 292:16, 1:16, 1:3, 1:13, 1:8, 1:8, 1:16, 1:32, 1:32, 1:32, "world">>.
<<70,1,1,36,0,1,32,1,1,1,0,1,0,0,0,1,0,0,0,1,0,0,0,1,119,
  111,114,108,100>>
7> protocol:ipv4(DataWrongFormat).                                                                       
** exception error: bad argument
     in function  protocol:ipv4/1
        called as protocol:ipv4("Unexpected data format")
8> protocol:ipv4(DataWrongVer).
** exception error: bad argument
     in function  protocol:ipv4/1
        called as protocol:ipv4("Unexpected data format")
9> protocol:ipv4(Data1).
#ipv4{version = 4,ihl = 6,tos = 0,total_length = 232,
      identification = 0,flags = 0,frag_offset = 0,ttl = 0,
      protocol = 0,checksum = 0,source_addr = 0,dest_addr = 0,
      options = <<0,0,0,0>>,
      data = <<"hello">>}
10> protocol:ipv4(Data2).
#ipv4{version = 4,ihl = 6,tos = 1,total_length = 292,
      identification = 1,flags = 1,frag_offset = 1,ttl = 1,
      protocol = 1,checksum = 1,source_addr = 1,dest_addr = 1,
      options = <<0,0,0,1>>,
      data = <<"world">>}

В protocol:ipv4(DataWrongFormat) и protocol:ipv4(DataWrongVer) возникает исключение, так как данные не соответствуют формату.
В protocol:ipv4(Data1) и protocol:ipv4(Data2) возращаются структуры данных #ipv4, содержащие информацию о переданных данных.

# 2.
2.1
12> spawn(fun() -> protocol:ipv4(Data1) end).
<0.106.0>
13> self().
<0.102.0>
14> spawn(fun() -> protocol:ipv4(DataWrongFormat) end).
<0.109.0>
=ERROR REPORT==== 22-Mar-2023::22:57:18.013000 ===
Error in process <0.109.0> with exit value:
{badarg,[{protocol,ipv4,
                   ["Unexpected data format"],
                   [{file,"protocol.erl"},{line,28}]}]}

15> spawn(fun() -> protocol:ipv4(Data1) end). 
<0.111.0>
16> self().
<0.102.0>

self(). - текущий pid в этом процессе равен <0.102.0>.
spawn(fun() -> protocol:ipv4(Data1) end) - вызов предыдущей функции в новом процессе с валидными данными Data1. Новый процесс равен <0.106.0>.
spawn(fun() -> protocol:ipv4(DataWrongFormat) end) - вызов предыдущей функции в новом процессе с невалидными данными DataWrongFormat. Новый процесс равен <0.109.0> и выводит отчет об ошибке.

self(). - текущий pid в этом процессе равен <0.102.0> pid не изменился, потому что обработчик ошибок не завершает весь процесс. 
spawn(fun() -> protocol:ipv4(Data1) end) - вызов функции protocol:ipv4(Data1), который принимает анонимную функцию в качестве аргумента. 
Это создаст новый процесс <0.111.0> и выполнит функцию в этом процессе.

2.2
18> ListenerPid = spawn(protocol, ipv4_listener, []).
<0.114.0>
19> Data1 = <<4:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello">>.
<<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
20> ListenerPid ! {ipv4, self(), Data1}.
{ipv4,<0.102.0>,
      <<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
        101,...>>}
21> flush().
Shell got {ipv4,4,6,0,232,0,0,0,0,0,0,0,0,<<0,0,0,0>>,<<"hello">>}
ok

Валидные данные Data1 = <<4:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello">>..
ListenerPid ! {ipv4, self(), Data1}. - отправка сообщения с валидными данными.
flush(). - проверили, что ответ получен, поскольку данные валидны.

2.3
24> ListenerPid = spawn(protocol, ipv4_listener, []).
<0.123.0>
25> WrongData = "Wrong args".
"Wrong args"
26> ListenerPid ! {ipv4, self(), WrongData}.
{ipv4,<0.120.0>,"Wrong args"}
=ERROR REPORT==== 22-Mar-2023::23:05:48.970000 ===
Error in process <0.123.0> with exit value:
{badarg,[{protocol,ipv4_listener,
                   ["Unexpected message format"],
                   [{file,"protocol.erl"},{line,35}]}]}
27> flush().
ok

Невалидные данные WrongData = "Wrong args"..
ListenerPid ! {ipv4, self(), WrongData}. - отправка сообщения с невалидными данными.
flush(). - проверили, что ответ не получен, поскольку данные невалидны.