/obj/item/weapon/grenade/light
	name = "illumination grenade"
	desc = "A grenade designed to illuminate an area. Functional in any atmosphere."
	icon_state = "lightgrenade"
	item_state = "flashbang"

/obj/item/weapon/grenade/light/detonate()
	..()
	playsound(src, 'sound/effects/snap.ogg', 40, 1)
	visible_message("<span class='warning'>\The [src] detonates with a pop, leaving a bright lingering light!</span>")
	var/lifetime = rand(3 MINUTES, 5 MINUTES)
	var/light_colour = pick("#49f37c", "#fc0f29", "#599dff", "#fa7c0b", "#fef923")
	new /obj/effect/effect/smoke/illumination(src.loc, lifetime, range=12, power=1, color=light_colour)
	QDEL_NULL(src)