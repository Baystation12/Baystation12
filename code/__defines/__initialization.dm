#define INITIALIZATION_INSSATOMS      0	//New should not call Initialize
#define INITIALIZATION_INSSATOMS_LATE 1	//New should not call Initialize; after the first pass is complete (handled differently)
#define INITIALIZATION_INNEW_MAPLOAD  2	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_REGULAR  3	//New should call Initialize(FALSE)

#define INITIALIZE_HINT_NORMAL   0  //Nothing happens
#define INITIALIZE_HINT_LATELOAD 1  //Call LateInitialize
#define INITIALIZE_HINT_QDEL     2  //Call qdel on the atom

#define ATOM_FLAG_INITIALIZED FLAG(0) // The atom has been initialized. Also see flags.dm

//type and all subtypes should always call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(atom_flags & ATOM_FLAG_INITIALIZED)) {\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, args);\
	}\
}

#define INIT_SKIP_QDELETED if (. == INITIALIZE_HINT_QDEL) {\
return;\
}

#define INIT_DISALLOW_TYPE(path) if (type == path) {\
. = INITIALIZE_HINT_QDEL;\
crash_with("disallowed type [type] created");\
return;\
}
