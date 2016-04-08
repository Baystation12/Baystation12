var/decl/appearance_manager/appearance_manager = new()

/decl/appearance_manager
	var/list/appearance_handlers

/decl/appearance_manager/New()
	..()
	appearance_handlers = list()
	for(var/entry in subtypesof(/decl/appearance_handler))
		appearance_handlers += new entry()
