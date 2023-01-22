GLOBAL_DATUM(debug_real_globals, /debug_real_globals)


/debug_real_globals/get_variables()
	var/static/list/cache
	if (!cache)
		cache = list()
		var/list/hidden = VV_hidden()
		if (!hidden)
			return list()
		for (var/name in global.vars)
			if (name in hidden)
				continue
			cache |= name
		cache = sortList(cache)
	if (!usr || !check_rights(R_ADMIN|R_DEBUG, FALSE))
		var/static/list/locked
		if (!locked)
			locked = VV_locked()
		return (cache - locked)
	return cache.Copy()


/debug_real_globals/make_view_variables_variable_entry(name, value)
	return {"(<a href="?_src_=vars;datumedit=\ref[src];varnameedit=[name]">E</a>) "}


/debug_real_globals/set_variable_value(name, value)
	global.vars[name] = value


/debug_real_globals/get_variable_value(name)
	return global.vars[name]


/debug_real_globals/get_view_variables_options()
	return ""


/debug_real_globals/VV_locked()
	return vars


/debug_real_globals/VV_hidden()
	return list(
		"sqladdress",
		"sqldb",
		"sqlfdbkdb",
		"sqlfdbklogin",
		"sqlfdbkpass",
		"sqllogin",
		"sqlpass",
		"sqlport",
		"comms_password",
		"ban_comms_password",
		"login_export_addr",
		"admin_verbs_default",
		"admin_verbs_admin",
		"admin_verbs_ban",
		"admin_verbs_sounds",
		"admin_verbs_fun",
		"admin_verbs_spawn",
		"admin_verbs_server",
		"admin_verbs_debug",
		"admin_verbs_paranoid_debug",
		"admin_verbs_possess",
		"admin_verbs_permissions",
		"admin_verbs_rejuv",
		"admin_verbs_hideable",
		"admin_verbs_mod",
		"admin_datums",
		"admin_ranks",
		"alien_whitelist",
		"adminfaxes"
	)


/client/proc/debug_global_variables()
	set category = "Debug"
	set name = "View Real Globals"
	if (!GLOB.debug_real_globals)
		GLOB.debug_real_globals = new
	debug_variables(GLOB.debug_real_globals)
