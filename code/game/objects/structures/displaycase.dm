/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox1"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete the gun.
	var/health = 30
	var/occupied = 1
	var/destroyed = 0

/obj/structure/displaycase/ex_act(severity)
	switch(severity)
		if (1)
			new /obj/item/weapon/material/shard( src.loc )
			if (occupied)
				new /obj/item/weapon/gun/energy/captain( src.loc )
				occupied = 0
			qdel(src)
		if (2)
			if (prob(50))
				src.health -= 15
				src.healthcheck()
		if (3)
			if (prob(50))
				src.health -= 5
				src.healthcheck()


/obj/structure/displaycase/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()
	src.healthcheck()
	return

/obj/structure/displaycase/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.set_density(0)
			src.destroyed = 1
			new /obj/item/weapon/material/shard( src.loc )
			playsound(src, "shatter", 70, 1)
			update_icon()
	else
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
	return

/obj/structure/displaycase/update_icon()
	if(src.destroyed)
		src.icon_state = "glassboxb[src.occupied]"
	else
		src.icon_state = "glassbox[src.occupied]"
	return


/obj/structure/displaycase/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	src.health -= W.force
	src.healthcheck()
	..()
	return

/obj/structure/displaycase/attack_hand(mob/user as mob)
	if (src.destroyed && src.occupied)
		new /obj/item/weapon/gun/energy/captain( src.loc )
		to_chat(user, "<span class='notice'>You deactivate the hover field built into the case.</span>")
		src.occupied = 0
		src.add_fingerprint(user)
		update_icon()
		return
	else
		to_chat(usr, text("<span class='warning'>You kick the display case.</span>"))
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				to_chat(O, "<span class='warning'>[usr] kicks the display case.</span>")
		src.health -= 2
		healthcheck()
		return
