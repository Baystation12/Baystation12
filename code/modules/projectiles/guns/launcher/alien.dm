/obj/item/weapon/gun/launcher/alien
	var/last_regen = 0
	var/ammo_gen_time = 100
	var/max_ammo = 3
	var/ammo = 3
	var/ammo_type
	var/ammo_name

/obj/item/weapon/gun/launcher/alien/New()
	..()
	processing_objects.Add(src)
	last_regen = world.time

/obj/item/weapon/gun/launcher/alien/Destroy()
	processing_objects.Remove(src)
	return ..()

/obj/item/weapon/gun/launcher/alien/process()
	if(ammo < max_ammo && world.time > last_regen + ammo_gen_time)
		ammo++
		last_regen = world.time
		update_icon()

/obj/item/weapon/gun/launcher/alien/examine(mob/user)
	..(user)
	to_chat(user, "It has [ammo] [ammo_name]\s remaining.")

/obj/item/weapon/gun/launcher/alien/consume_next_projectile()
	if(ammo < 1) return null
	if(ammo == max_ammo) //stops people from buffering a reload (gaining effectively +1 to the clip)
		last_regen = world.time
	ammo--
	return new ammo_type

/obj/item/weapon/gun/launcher/alien/special_check(user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species && H.species.get_bodytype(H) != SPECIES_VOX)
			to_chat(user, "<span class='warning'>\The [src] does not respond to you!</span>")
			return 0
	return ..()

//Vox pinning weapon.
/obj/item/weapon/gun/launcher/alien/spikethrower

	name = "spike thrower"
	desc = "A vicious alien projectile weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	w_class = ITEM_SIZE_LARGE
	ammo_name = "spike"
	ammo_type = /obj/item/weapon/spike
	release_force = 30
	icon = 'icons/obj/gun.dmi'
	icon_state = "spikethrower3"
	item_state = "spikethrower"
	fire_sound_text = "a strange noise"
	fire_sound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/gun/launcher/alien/spikethrower/update_icon()
	icon_state = "spikethrower[ammo]"