GLOBAL_LIST_INIT(saved_vars, new)

#define ADD_SAVED_VAR(path, variable) \
	if (path not in GLOB.saved_vars) { \
		GLOB.saved_vars.Add(path, list()); \
	} \
	LAZYADD(GLOB.saved_vars[path], variable)