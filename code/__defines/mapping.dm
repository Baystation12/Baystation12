// Maploader bounds indices
#define MAP_MINX 1
#define MAP_MINY 2
#define MAP_MINZ 3
#define MAP_MAXX 4
#define MAP_MAXY 5
#define MAP_MAXZ 6

// This utilizes an explicitly given type X instead of using src's type
//  in order for subtypes of src's type to detect each other
#define DELETE_IF_DUPLICATE_OF(X) \
	var/other_init = FALSE; \
	for(var/existing in get_turf(src)) { \
		if(existing == src) { \
			continue; \
		} \
		if(!istype(existing, X)) { \
			continue; \
		} \
		var/atom/A = existing; \
		if(A.atom_flags & ATOM_FLAG_INITIALIZED) {\
			other_init = TRUE; \
			break; \
		} \
	} \
	if(other_init) { \
		crash_with("Deleting duplicate of [log_info_line(src)]"); \
		return INITIALIZE_HINT_QDEL; \
	}
