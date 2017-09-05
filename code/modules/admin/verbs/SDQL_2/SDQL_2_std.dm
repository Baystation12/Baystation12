// Wrappers for BYOND default procs which can't directly be called by call().

/proc/_abs(A)
	return abs(A)

/proc/_animate(var/atom/A, var/variables, var/time = 10, var/loop = 1, var/easing = LINEAR_EASING)
	var/atom/movable/I = new
	I.appearance = A.appearance

	// The appearance churn is real.
	// WILL perform like shit until we get 511 and we get mutable appearances.
	for (var/variable in variables)
		I.vars[variable] = variables[variable]

	animate(A, appearance = I.appearance, time, loop, easing)

/proc/_acrccos(A)
	return arccos(A)

/proc/_arcsin(A)
	return arcsin(A)

/proc/_ascii2text(A)
	return ascii2text(A)

/proc/_block(Start, End)
	return block(Start, End)

/proc/_ckey(Key)
	return ckey(Key)

/proc/_ckeyEx(Key)
	return ckeyEx(Key)

/proc/_copytext(T, Start = 1, End = 0)
	return copytext(T, Start, End)

/proc/_cos(X)
	return cos(X)

/proc/_get_dir(Loc1, Loc2)
	return get_dir(Loc1, Loc2)

/proc/_get_dist(Loc1, Loc2)
	return get_dist(Loc1, Loc2)

/proc/_get_step(Ref, Dir)
	return get_step(Ref, Dir)

/proc/_hearers(Depth = world.view, Center = usr)
	return hearers(Depth, Center)

/proc/_image(icon, loc, icon_state, layer, dir)
	return image(icon, loc, icon_state, layer, dir)

/proc/_length(E)
	return length(E)

/proc/_link(thing, url)
	send_link(thing, url)

/proc/_locate(X, Y, Z)
	if (isnull(Y)) // Assuming that it's only a single-argument call.
		return locate(X)

	return locate(X, Y, Z)

/proc/_log(X, Y)
	return log(X, Y)

/proc/_lowertext(T)
	return lowertext(T)

/proc/_matrix(a, b, c, d, e, f)
	return matrix(a, b, c, d, e, f)

/proc/_max(...)
	return max(arglist(args))

/proc/_md5(T)
	return md5(T)

/proc/_min(...)
	return min(arglist(args))

/proc/_new(type, arguments)
	return new type (arglist(arguments))

/proc/_num2text(N, SigFig = 6)
	return num2text(N, SigFig)

/proc/_ohearers(Dist, Center = usr)
	return ohearers(Dist, Center)

/proc/_orange(Dist, Center = usr)
	return orange(Dist, Center)

/proc/_output(thing, msg, control)
	send_output(thing, msg, control)

/proc/_oview(Dist, Center = usr)
	return oview(Dist, Center)

/proc/_oviewers(Dist, Center = usr)
	return oviewers(Dist, Center)

/proc/_params2list(Params)
	return params2list(Params)

/proc/_pick(...)
	return pick(arglist(args))

/proc/_prob(P)
	return prob(P)

/proc/_rand(L = 0, H = 1)
	return rand(L, H)

/proc/_range(Dist, Center = usr)
	return range(Dist, Center)

/proc/_regex(pattern, flags)
	return regex(pattern, flags)

/proc/_REGEX_QUOTE(text)
	return REGEX_QUOTE(text)

/proc/_REGEX_QUOTE_REPLACEMENT(text)
	return REGEX_QUOTE_REPLACEMENT(text)

/proc/_replacetext(Haystack, Needle, Replacement, Start = 1,End = 0)
	return replacetext(Haystack, Needle, Replacement, Start, End)

/proc/_replacetextEx(Haystack, Needle, Replacement, Start = 1,End = 0)
	return replacetextEx(Haystack, Needle, Replacement, Start, End)

/proc/_rgb(R, G, B)
	return rgb(R, G, B)

/proc/_rgba(R, G, B, A)
	return rgb(R, G, B, A)

/proc/_roll(dice)
	return roll(dice)

/proc/_round(A, B = 1)
	return round(A, B)

/proc/_sin(X)
	return sin(X)

/proc/_step(Ref, Dir, Speed = 0)
	return step(Ref, Dir, Speed)


/proc/_list_add(var/list/L, ...)
	if (args.len < 2)
		return

	L += args.Copy(2)

/proc/_list_copy(var/list/L, var/Start = 1, var/End = 0)
	return L.Copy(Start, End)

/proc/_list_cut(var/list/L, var/Start = 1, var/End = 0)
	L.Cut(Start, End)

/proc/_list_find(var/list/L, var/Elem, var/Start = 1, var/End = 0)
	return L.Find(Elem, Start, End)

/proc/_list_insert(var/list/L, var/Index, var/Item)
	return L.Insert(Index, Item)

/proc/_list_join(var/list/L, var/Glue, var/Start = 0, var/End = 1)
	return L.Join(Glue, Start, End)

/proc/_list_remove(var/list/L, ...)
	if (args.len < 2)
		return

	L -= args.Copy(2)

/proc/_list_swap(var/list/L, var/Index1, var/Index2)
	L.Swap(Index1, Index2)