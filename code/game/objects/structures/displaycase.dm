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
	if (severity < 3)
		var/shuffled_contents = shuffle(contents)
		for (var/atom/A as anything in shuffled_contents)
			A.ex_act(severity + 1)
	..()

/obj/structure/displaycase/bullet_act(obj/item/projectile/Proj)
	if (Proj.penetrating)
		var/distance = get_dist(Proj.starting, get_turf(loc))
		var/list/items = contents.Copy()
		while (items.len)
			var/atom/A = pick_n_take(items)
			if (isliving(A))
				Proj.attack_mob(A, distance)
			else
				A.bullet_act(Proj)
			Proj.penetrating -= 1
			if(!Proj.penetrating)
				break
	. = ..()

/obj/structure/displaycase/handle_death_change(new_death_state)
	if (new_death_state)
		set_density(FALSE)
		new /obj/item/material/shard(loc)
		for(var/atom/movable/AM in src)
			AM.dropInto(loc)
		playsound(src, "shatter", 70, 1)
		update_icon()

/obj/structure/displaycase/on_update_icon()
	if(!is_alive())
		icon_state = "glassboxb"
	else
		icon_state = "glassbox"
	underlays.Cut()
	for(var/atom/movable/AM in contents)
		underlays += AM.appearance

/obj/structure/displaycase/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(is_alive())
		to_chat(usr, text("<span class='warning'>You kick the display case.</span>"))
		visible_message("<span class='warning'>[usr] kicks the display case.</span>")
		damage_health(2, BRUTE)
