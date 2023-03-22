-module(protocol).
-export([ipv4/1, ipv4_listener/0]).
-include("protocol.hrl").

ipv4(<<Version:4, IHL:4, Tos:8, TotalLength:16,
    Identification:16, Flags:3, FragOffset:13,
    TimeToLive:8, Protocol:8, Checksum:16,
    SourceAddress:32, DestinationAddress:32,
    OptionsAndPadding:((IHL-5)*32)/bits,
    RemainingData/bytes>>) when Version =:= 4 ->
    #ipv4{
        version = Version,
        ihl = IHL,
        tos = Tos,
        total_length = TotalLength,
        identification = Identification,
        flags = Flags,
        frag_offset = FragOffset,
        ttl = TimeToLive,
        protocol = Protocol,
        checksum = Checksum,
        source_addr = SourceAddress,
        dest_addr = DestinationAddress,
        options = OptionsAndPadding,
        data = RemainingData
    };
ipv4(_) ->
    error(badarg, ["Unexpected data format"]).

ipv4_listener() ->
    receive
        {ipv4, From, BinData} when is_binary(BinData) ->
            From ! protocol:ipv4(BinData);
        _ ->
            error(badarg, ["Unexpected message format"])
    end.