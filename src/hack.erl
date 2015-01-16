-module(hack).
-export([main/1]).

-define(PREFIX, "templates/").
-define(PREFIX_LEN, 10).

main([]) ->
    io:format("Usage:\n"),
    io:format("  ./hack myproject\n"),
    io:format("\n"),
    erlang:halt(1);

main([Project]) ->
    {ok, Zip} = hack_zip:read_file("priv/templates.zip"),
    {ok, Zs} = zip:list_dir(Zip),
    Templates = lists:filtermap(fun is_template/1, Zs),
    lists:foreach(fun({FullPath, Info}) -> extract_template(string:to_lower(Project), Zip, FullPath, Info) end, Templates),
    file:change_mode("rebar", 8#0777),
    ok.

is_template({zip_file, Path, Info, _, _, _}) ->
    is_template(lists:sublist(Path, 1, ?PREFIX_LEN), Path, Info);
is_template(_) ->
    false.

is_template(?PREFIX, Path, Info) ->
    {true, {Path, Info}};
is_template(_, _Path, _Info) ->
    false.

extract_template(_Project, _Zip, FullPath, Info) when element(3, Info) =:= directory ->
    Path = get_dest_path(FullPath),
    make_template_dir(Path),
    ok;
extract_template(Project, Zip, FullPath, Info) ->
    Path = get_dest_path(FullPath),
    write_template_file(Project, Path, Info, zip:extract(Zip, [{file_list, [FullPath]}, memory])),
    ok.

make_template_dir("") ->
    ok;
make_template_dir(Path) ->
    io:format("mkdir ~p\n", [Path]),
    file:make_dir(Path).

write_template_file(Project, Path, _Info, {ok, [{_Name, Content}]}) ->
    DestPath = re:replace(Path, "myproject", Project, [{return, list}]),
    io:format("write ~p\n", [DestPath]),
    DestContent = binary:replace(Content, <<"myproject">>, list_to_binary(Project), [global]),
    ok = file:write_file(DestPath, DestContent).

get_dest_path(FullPath) ->
    lists:sublist(FullPath, ?PREFIX_LEN + 1, length(FullPath)).
