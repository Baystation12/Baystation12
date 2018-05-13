/obj/item/weapon/grenade/light
	name = "illumination grenade"
	desc = "A grenade designed to illuminate an area without the use of a flame or electronics, regardless of the atmosphere."
	icon_state = "lightgrenade"
	item_state = "flashbang"
	det_time = 20

/obj/item/weapon/grenade/light/detonate()
	..()
	var/lifetime = rand(2 MINUTES, 4 MINUTES)
	var/light_colour = pick("#49f37c", "#fc0f29", "#599dff", "#fa7c0b", "#fef923")

	playsound(src, 'sound/effects/snap.ogg', 80, 1)
	audible_message("<span class='warning'>\The [src] detonates with a sharp crack!</span>")
	set_light(1, 1, 12, 2, light_colour)
	QDEL_IN(src, lifetime)