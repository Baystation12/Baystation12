/var/repository/decls/decls_repository = new()

/repository/decls
	var/list/fetched_decls
	var/list/fetched_decl_types
	var/list/fetched_decl_subtypes

/repository/decls/New()
	..()
	fetched_decls = list()
	fetched_decl_types = list()
	fetched_decl_subtypes = list()

/repository/decls/proc/decls_of_type(var/decl_prototype)
	. = fetched_decl_types[decl_prototype]
	if(!.)
		. = get_decls(typesof(decl_prototype))
		fetched_decl_types[decl_prototype] = .

/repository/decls/proc/decls_of_subtype(var/decl_prototype)
	. = fetched_decl_subtypes[decl_prototype]
	if(!.)
		. = get_decls(subtypesof(decl_prototype))
		fetched_decl_subtypes[decl_prototype] = .

/repository/decls/proc/get_decl(var/decl_type)
	. = fetched_decls[decl_type]
	if(!.)
		. = new decl_type()
		fetched_decls[decl_type] = .

/repository/decls/proc/get_decls(var/list/decl_types)
	. = list()
	for(var/decl_type in decl_types)
		. += get_decl(decl_type)
