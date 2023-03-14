# 1. Создал функцию to_rub/1, которая конвентируют заданное количество рублей в другие типы валют.

Вывод консоли: 

2> converter:to_rub({usd, 100}).  
Convert usd to rub, amount 100  
{ok,7550.0}  
3> converter:to_rub({peso, 12}).  
Convert peso to rub, amount 12  
{ok,36}  
4> converter:to_rub({yene, 30}).  
Error convert yene to rub  
{error,badarg}  
5> converter:to_rub({euro, -15}).  
Error convert euro to rub  
{error,badarg}  

В 4 строке выдало ошибку, так как yene в функции не существует; в 5 строке потому что amount не прошла проверку >0.

# 2. Разница между to_rub2/1 и to_rub3/1.

Вывод консоли to_rub2:

6> converter:to_rub2({usd, 100}).  
Convert usd to rub, amount 100  
Converted usd to rub, amount 100, Result {ok,7550.0}  
{ok,7550.0}  
7> converter:to_rub2({peso, 12}).  
Convert peso to rub, amount 12  
Converted peso to rub, amount 12, Result {ok,36}  
{ok,36}  
8> converter:to_rub2({yene, 30}).  
Error convert yene to rub  
Converted yene to rub, amount 30, Result {error,badarg}  
{error,badarg}  
9> converter:to_rub2({euro, -15}).  
Error convert euro to rub  
Converted euro to rub, amount -15, Result {error,badarg}  
{error,badarg}  

Вывод консоли to_rub3:

10> converter:to_rub3({usd, 100}).   
Convert usd to rub, amount 100  
{ok,7550.0}  
11> converter:to_rub3({peso, 12}).   
Convert peso to rub, amount 12  
{ok,36}  
12> converter:to_rub3({yene, 30}).   
Error convert yene to rub  
{error,badarg}  
13> converter:to_rub3({euro, -15}).  
Error convert euro to rub  
{error,badarg}  

Разница в том, что to_rub2 присваивает Result результат из case, поэтому мы можем этот результат использовать по необходимости дальше; функция to_rub3 выводит результат последней строки подходящего элемента, то есть никуда не записывает.
to_rub3 делает только одно действие, ее следует использовать, если необходимо выполнить одно действие. Если нужно будет работать с результатом дальше, то лучше использовать to_rub2.