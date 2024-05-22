GLOBAL_DATUM_INIT(debug_real_globals, /datum/debug_real_globals, new)


/datum/debug_real_globals
	var/static/atom/movable/clickable_stat/__stat_line
	var/static/list/global_names


/datum/debug_real_globals/New()
	global_names = list()
	var/list/hidden = VV_hidden()
	for (var/name in global.vars)
		if (name in hidden)
			continue
		ADD_SORTED(global_names, name, GLOBAL_PROC_REF(cmp_text_asc))


/datum/debug_real_globals/proc/UpdateStat()
	if (!__stat_line)
		__stat_line = new (null, src)
		__stat_line.name = "Edit"
	stat("Real Globals", __stat_line)


/datum/debug_real_globals/get_variables()
	return global_names.Copy()


/datum/debug_real_globals/make_view_variables_variable_entry(name, value)
	return {"(<a href="?_src_=vars;datumedit=\ref[src];varnameedit=[name]">E</a>) "}


/datum/debug_real_globals/set_variable_value(name, value)
	if (name in global_names)
		global.vars[name] = value


/datum/debug_real_globals/get_variable_value(name)
	if (name in global_names)
		return global.vars[name]


/datum/debug_real_globals/get_view_variables_options()
	return ""


/datum/debug_real_globals/may_not_edit_var(user, name, silent)
	. = ..(user, name, TRUE)
	if (. == 2 && (name in global_names))
		return FALSE


/datum/debug_real_globals/VV_hidden()
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
