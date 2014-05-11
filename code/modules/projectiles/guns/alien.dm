//Vox pinning weapon.

//Ammo.
/obj/item/weapon/spike
	name = "alloy spike"
	desc = "It's about a foot of weird silver metal with a wicked point."
	sharp = 1
	throwforce = 5
	w_class = 2
	icon = 'icons/obj/weapons.dmi'
	icon_state = "metal-rod"
	item_state = "bolt"

//Launcher.

/obj/item/weapon/spikethrower

	name = "Vox spike thrower"
	desc = "A vicious alien projectile weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."

	var/last_regen = 0
	var/spike_gen_time = 100
	var/max_spikes = 3
	var/spikes = 3
	var/obj/item/weapon/spike/spike
	var/fire_force = 30

	//Going to make an effort to get this compatible with the threat targetting system.
	var/tmp/list/mob/living/target
	var/tmp/mob/living/last_moved_mob

	icon = 'icons/obj/gun.dmi'
	icon_state = "spikethrower3"
	item_state = "spikethrower"

/obj/item/weapon/spikethrower/New()
	..()
	processing_objects.Add(src)
	last_regen = world.time

/obj/item/weapon/spikethrower/Del()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/spikethrower/process()

	if(spikes < max_spikes && world.time > last_regen + spike_gen_time)
		spikes++
		last_regen = world.time
		update_icon()

/obj/item/weapon/spikethrower/examine()
	..()
	usr << "It has [spikes] [spikes == 1 ? "spike" : "spikes"] remaining."

/obj/item/weapon/spikethrower/update_icon()
	icon_state = "spikethrower[spikes]"

/obj/item/weapon/spikethrower/afterattack(atom/A as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)
	if(flag) return
	if(user && user.client && user.client.gun_mode && !(A in target))
		//TODO: Make this compatible with targetting (prolly have to actually make it a gun subtype, ugh.)
		//PreFire(A,user,params)
	else
		Fire(A,user,params)

/obj/item/weapon/spikethrower/attack(mob/living/M as mob, mob/living/user as mob, def_zone)

	if (M == user && user.zone_sel.selecting == "mouth")
		M.visible_message("\red [user] attempts without success to fit [src] into their mouth.")
		return

	if (spikes > 0)
		if(user.a_intent == "hurt")
			user.visible_message("\red <b> \The [user] fires \the [src] point blank at [M]!</b>")
			Fire(M,user)
			return
		else if(target && M in target)
			Fire(M,user)
			return
	else
		return ..()

/obj/item/weapon/spikethrower/proc/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)

	add_fingerprint(user)

	var/turf/curloc = get_turf(user)
	var/turf/targloc = get_turf(target)
	if (!istype(targloc) || !istype(curloc))
		return

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species && H.species.name != "Vox")
			user << "\red The weapon does not respond to you!"
			return
	else
		user << "\red The weapon does not respond to you!"
		return

	if(spikes <= 0)
		user << "\red The weapon has nothing to fire!"
		return

	if(!spike)
		spike = new(src) //Create a spike.
		spike.add_fingerprint(user)
		spikes--

	user.visible_message("\red [user] fires [src]!", "\red You fire [src]!")
	spike.loc = get_turf(src)
	spike.throw_at(target,10,fire_force)
	spike = null
	update_icon()