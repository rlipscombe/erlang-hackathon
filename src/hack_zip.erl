-module(hack_zip).
-export([ls/0, read_file/1]).

ls() ->
    Zip = read_zip(),
    zip:list_dir(Zip).

read_file(Name) ->
    Zip = read_zip(),
    case zip:extract(Zip, [{file_list, [Name]}, memory]) of
        {ok, []} -> {error, {file_not_found, Name}};
        {ok, [{_, Bin}]} -> {ok, Bin};
        Other -> Other
    end.

read_zip() ->
    Path = get_escript_path(),
    {ok, Bin} = file:read_file(Path),
    split_zip(Bin).

get_escript_path() ->
    Which = code:which(?MODULE),
    % Which is something like
    % /home/roger/Source/imp/imp_server/smoke/smoke/smoke/ebin/smoke_zip.beam
    % We need /home/roger/Source/imp/imp_server/smoke/smoke, which means
    % stripping the filename, the 'ebin', and one of the 'smoke's.
    filename:dirname(filename:dirname(filename:dirname(Which))).

split_zip(Bin) ->
    {Pos, _} = binary:match(Bin, <<"PK">>),
    <<_:Pos/binary, ZipBin/binary>> = Bin,
    ZipBin.
