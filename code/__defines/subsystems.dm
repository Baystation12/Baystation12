#define INITIALIZATION_INSSATOMS      0	//New should not call Initialize
#define INITIALIZATION_INSSATOMS_LATE 1	//New should not call Initialize; after the first pass is complete (handled differently)
#define INITIALIZATION_INNEW_MAPLOAD  2	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_REGULAR  3	//New should call Initialize(FALSE)

#define INITIALIZE_HINT_NORMAL   0  //Nothing happens
#define INITIALIZE_HINT_LATELOAD 1  //Call LateInitialize
#define INITIALIZE_HINT_QDEL     2  //Call qdel on the atom

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


// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.

#define SS_INIT_EARLY            18
#define SS_INIT_GARBAGE          17
#define SS_INIT_CHEMISTRY        16
#define SS_INIT_MATERIALS        15
#define SS_INIT_PLANTS           14
#define SS_INIT_ANTAGS           13
#define SS_INIT_CULTURE          12
#define SS_INIT_MISC             11
#define SS_INIT_SKYBOX           10
#define SS_INIT_MAPPING          9
#define SS_INIT_JOBS             8
#define SS_INIT_CHAR_SETUP       7
#define SS_INIT_CIRCUIT          6
#define SS_INIT_GRAPH            5
#define SS_INIT_OPEN_SPACE       4
#define SS_INIT_ATOMS            3
#define SS_INIT_MACHINES         2
#define SS_INIT_ICON_UPDATE      1
#define SS_INIT_DEFAULT          0
#define SS_INIT_AIR             -1
#define SS_INIT_MISC_LATE       -2
#define SS_INIT_MISC_CODEX      -3
#define SS_INIT_ALARM           -4
#define SS_INIT_SHUTTLE         -5
#define SS_INIT_GOALS           -5
#define SS_INIT_LIGHTING        -6
#define SS_INIT_ZCOPY           -7
#define SS_INIT_XENOARCH        -10
#define SS_INIT_BAY_LEGACY      -12
#define SS_INIT_TICKER          -20
#define SS_INIT_AI              -21
#define SS_INIT_AIFAST          -22
#define SS_INIT_CHAT            -90 // Should be lower to ensure chat remains smooth during init.
#define SS_INIT_UNIT_TESTS      -100

// SS runlevels

#define RUNLEVEL_INIT EMPTY_BITFIELD
#define RUNLEVEL_LOBBY FLAG(0)
#define RUNLEVEL_SETUP FLAG(1)
#define RUNLEVEL_GAME FLAG(2)
#define RUNLEVEL_POSTGAME FLAG(3)

#define RUNLEVELS_ALL (~EMPTY_BITFIELD)
#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
