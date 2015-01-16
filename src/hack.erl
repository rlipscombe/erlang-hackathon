-module(hack).
-export([main/1]).

-define(PREFIX, "priv/templates/").
-define(PREFIX_LEN, 15).

main([]) ->
    io:format("Usage:\n"),
    io:format("  ./hack myproject\n"),
    io:format("\n"),
    erlang:halt(1);

main([_Project]) ->
    {ok, Zs} = hack_zip:ls(),
    Templates = lists:filtermap(fun is_template/1, Zs),
    lists:foreach(fun extract_template/1, Templates),
    ok.

is_template({zip_file, Path, Info, _, _, _}) ->
    is_template(lists:sublist(Path, 1, ?PREFIX_LEN), Path, Info);
is_template(_) ->
    false.

is_template(?PREFIX, Path, Info) ->
    {true, {Path, Info}};
is_template(_, _Path, _Info) ->
    false.

extract_template({FullPath, Info}) when element(3, Info) =:= directory ->
    Path = get_dest_path(FullPath),
    make_template_dir(Path),
    ok;
extract_template({FullPath, _Info}) ->
    Path = get_dest_path(FullPath),
    Content = hack_zip:read_file(FullPath),
    write_template_file(Path, Content),
    ok.

make_template_dir("") ->
    ok;
make_template_dir(Path) ->
    io:format("mkdir ~p\n", [Path]).

write_template_file(Path, Content) ->
    io:format("write ~p : ~p\n", [Path, Content]).

get_dest_path(FullPath) ->
    lists:sublist(FullPath, ?PREFIX_LEN + 1, length(FullPath)).
