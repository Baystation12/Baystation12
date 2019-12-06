// These are designed to be used within /datum/movement_handler procs
// Do not attempt to use in /atom/movable/proc/DoMove, /atom/movable/proc/MayMove, etc.
#define IS_SELF(w) !IS_NOT_SELF(w)
#define IS_NOT_SELF(w) (w && w != host)
