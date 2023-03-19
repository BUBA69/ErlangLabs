# 1. Создал заголовочный файл person.hrl в котором создал кортеж -record(person) и константы MALE и FEMALE.
Затем создал модуль persons.erl и в нем функции:
filter/2 - функцию фильтрации списка персон
all/2 - функцию проверки, что все персоны подходят под условие (lists:all/2)
any/2 - функцию проверки, что хотя бы одна персона подходит под условие
update/2 - функцию обновления данных персон
get_average_age/1 - функцию подсчета среднего возраста персон из списка

Вызвал функции:
1) Получите список из персон старше 30 лет:

persons:filter(fun(#person{age = Age}) -> Age >= 30 end, Persons).
[#person{id = 3,name = "Jack",age = 34,gender = male},
 #person{id = 4,name = "Nata",age = 54,gender = female}]

2) Получите список из мужчин:

persons:filter(fun(#person{gender = Gender}) -> Gender =:= male end, Persons).
[#person{id = 1,name = "Bob",age = 23,gender = male},
 #person{id = 3,name = "Jack",age = 34,gender = male}]

3) Проверьте, что в списке есть хотя бы одна женщина:

persons:any(fun(#person{gender = Gender}) -> Gender =:= female end, Persons).
true

4) Проверьте, что в списке все старше 20 (включая):

persons:all(fun(#person{age = Age}) -> Age >= 20 end, Persons).
true

5) Проверьте, что в списке все младше 30 (включая):

persons:all(fun(#person{age = Age}) -> Age =< 30 end, Persons).
false

6) Обновите возраст (+1) персоне с именем Jack:

UpdateJackAge = fun(#person{name = "Jack", age = Age} = Person) -> Person#person{age = Age + 1}; (Person) -> Person end.
#Fun<erl_eval.42.3316493>

persons:update(UpdateJackAge, Persons).
[#person{id = 1,name = "Bob",age = 23,gender = male},
 #person{id = 2,name = "Kate",age = 20,gender = female},
 #person{id = 3,name = "Jack",age = 35,gender = male},
 #person{id = 4,name = "Nata",age = 54,gender = female}]

7) Обновите возраст (-1) всем женщинам

UpdateFemaleAge = fun(#person{gender = female, age = Age} = Person) -> Person#person{age = Age - 1}; (Person) -> Person end.
#Fun<erl_eval.44.65746770>

persons:update(UpdateFemaleAge, Persons).  
[#person{id = 1,name = "Bob",age = 23,gender = male},    
 #person{id = 2,name = "Kate",age = 19,gender = female},
 #person{id = 3,name = "Jack",age = 34,gender = male},
 #person{id = 4,name = "Nata",age = 53,gender = female}]
 
# 2. Eshell: List comprehensions 
1) Используя генераторы списков, создайте набор целых чисел от 1 до 10, которые делятся на три (например, [3,6,9]).

23> [X || X <- lists:seq(1, 10), X rem 3 =:= 0]. 
[3,6,9]

Генерируем список "X", в котором хранятся значения от 1 до 10, затем условие X rem 3 =:= 0; 
ищет числа, которые делятся на 3 без остатка

2) Используя генераторы списков, удалите все нецелые числа из списка.
Возвращается список целых чисел в квадрате: [1, “hello”, 100, boo, "boo", 9]
должен возвращать [1, 10000, 81].

24> [X * X || X <- [1, "hello", 100, boo, "boo", 9], is_integer(X)].
[1,10000,81]

Генерируем список X <- [1, "hello", 100, boo, "boo", 9], в котором хранятся различные типы значений. 
Затем использую условие is_integer(X), которое выбирает только целочисленные значения. Возводим в квадрат список.

# 3. Добавил функцию catch_all/1 в новый модуль exceptions.erl
3> c("exceptions.erl").
{ok,exceptions}

4> exceptions:catch_all(fun() -> 1/0 end).
Action #Fun<erl_eval.45.65746770> failed, reason badarith
error

Функция деления на ноль вызывает исключение badarith, 
которое обрабатывается блоком error:Reason и выводится сообщение об ошибке.

5> exceptions:catch_all(fun() -> throw(custom_exceptions) end).
Action #Fun<erl_eval.45.65746770> failed, reason custom_exceptions
throw

Функция throw/1 вызывает пользовательское исключение custom_exceptions.

6> exceptions:catch_all(fun() -> exit(killed) end).
Action #Fun<erl_eval.45.65746770> failed, reason killed
exit

Функция exit/1 прерывает выполнение программы с помощью сигнала killed.

7> exceptions:catch_all(fun() -> erlang:error(runtime_exception) end).
Action #Fun<erl_eval.45.65746770> failed, reason runtime_exception
error

Функция erlang:error/1 вызывает исключение runtime_exception.