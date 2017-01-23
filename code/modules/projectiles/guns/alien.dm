//Vox pinning weapon.
/obj/item/weapon/gun/launcher/spikethrower

	name = "spike thrower"
	desc = "A vicious alien projectile weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	w_class = ITEM_SIZE_LARGE
	var/last_regen = 0
	var/spike_gen_time = 100
	var/max_spikes = 3
	var/spikes = 3
	release_force = 30
	icon = 'icons/obj/gun.dmi'
	icon_state = "spikethrower3"
	item_state = "spikethrower"
	fire_sound_text = "a strange noise"
	fire_sound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/gun/launcher/spikethrower/New()
	..()
	processing_objects.Add(src)
	last_regen = world.time

/obj/item/weapon/gun/launcher/spikethrower/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/gun/launcher/spikethrower/process()
	if(spikes < max_spikes && world.time > last_regen + spike_gen_time)
		spikes++
		last_regen = world.time
		update_icon()

/obj/item/weapon/gun/launcher/spikethrower/examine(mob/user)
	. = ..(user)
	to_chat(user, "It has [spikes] spike\s remaining.")

/obj/item/weapon/gun/launcher/spikethrower/update_icon()
	icon_state = "spikethrower[spikes]"

/obj/item/weapon/gun/launcher/spikethrower/special_check(user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species && H.species.get_bodytype(H) != "Vox")
			to_chat(user, "<span class='warning'>\The [src] does not respond to you!</span>")
			return 0
	return ..()

/obj/item/weapon/gun/launcher/spikethrower/update_release_force()
	return

/obj/item/weapon/gun/launcher/spikethrower/consume_next_projectile()
	if(spikes < 1) return null
	spikes--
	return new /obj/item/weapon/spike(src)
