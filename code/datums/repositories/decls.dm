GLOBAL_DATUM_INIT(decl_repository, /repository/decls, new)

/repository/decls
	var/list/fetched_decls
	var/list/fetched_decl_types
	var/list/fetched_decl_subtypes

/repository/decls/New()
	..()
	fetched_decls = list()
	fetched_decl_types = list()
	fetched_decl_subtypes = list()

/repository/decls/proc/get_decl(var/decl_type)
	. = fetched_decls[decl_type]
	if(!.)
		. = new decl_type()
		fetched_decls[decl_type] = .

/repository/decls/proc/get_decls_of_type(var/decl_prototype)
	. = fetched_decl_types[decl_prototype]
	if(!.)
		. = priv_get_decls(typesof(decl_prototype))
		fetched_decl_types[decl_prototype] = .

/repository/decls/proc/get_decls_of_subtype(var/decl_prototype)
	. = fetched_decl_subtypes[decl_prototype]
	if(!.)
		. = priv_get_decls(subtypesof(decl_prototype))
		fetched_decl_subtypes[decl_prototype] = .

/repository/decls/proc/priv_get_decls(var/list/decl_types)
	. = list()
	for(var/decl_type in decl_types)
		.[decl_type] =  get_decl(decl_type)

/decls/Destroy()
	crash_with("Prevented attempt to delete a decl instance: [log_info_line(src)]")
	return QDEL_HINT_LETMELIVE // Prevents Decl destruction
