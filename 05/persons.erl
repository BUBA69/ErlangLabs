-module(persons).
-include("person.hrl").
-export([filter/2, all/2, any/2, update/2, get_average_age/1]).

filter(Fun, Persons) -> lists:filter(Fun, Persons).
all(Fun, Persons) -> lists:all(Fun, Persons).
any(Fun, Persons) -> lists:any(Fun, Persons).
update(Fun, Persons) -> lists:map(Fun, Persons).
get_average_age(Persons) ->
    {AgeSum, PersonsCount} = lists:foldl(
        fun(#person{age=Age}, {Sum, Count}) -> {Sum + Age, Count + 1} end,
        {0, 0},
        Persons
    ),
    if
        PersonsCount > 0 ->
            AgeSum / PersonsCount;
        true ->
            0
    end.