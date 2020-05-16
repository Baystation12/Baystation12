
/obj/structure/destructible/barrel
	name = "metal barrel"
	icon_state = "barrel"

/obj/structure/destructible/explosive
	name = "fuel barrel"
	icon_state = "barrel_fire"
	maxHealth = 1

/obj/structure/destructible/explosive/take_damage(var/amount)
	. = ..()
	explosion(get_turf(src), 1, 3, 5, 5, 0)

/obj/structure/destructible/explosive/reactor_core
	name = "unstable reactor core"
	icon_state = "fuelcore_reactor"
