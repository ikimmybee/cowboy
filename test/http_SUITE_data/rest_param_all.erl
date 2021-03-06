-module(rest_param_all).

-export([init/2]).
-export([allowed_methods/2]).
-export([content_types_provided/2]).
-export([get_text_plain/2]).
-export([content_types_accepted/2]).
-export([put_text_plain/2]).

init(Req, Opts) ->
	{cowboy_rest, Req, Opts}.

allowed_methods(Req, State) ->
	{[<<"GET">>, <<"PUT">>], Req, State}.

content_types_provided(Req, State) ->
	{[{{<<"text">>, <<"plain">>, '*'}, get_text_plain}], Req, State}.

get_text_plain(Req, State) ->
	{_, _, Param} = maps:get(media_type, Req, {{<<"text">>, <<"plain">>}, []}),
	Body = if
		Param == '*' ->
			<<"'*'">>;
		Param == [] ->
			<<"[]">>;
		Param /= [] ->
			iolist_to_binary([[Key, $=, Value] || {Key, Value} <- Param])
	end,
	{Body, Req, State}.

content_types_accepted(Req, State) ->
	{[{{<<"text">>, <<"plain">>, '*'}, put_text_plain}], Req, State}.

put_text_plain(Req, State) ->
	{true, Req, State}.
