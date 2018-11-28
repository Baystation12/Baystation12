
//nonfunctional
/obj/structure/grav_elevator_external
	name = "Covenant Gravity Elevator"
	desc = "A large anti-gravity lift for ferrying troops, supplies and vehicles between the ship and the surface."
	density = 0
	anchored = 1
	icon = 'grav128.dmi'
	icon_state = "elevator_animated"

//nonfunctional
/obj/structure/grav_elevator_internal
	name = "Gravity Elevator"
	desc = "A large anti-gravity lift for ferrying troops, supplies and vehicles down to the surface. Also anchors the vessel when in use."
	density = 0
	anchored = 1
	icon = 'grav128.dmi'
	icon_state = "lift_disabled"



//move up and down between zlevels
/obj/structure/grav_lift
	name = "Gravity lift pad"
	desc = "A mysterious antigravity field that enables vertical travel through the air."
	icon = 'grav32.dmi'
	icon_state = "lift"
	density = 0
	anchored = 1
	layer = 2.9
	var/list/base_turfs = list()
	var/list/connected_field = list()
	var/area/my_area

/obj/structure/grav_lift/New()
	. = ..()
	base_turfs = get_turfs()

/obj/structure/grav_lift/proc/get_turfs()
	. = list()
	for(var/turf/T in locs)
		. += T

/obj/structure/grav_lift/Initialize()
	. = ..()
	for(var/obj/structure/grav_lift/G in orange(1,src))
		if(G == src)
			continue
		if(G.my_area)
			my_area = G.my_area
	if(!my_area)
		my_area = new()
		my_area.name = "Gravity lift chute"
		my_area.has_gravity = 0

	for(var/turf/T in base_turfs)
		do
			my_area.contents.Add(T)
			var/obj/effect/antigrav/A = new(T)
			connected_field.Add(A)
			T = GetAbove(T)
		while(istype(T,/turf/simulated/open))

/obj/structure/grav_lift/Destroy()
	. = ..()
	for(var/A in connected_field)
		qdel(A)

/obj/structure/grav_lift/double
	icon = 'grav64.dmi'
	bound_width = 64
	bound_height = 64

/obj/structure/grav_lift/triple
	icon = 'grav96.dmi'
	bound_width = 96
	bound_height = 96

/obj/structure/grav_lift/quadruple
	icon = 'grav128.dmi'
	bound_width = 128
	bound_height = 128
	icon_state = "lift_animated"


/obj/effect/antigrav
	icon = 'grav32.dmi'
	icon_state = "updown"
