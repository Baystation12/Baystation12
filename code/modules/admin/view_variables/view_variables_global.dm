/var/decl/global_vars/global_vars_

/decl/global_vars/get_view_variables_header()
	return "<b>Global Variables</b>"

/decl/global_vars/get_view_variables_options()
	return "" // Ensuring changes to the base proc never affect us

/decl/global_vars/Destroy()
	return 1 // Denied

/decl/global_vars/get_variables()
	return _all_globals

/decl/global_vars/get_variable_value(varname)
	return readglobal(varname)

/decl/global_vars/set_variable_value(varname, value)
	writeglobal(varname, value)

/decl/global_vars/make_view_variables_variable_entry(varname, value)
	return "(<a href='?_src_=vars;datumedit=\ref[src];varnameedit=[varname]'>E</a>) "

/decl/global_vars/VVlocked()
	return list("vars")

/decl/global_vars/VVicon_edit_lock()
	return list()

/decl/global_vars/VVckey_edit()
	return list()

/client/proc/debug_global_variables()
	set category = "Debug"
	set name = "View Global Variables"

	if(!global_vars_)
		global_vars_ = new()
	debug_variables(global_vars_)
