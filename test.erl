-module(test).
-compile(export_all).

do() ->
	inets:start(),

	UserId = "admin",
	Password = "admin",

	authenticate(UserId, Password).


authenticate(UserId, Password) ->
	UserId2 = edoc_lib:escape_uri(UserId),
	Password2 = edoc_lib:escape_uri(Password),
	Url = "http://127.0.0.1:8000/api/user/login/",

	Method = post,
	Body = lists:concat(["username=", UserId2, "&password=", Password2]),
	Request = {Url, [], "application/x-www-form-urlencoded", Body},
	{Code, Result} = httpc:request(Method, Request, [], []),
	case Code of
		error ->
			%io:format("~p~n", ["Authenticate error"]),
			false;
		ok ->
			{_, _, Content} = Result,
			{ok, {struct, Results}} = json2:decode_string(Content),
			_ReturnCode = proplists:get_value("code", Results),

			%io:format("Content: ~p~n", [Content]),
			%io:format("Code: ~p~n", [_ReturnCode]),
			true
	end.

