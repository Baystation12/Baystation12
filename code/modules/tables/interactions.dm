
/obj/structure/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,target))
	if (flipped == 1)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	return 0

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/table/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	if(flipped)
		cover = get_turf(src)
	else
		cover = get_step(loc, get_dir(from, loc))
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1

	var/chance = 20
	if(ismob(P.original) && get_turf(P.original) == cover)
		var/mob/M = P.original
		if (M.lying)
			chance += 20				//Lying down lets you catch less bullets
	if(flipped)
		if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
			chance += 30
		else
			return 1					//But only from one side

	if(prob(chance))
		return 0 //blocked
	return 1

/obj/structure/table/bullet_act(obj/item/projectile/P)
	if(!(P.damage_type == BRUTE || P.damage_type == BURN))
		return 0

	if(take_damage(P.damage/2))
		//prevent tables with 1 health left from stopping bullets outright
		return PROJECTILE_CONTINUE //the projectile destroyed the table, so it gets to keep going

	visible_message("<span class='warning'>\The [P] hits [src]!</span>")
	return 0

/obj/structure/table/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if (flipped==1)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1
	return 1


/obj/structure/table/MouseDrop_T(obj/O as obj, mob/user as mob)

	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return ..()
	if(isrobot(user))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return


/obj/structure/table/attackby(obj/item/W, mob/user, var/click_params)
	if (!W) return

	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if (istype(G.affecting, /mob/living))
			var/mob/living/M = G.affecting
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				user << "<span class='danger'>There's \a [occupied] in the way.</span>"
				return
			if (G.state >= GRAB_AGGRESSIVE)
				if(user.a_intent == I_HURT)
					var/blocked = M.run_armor_check("head", "melee")
					if (prob(30 * blocked_mult(blocked)))
						M.Weaken(5)
					M.apply_damage(8, BRUTE, "head", blocked)
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					if(material)
						playsound(loc, material.tableslam_noise, 50, 1)
					else
						playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
					var/list/L = take_damage(rand(1,5))
					// Shards. Extra damage, plus potentially the fact YOU LITERALLY HAVE A PIECE OF GLASS/METAL/WHATEVER IN YOUR FACE
					for(var/obj/item/weapon/material/shard/S in L)
						if(prob(50))
							M.visible_message("<span class='danger'>\The [S] slices [M]'s face messily!</span>",
							                   "<span class='danger'>\The [S] slices your face messily!</span>")
							M.apply_damage(10, BRUTE, "head", blocked)
							M.standard_weapon_hit_effects(S, G.assailant, 10, blocked, "head")
				else
					user << "<span class='danger'>You need a better grip to do that!</span>"
					return
			else
				G.affecting.loc = src.loc
				G.affecting.Weaken(5)
				visible_message("<span class='danger'>[G.assailant] puts [G.affecting] on \the [src].</span>")
			qdel(W)
			return

	// Handle dismantling or placing things on the table from here on.
	if(isrobot(user))
		return

	if(W.loc != user) // This should stop mounted modules ending up outside the module.
		return

	if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(src.loc, "sparks", 50, 1)
		user.visible_message("<span class='danger'>\The [src] was sliced apart by [user]!</span>")
		break_to_parts()
		return

	if(can_plate && !material)
		user << "<span class='warning'>There's nothing to put \the [W] on! Try adding plating to \the [src] first.</span>"
		return

	// Placing stuff on tables
	if(user.drop_from_inventory(W, src.loc))
		place_item(W, click_params)

	return

/obj/structure/table/proc/place_item(obj/item/W, var/click_params)
	var/list/click_data = params2list(click_params)
	//Center the icon where the user clicked.
	if(!click_data || !click_data["icon-x"] || !click_data["icon-y"])
		return

	//Food is special, apparently
	var/center_x = 16
	var/center_y = 16
	if(istype(W, /obj/item/weapon/reagent_containers/food))
		var/obj/item/weapon/reagent_containers/food/F = W
		if(F.center_of_mass.len)
			center_x = F.center_of_mass["x"]
			center_y = F.center_of_mass["y"]

	//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
	W.pixel_x = Clamp(text2num(click_data["icon-x"]) - center_x, -(world.icon_size/2), world.icon_size/2)
	W.pixel_y = Clamp(text2num(click_data["icon-y"]) - center_y, -(world.icon_size/2), world.icon_size/2)

/obj/structure/table/attack_tk() // no telehulk sorry
	return
