# 1. 
По умолчанию используем list = [] и counter = 0, т.к. в list будем хранить список кортежей, 
который должен быть пустым на старте, а в counter храним счетчик выполненных команд, должен быть равен 0 на старте

1> rr("keylist.hrl").
[state]
2> c(keylist).
{ok,keylist}
3> Pid = spawn(keylist, loop, [#state{list = [{andy, 99, "man"}], counter = 0}]).
<0.91.0>
4> Pid ! {self(), add, bob, 100, "man"}.
{<0.80.0>,add,bob,100,"man"}
5> flush().
Shell got {ok,{state,[{bob,100,"man"},{andy,99,"man"}],1}}
ok
6> Pid ! {self(), add, igor, 21, "man"}.
{<0.80.0>,add,igor,21,"man"}
7> flush().
Shell got {ok,{state,[{igor,21,"man"},{bob,100,"man"},{andy,99,"man"}],2}}
ok
8> Pid ! {self(), is_member, bob}.
{<0.80.0>,is_member,bob}
9> flush().
Shell got {true,{state,[{igor,21,"man"},{bob,100,"man"},{andy,99,"man"}],3}}
ok
10> Pid ! {self(), take, bob}.
{<0.80.0>,take,bob}
11> flush(). 
Shell got {{bob,100,"man"},{state,[{igor,21,"man"},{andy,99,"man"}],4}}
ok
12> Pid ! {self(), find, igor}.
{<0.80.0>,find,igor}
13> flush().                    
Shell got {{igor,21,"man"},{state,[{igor,21,"man"},{andy,99,"man"}],5}}
ok
14> Pid ! {self(), delete, igor}. 
{<0.80.0>,delete,igor}
15> flush().                      
ok

# 2. 
Процесс self() получает сообщения при отправке сообщения в процесс Link, т.к. мы слинковали эти два процесса, 
теперь они связаны и при выполнении одного из них второй так же получает сообщения.

1> self().
<0.104.0>
2> keylist:start(monitored).
{<0.108.0>,#Ref<0.2699350509.1806172161.170549>}
3> keylist:start_link(linked).
<0.110.0>
4> <0.108.0> ! {self(), add, igor, 21, "man"}. 
5> flush().
Shell got {ok,{state,[{igor,21,"man"}],1}}
ok

# 3. 
После заверщения процесса Monitored, процесс self() не завершился т.к. он был настроен только для мониторинга, 
при этом после завершения процесса Monitored, self() получает сообщение формата {'DOWN', MonitorRef, Type, Object, Info}. 
При завершении процесса Linked, процесс self() так же завершился, т.к. эти два процесса связаны, 
ри вызове команды flush() мы получаем ok, выполнение команды происходит в уже НОВОМ процессе self(), в который никаких сообщений не приходило.

1> self().
<0.80.0>
2> keylist:start(monitored).
{<0.83.0>,#Ref<0.26507251.2613837826.17198>}
3> exit(<0.83.0>, somereason).
true
4> flush().
ok
5> self().
<0.80.0>
6> keylist:start_link(linked).
<0.88.0>
7> exit(<0.88.0>, somereason).
true
8> flush().                   
ok
9> self().
<0.90.0>

# 4.
Создал линк между нашим процессом self() и процессом Linked, перед этим мы вызываем функцию process_flag(trap_exit, true). 
Если для trap_exit установлено значение true сигналы завершения процесса преобразуются в сообщения формата {'EXIT', From, Reason}, 
поэтому наш процесс self() не завершается, когда завершается связанный с ним процесс, а получает сообщение в свой mail box.

1> self().
<0.80.0>
2> process_flag(trap_exit, true).
false
3> keylist:start_link(linked). 
<0.84.0>
4> exit(<0.82.0>, somereason).
true
5> flush().                      
ok
6> self().
<0.80.0>

# 5.
Создал линк между нашим процессом self() и процессами Linked1 и Linked2, перед этим мы вызываем функцию process_flag(trap_exit, false). 
Если для trap_exit установлено значение false, процесс завершается, если он получает сигнал выхода, 
и сигнал выхода распространяется на связанные с ним процессы. Поэтому после завершения процесса Linked1, 
так же завершаются и процесс self() и процесс Linked2.

1> self().
<0.80.0>
2> process_flag(trap_exit, true).
false
3> keylist:start_link(linked). 
<0.85.0>
4> exit(<0.84.0>, somereason).
true
5> flush().                      
ok
6> self().
<0.80.0>


1> self().
<0.80.0>
2> process_flag(trap_exit, false). 
false
3> keylist:start_link(linked1).   
<0.84.0>
4> keylist:start_link(linked2).
<0.86.0>
5> exit(<0.82.0>, somereason).
true
6> self().                        
<0.80.0>
8> process_info(<0.90.0>).
undefined