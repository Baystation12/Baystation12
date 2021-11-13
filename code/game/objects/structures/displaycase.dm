/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	alpha = 150
	health_max = 14

/obj/structure/displaycase/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in T)
		if(AM.simulated && !AM.anchored)
			AM.forceMove(src)
	update_icon()

/obj/structure/displaycase/examine(mob/user)
	. = ..()
	if(contents.len)
		to_chat(user, "Inside you see [english_list(contents)].")

/obj/structure/displaycase/ex_act(severity)
	switch(severity)
		if (1)
			kill_health()
		if (2)
			if (prob(50))
				damage_health(15, BRUTE)
		if (3)
			if (prob(50))
				damage_health(5, BRUTE)

/obj/structure/displaycase/bullet_act(var/obj/item/projectile/Proj)
	..()
	damage_health(Proj.get_structure_damage(), Proj.damage_type)

/obj/structure/displaycase/handle_death_change(new_death_state)
	if (new_death_state)
		set_density(FALSE)
		new /obj/item/material/shard(loc)
		for(var/atom/movable/AM in src)
			AM.dropInto(loc)
		playsound(src, "shatter", 70, 1)
		update_icon()

/obj/structure/displaycase/damage_health(damage, damage_type, skip_death_state_change)
	. = ..()
	if (!.)
		playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)

/obj/structure/displaycase/on_update_icon()
	if(!is_alive())
		icon_state = "glassboxb"
	else
		icon_state = "glassbox"
	underlays.Cut()
	for(var/atom/movable/AM in contents)
		underlays += AM.appearance

/obj/structure/displaycase/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	damage_health(W.force, W.damtype)
	..()

/obj/structure/displaycase/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(is_alive())
		to_chat(usr, text("<span class='warning'>You kick the display case.</span>"))
		visible_message("<span class='warning'>[usr] kicks the display case.</span>")
		damage_health(2, BRUTE)
