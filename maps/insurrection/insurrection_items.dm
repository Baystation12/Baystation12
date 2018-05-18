
#define LAUNCH_ABORTED -1
#define LAUNCH_UNDERWAY -2

/obj/effect/landmark/innie_bomb
	name = "innie bomb spawn"

/obj/payload/innie
	anchored = 0
	seconds_to_disarm = 30

/obj/payload/innie/proc/lockdown_bomb()
	anchored = 1
	new /obj/effect/bomblocation (loc)

/obj/payload/innie/verb/anchor_bomb()
	set name = "Anchor Bomb (unreversible)"
	set src in oview(1)

	if(!anchored && do_after(usr,8 SECONDS,src,1,1,,1))
		visible_message("<span class = 'danger'>[usr] engages the anchoring bolts on the [name]</span>")
		lockdown_bomb()


/obj/payload/innie/set_anchor()
	return

/obj/structure/payload/inactive
	name = "Inactive Nuclear Warhead"
	desc = "A dust covered nuclear warhead. Banging this thing around might be the last thing you do."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "MFDD"
	anchored = 0
	density = 1

/turf/simulated/hangar_door
	icon = 'maps/insurrection/hangar_door.dmi'
	icon_state = "pdoor1"

/obj/structure/hangar_door
	invisibility = 101
	icon = 'maps/insurrection/hangar_door.dmi'
	icon_state = "pdoor0"
	density = 0
	anchored = 1
	var/closed = 0 //This is immediately changed on init to be 1

/obj/structure/hangar_door/Initialize()
	. = ..()
	toggle_door()

/obj/structure/hangar_door/proc/door_animate(var/close = 0)
	invisibility = 0
	if(close)
		flick("pdoorc0",src)
	else
		flick("pdoorc1",src)
		invisibility = 101

/obj/structure/hangar_door/proc/toggle_door()
	var/turf/our_turf = loc
	if(closed)
		door_animate()
		if(istype(our_turf))
			our_turf.ChangeTurf(/turf/simulated/open)
		closed = 0
	else
		door_animate(1)
		if(istype(our_turf))
			our_turf.ChangeTurf(/turf/simulated/hangar_door)
		closed = 1

/obj/machinery/button/toggle/tranq_hangar
	name = "Hangar Toggle"
	desc = "Opens/closes the hangar doors."

/obj/machinery/button/toggle/tranq_hangar/proc/toggle_hangar_doors()
	for(var/obj/structure/hangar_door/d in world)
		if(d.z in GetConnectedZlevels(z))
			d.toggle_door()

/obj/machinery/button/toggle/tranq_hangar/proc/toggle_landing_points()
	for(var/obj/effect/landmark/dropship_land_point/insurrection_hangar/point in world)
		if(point.faction == initial(point.faction))
			point.faction = "Civilian"
		else
			point.faction = initial(point.faction)

/obj/machinery/button/toggle/tranq_hangar/activate(mob/living/user)
	if(operating || !istype(wifi_sender))
		return

	. = ..()
	toggle_hangar_doors()
	toggle_landing_points()

turf/simulated/floor/tranquility
	icon = 'code/modules/halo/icons/turfs/catwalks.dmi'
	name = "catwalk"
turf/simulated/floor/tranquility/catwalk1
	icon_state = "catwalk7"
turf/simulated/floor/tranquility/catwalk2
	icon_state = "catwalk10"
turf/simulated/floor/tranquility/catwalk3
	icon_state = "catwalk13"
turf/simulated/floor/tranquility/catwalk4
	icon_state = "catwalk14"
turf/simulated/floor/tranquility/catwalk5
	icon_state = "catwalk11"
turf/simulated/floor/tranquility/catwalk6
	icon_state = "catwalk5"
turf/simulated/floor/tranquility/catwalk7
	icon_state = "catwalk6"
turf/simulated/floor/tranquility/catwalk8
	icon_state = "catwalk15"
turf/simulated/floor/tranquility/catwalk9
	icon_state = "catwalk9"

#undef LAUNCH_ABORTED
#undef LAUNCH_UNDERWAY
