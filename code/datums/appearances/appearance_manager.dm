var/decl/appearance_manager/appearance_manager = new()

/decl/appearance_manager
	var/list/appearance_handlers_

/decl/appearance_manager/New()
	..()
	appearance_handlers_ = list()
	for(var/entry in subtypesof(/decl/appearance_handler))
		appearance_handlers_[entry] += new entry()

/decl/appearance_manager/proc/get_appearance_hander(var/handler_type)
	return appearance_handlers_[handler_type]
