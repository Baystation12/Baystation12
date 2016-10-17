/var/repository/decls/decls_repository = new()

/repository/decls
	var/list/fetched_decls

/repository/decls/New()
	..()
	fetched_decls = list()

/repository/decls/proc/get_decl(var/decl_type)
	. = fetched_decls[decl_type]
	if(!.)
		. = new decl_type()
		fetched_decls[decl_type] = .
