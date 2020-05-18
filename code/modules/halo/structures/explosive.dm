
/obj/structure/destructible/barrel
	name = "metal barrel"
	icon_state = "barrel"

/obj/structure/destructible/explosive
	name = "fuel barrel"
	icon_state = "barrel_fire"
	maxHealth = 1
	cover_rating = 50

/obj/structure/destructible/explosive/take_damage(var/amount)
	explosion(get_turf(src), 1, 1, 1, 1, 0)
	do_effect(get_turf(src))
	. = ..()

/obj/structure/destructible/explosive/proc/do_effect(var/turf/epicentre)
	new/obj/effect/explosion(epicentre)

/obj/structure/destructible/explosive/reactor_core
	name = "unstable reactor core"
	icon_state = "fuelcore_reactor"

/obj/structure/destructible/explosive/doom
	icon = 'code/modules/halo/structures/doombarrel.dmi'
	icon_state = "doombarrel"

/obj/structure/destructible/explosive/doom/do_effect(var/turf/epicentre)
	new /obj/effect/plasma_explosion/green(epicentre)

/obj/structure/destructible/explosive/plasma_battery
	name = "plasma battery"
	icon = 'code/modules/halo/covenant/structures_machines/plasma_battery.dmi'
	icon_state = "in_use"
	desc = "A portable power cell for plasma powered machinery and devices used by the Covenant."

/obj/structure/destructible/explosive/plasma_battery/do_effect(var/turf/epicentre)
	new /obj/effect/plasma_explosion(epicentre)
