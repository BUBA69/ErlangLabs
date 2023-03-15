# 1. Создал функцию rec_to_rub/1, на вход которой поступает record(кортеж) и возращает результат конвертации в рубли после вычета комиcсии.

1> rr("converter.hrl").
[conv_info]

2> c("converter.erl").  
{ok,converter}

3> converter:rec_to_rub(#conv_info{type = usd, amount = 100, commission = 0.01}).   
{ok,7549.0}   
  
4> converter:rec_to_rub(#conv_info{type = peso, amount = 12, commission = 0.02}).   
{ok,35.76}   
 
5> converter:rec_to_rub(#conv_info{type = yene, amount = 30, commission = 0.02}).   
Error arg {conv_info,yene,30,0.02}   
{error,badarg}    

6> converter:rec_to_rub(#conv_info{type = euro, amount = -15, commission = 0.02}). 
Error arg {conv_info,euro,-15,0.02}    
{error,badarg}   

# 2. Добавил функцию map_to_rub/1, на вход которой поступает map и возращает результат конвертации в рубли после вычета комисcии.

7> converter: map_to_rub(#{type => usd, amount => 100, commission => 0.01}).    
{ok,7549.0}    

8> converter: map_to_rub(#{type => peso, amount => 12, commission => 0.02}).   
{ok,35.76}    

9> converter: map_to_rub(#{type => yene, amount => 30, commission => 0.02}).    
Error arg #{amount => 30,commission => 0.02,type => yene}   
{error,badarg}      

10> converter: map_to_rub(#{type => euro, amount => -15, commission => 0.02}).      
Error arg #{amount => -15,commission => 0.02,type => euro}      
{error,badarg}      

# 3. Создал модуль recursion.erl
    3.1. Добавил функцию tail_fac/1
    12> recursion:tail_fac(7).      
    5040        
    
    13> recursion:tail_fac(0).      
    1       

    3.2. Добавил функции duplicate/1 и tail_duplicate/1
    14> recursion:duplicate([1,2,3]).       
    [1,1,2,2,3,3]       

    15> recursion:duplicate([]).              
    []      

    16> recursion:tail_duplicate([3,2,1]).      
    [3,3,2,2,1,1]       

    17> recursion:tail_duplicate([]).           
    []      
    
# 4. В Eshell создал алиасы для функций recursion:tail_fac/1 и recursion:tail_duplicate/1

18> Fac = fun recursion:tail_fac/1.     
fun recursion:tail_fac/1        

19> Fac(10).        
3628800     

20> Fac1 = fun recursion:tail_duplicate/1.
fun recursion:tail_duplicate/1

21> Fac1([3,2,1]).
[3,3,2,2,1,1]

# 5. Написал анонимные функции:
    5.1 Умножение двух элементов
    2> GEN = fun(X, Y) -> {ok, X*Y} end.    
    #Fun<erl_eval.41.3316493>
    3> GEN(10,15).
    {ok,150}

    5.2 Функция из прошлой ДР
    ToRub = fun({usd, Amount}) when is_integer(Amount), Amount > 0 -> {ok, Amount * 75.5}; ({euro, Amount}) when is_integer(Amount), Amount > 0 -> {ok, Amount * 80};({lari, Amount}) when is_integer(Amount), Amount > 0 -> {ok, Amount * 29};({peso, Amount}) when is_integer(Amount), Amount > 0 -> {ok, Amount * 3};({krone, Amount}) when is_integer(Amount), Amount > 0 -> {ok, Amount * 10};(Error) -> io:format("Error arg ~p~n",[Error]),{error, badarg} end.

    #Fun<erl_eval.42.3316493>

    22> ToRub({usd, 100}).      
    {ok,7550.0}     

    23> ToRub({peso, 12}).      
    {ok,36}     

    24> ToRub({yene, 30}).      
    Error arg {yene,30}     
    {error,badarg}      

    25> ToRub({euro, -15}).     
    Error arg {euro,-15}        
    {error,badarg}