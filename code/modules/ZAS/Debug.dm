#ifdef ZASDBG

var/global/obj/effect/zasdbg/assigned/zasdbgovl_assigned = new
var/global/obj/effect/zasdbg/created/zasdbgovl_created = new
var/global/obj/effect/zasdbg/merged/zasdbgovl_merged = new
var/global/obj/effect/zasdbg/invalid_zone/zasdbgovl_invalid_zone = new
var/global/obj/effect/zasdbg/blocked/zasdbgovl_blocked = new
var/global/obj/effect/zasdbg/mark/zasdbgovl_mark = new

var/global/list/zasdbgovl_dirblock = list(
	"north" = new /obj/effect/zasdbg/air_blocked/north,
	"east" = new /obj/effect/zasdbg/air_blocked/east,
	"south" = new /obj/effect/zasdbg/air_blocked/south,
	"west" = new /obj/effect/zasdbg/air_blocked/west,
)
///Retrives the directional block indicator overlay for a given direction
#define ZAS_DIRECTIONAL_BLOCKER(d) (zasdbgovl_dirblock[dir2text(d)])

var/global/list/zasdbgovl_dirzoneblock = list(
	"north" = new /obj/effect/zasdbg/zone_blocked/north,
	"east" = new /obj/effect/zasdbg/zone_blocked/east,
	"south" = new /obj/effect/zasdbg/zone_blocked/south,
	"west" = new /obj/effect/zasdbg/zone_blocked/west,
)
///Retrieves the zone blocked debug overlay for a given direction
#define ZAS_ZONE_BLOCKER(d) (zasdbgovl_dirzoneblock[dir2text(d)])

/obj/effect/zasdbg
	icon = 'icons/Testing/Zone.dmi'
	invisibility = INVISIBILITY_OBSERVER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = FLY_LAYER

/obj/effect/zasdbg/assigned
	icon_state = "assigned"
/obj/effect/zasdbg/created
	icon_state = "created"
/obj/effect/zasdbg/merged
	icon_state = "merged"
/obj/effect/zasdbg/invalid_zone
	icon_state = "invalid"
/obj/effect/zasdbg/blocked
	icon_state = "fullblock"
/obj/effect/zasdbg/mark
	icon_state = "mark"

/obj/effect/zasdbg/zone_blocked
	icon_state = "zoneblock"

/obj/effect/zasdbg/zone_blocked/north
	dir = NORTH
/obj/effect/zasdbg/zone_blocked/east
	dir = EAST
/obj/effect/zasdbg/zone_blocked/south
	dir = SOUTH
/obj/effect/zasdbg/zone_blocked/west
	dir = WEST

/obj/effect/zasdbg/air_blocked
	icon_state = "block"

/obj/effect/zasdbg/air_blocked/north
	dir = NORTH
/obj/effect/zasdbg/air_blocked/east
	dir = EAST
/obj/effect/zasdbg/air_blocked/south
	dir = SOUTH
/obj/effect/zasdbg/air_blocked/west
	dir = WEST


/turf/var/tmp/obj/effect/zasdbg/dbg_img
/turf/proc/dbg(obj/effect/zasdbg/img)
	vis_contents -= dbg_img
	vis_contents += img
	dbg_img = img

/proc/soft_assert(thing,fail)
	if(!thing) message_admins(fail)

/datum/proc/zas_log(string)
	return

/turf/zas_log(string)
	to_chat(world, "[SPAN_DEBUG("ZAS:")] ([src.x], [src.y], [src.z]): [string]")

/connection/zas_log(string)
	to_chat(world, "[SPAN_DEBUG("ZAS:")] connection output: [string]")

/connection_edge/zas_log(string)
	to_chat(world, "[SPAN_DEBUG("ZAS:")] connection edge output: [string]")
#endif
