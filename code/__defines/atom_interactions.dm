// Macros to attempt chains of `use_*` procs independently of `resolve_attackby())`.
/// Attempt use procs in this order: use_tool > attackby
#define TRY_USE_TOOL(SRC, TOOL, USER, CLICKPARAM) (SRC.use_tool(TOOL, USER, CLICKPARAM) || SRC.attackby(TOOL, USER, CLICKPARAM))

/// Attempt use procs in this order: use_grab > use_tool > attackby
#define TRY_USE_GRAB(SRC, GRAB, USER, CLICKPARAM) (SRC.use_grab(GRAB, CLICKPARAM) || TRY_USE_TOOL(SRC, GRAB, USER, CLICKPARAM))

/// Attempt use procs in this order: use_weapon > use_tool > attackby
#define TRY_USE_WEAPON(SRC, WEAPON, USER, CLICKPARAM) (SRC.use_weapon(WEAPON, USER, CLICKPARAM) || TRY_USE_TOOL(SRC, WEAPON, USER, CLICKPARAM))
