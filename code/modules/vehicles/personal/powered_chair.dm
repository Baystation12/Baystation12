/obj/vehicle/personal/powered_chair
	name = "powered chair"
	desc = "An electrically powered mobility chair. This one has the branding and logo of Vey-Med."
	icon_state = "powered_chair"

	health = 100
	maxhealth = 100

	locked = FALSE
	move_delay = 1.4
	powered = TRUE


/obj/vehicle/personal/powered_chair/New()
	..()
	cell = new /obj/item/weapon/cell/high(src)
	var/image/I = new(icon = 'icons/obj/vehicles.dmi', icon_state = "powered_chair_overlay")
	I.plane = plane
	I.layer = layer
	overlays += I
	turn_off()


/obj/vehicle/personal/powered_chair/Move(turf/destination)
	if (on && istype(destination, /turf/space))
		return FALSE

	. = ..()


/obj/vehicle/personal/powered_chair/bullet_act(obj/item/projectile/P, def_zone)
	if (buckled_mob && prob(50))
		buckled_mob.bullet_act(P)
		return

	..()
