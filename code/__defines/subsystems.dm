// Subsystem runlevels

#define RUNLEVEL_INIT EMPTY_BITFIELD
#define RUNLEVEL_LOBBY FLAG(0)
#define RUNLEVEL_SETUP FLAG(1)
#define RUNLEVEL_GAME FLAG(2)
#define RUNLEVEL_POSTGAME FLAG(3)

#define RUNLEVELS_ALL (~EMPTY_BITFIELD)
#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
#define RUNLEVELS_GAME (RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
#define RUNLEVELS_PREGAME (RUNLEVEL_LOBBY | RUNLEVEL_SETUP)


// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.

#define SS_INIT_EARLY            180
#define SS_INIT_GARBAGE          170
#define SS_INIT_CHEMISTRY        160
#define SS_INIT_MATERIALS        150
#define SS_INIT_PLANTS           140
#define SS_INIT_ANTAGS           130
#define SS_INIT_CULTURE          120
#define SS_INIT_MISC             110
#define SS_INIT_SKYBOX           100
#define SS_INIT_JOBS             80
#define SS_INIT_CHAR_SETUP       70
#define SS_INIT_CIRCUIT          60
#define SS_INIT_GRAPH            50
#define SS_INIT_OPEN_SPACE       40
#define SS_INIT_ATOMS            30
#define SS_INIT_MACHINES         20
#define SS_INIT_ICON_UPDATE      10
#define SS_INIT_DEFAULT          0
#define SS_INIT_MAPPING          -5
#define SS_INIT_MISC_LATE       -10
#define SS_INIT_AIR             -20
#define SS_INIT_MISC_CODEX      -30
#define SS_INIT_ALARM           -40
#define SS_INIT_SHUTTLE         -50
#define SS_INIT_GOALS           -50
#define SS_INIT_LIGHTING        -60
#define SS_INIT_AMBIENT_LIGHT   -70
#define SS_INIT_ZCOPY           -80
#define SS_INIT_HOLOMAP         -90
#define SS_INIT_OVERLAYS        -100
#define SS_INIT_XENOARCH        -110
#define SS_INIT_TICKER          -120
#define SS_INIT_AI              -130
#define SS_INIT_AIFAST          -140
#define SS_INIT_CHAT            -150
#define SS_INIT_UNIT_TESTS      -160
