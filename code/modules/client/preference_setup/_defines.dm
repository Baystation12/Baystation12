#define EQUIP_PREVIEW_LOADOUT 1
#define EQUIP_PREVIEW_JOB 2
#define EQUIP_PREVIEW_ALL (EQUIP_PREVIEW_LOADOUT|EQUIP_PREVIEW_JOB)

#define SETUP_SUBTYPE_DECLS_BY_NAME(decl_prototype, decls_by_name) \
if(!decls_by_name);\
{\
	decls_by_name = list();\
	var/decls_by_type = decls_repository.get_decls_of_subtype(decl_prototype);\
	for(var/decl_type in decls_by_type) \
	{\
		var##decl_prototype/decl_instance = decls_by_type[decl_type];\
		ADD_SORTED(decls_by_name, decl_instance.name, /proc/cmp_text_asc);\
		decls_by_name[decl_instance.name] = decl_instance;\
	}\
}
