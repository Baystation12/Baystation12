//Interactions
/turf/simulated/wall/proc/toggle_open(mob/user)

	if(can_open == WALL_OPENING)
		return

	SSradiation.resistance_cache.Remove(src)

	if(density)
		can_open = WALL_OPENING
		//flick("[material.wall_icon_base]fwall_opening", src)
		sleep(15)
		set_density(0)
		set_opacity(0)
		blocks_air = ZONE_BLOCKED
		update_icon()
		update_air()
		set_light(0)
		src.blocks_air = 0
		set_opacity(0)
		for(var/turf/simulated/turf in loc)
			SSair.mark_for_update(turf)
	else
		can_open = WALL_OPENING
		//flick("[material.wall_icon_base]fwall_closing", src)
		set_density(1)
		set_opacity(1)
		blocks_air = AIR_BLOCKED
		update_icon()
		update_air()
		sleep(15)
		set_light(1, 0.4)
		src.blocks_air = 1
		set_opacity(1)
		for(var/turf/simulated/turf in loc)
			SSair.mark_for_update(turf)

	can_open = WALL_CAN_OPEN
	update_icon()

/turf/simulated/wall/proc/update_air()
	if(!SSair)
		return

	for(var/turf/simulated/turf in loc)
		update_thermal(turf)
		SSair.mark_for_update(turf)


/turf/simulated/wall/proc/update_thermal(turf/simulated/source)
	if(istype(source))
		if(density && opacity)
			source.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)



/turf/simulated/wall/proc/fail_smash(mob/user)
	to_chat(user, SPAN_DANGER("You smash against \the [src]!"))
	damage_health(rand(25, 75), DAMAGE_BRUTE)

/turf/simulated/wall/proc/success_smash(mob/user)
	to_chat(user, SPAN_DANGER("You smash through \the [src]!"))
	user.do_attack_animation(src)
	kill_health()

/turf/simulated/wall/proc/try_touch(mob/user, rotting)

	if(rotting)
		if(reinf_material)
			to_chat(user, SPAN_DANGER("\The [reinf_material.display_name] feels porous and crumbly."))
		else
			to_chat(user, SPAN_DANGER("\The [material.display_name] crumbles under your touch!"))
			kill_health()
			return 1

	if(!can_open)
		to_chat(user, SPAN_NOTICE("You push \the [src], but nothing happens."))
		playsound(src, hitsound, 25, 1)
	else
		toggle_open(user)
	return 0


/turf/simulated/wall/attack_hand(mob/user)
	radiate()
	var/rotting = (locate(/obj/overlay/wallrot) in src)
	if(iscarbon(user))
		var/mob/living/carbon/M = user
		switch(M.a_intent)
			if(I_HELP)
				return ..()
			if(I_DISARM, I_GRAB)
				try_touch(M, rotting)
			if(I_HURT)
				if(rotting && !reinf_material)
					M.visible_message(SPAN_DANGER("[M.name] punches \the [src] and it crumbles!"), SPAN_DANGER("You punch \the [src] and it crumbles!"))
					kill_health()
					playsound(src, pick(GLOB.punch_sound), 20)
					return TRUE
				return ..()
	else
		try_touch(user, rotting)

/turf/simulated/wall/attack_generic(mob/user, damage, attack_message, wallbreaker)

	radiate()
	if(!istype(user))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/rotting = (locate(/obj/overlay/wallrot) in src)
	if(!damage || !wallbreaker)
		try_touch(user, rotting)
		return

	if(rotting)
		return success_smash(user)

	if(reinf_material)
		if(damage >= max(material.hardness,reinf_material.hardness))
			success_smash(user)
			return
	else if(wallbreaker == 2 || damage >= material.hardness)
		success_smash(user)
		return
	fail_smash(user)

/turf/simulated/wall/use_tool(obj/item/W, mob/living/user, list/click_params)
	var/area/A = get_area(src)
	if (!A.can_modify_area())
		to_chat(user, SPAN_NOTICE("\The [src] deflects all attempts to interact with it!"))
		return TRUE

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(!construction_stage && try_graffiti(user, W))
		return TRUE

	if (!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return TRUE

	if(!istype(user.loc, /turf))
		return	..()

	radiate()
	var/heat_value = W.IsHeatSource()
	if (heat_value)
		burn(heat_value)

	if(locate(/obj/overlay/wallrot) in src)
		if(isWelder(W))
			var/obj/item/weldingtool/WT = W
			if(!WT.can_use(1, user))
				return TRUE

			WT.remove_fuel(1,user)
			to_chat(user, SPAN_NOTICE("You burn away the fungi with \the [WT]."))
			playsound(src, 'sound/items/Welder.ogg', 10, 1)
			for(var/obj/overlay/wallrot/WR in src)
				qdel(WR)
			return TRUE

		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, SPAN_NOTICE("\The [src] crumbles away under the force of your [W.name]."))
			kill_health()
			return TRUE

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(isWelder(W))
			var/obj/item/weldingtool/WT = W
			if(!WT.can_use(1, user))
				return TRUE
			WT.remove_fuel(1, user)
			thermitemelt(user)
			return TRUE

		else if(istype(W, /obj/item/gun/energy/plasmacutter))
			thermitemelt(user)
			return TRUE

		else if( istype(W, /obj/item/melee/energy/blade) )
			var/obj/item/melee/energy/blade/EB = W
			EB.spark_system.start()
			to_chat(user, SPAN_NOTICE("You slash \the [src] with \the [EB]; the thermite ignites!"))
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			thermitemelt(user)
			return TRUE

	var/turf/T = user.loc	//get user's location for delay checks

	var/damage = get_damage_value()
	if(damage && istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(WT.can_use(2, user))
			to_chat(user, SPAN_NOTICE("You start repairing the damage to [src]."))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5), src, DO_REPAIR_CONSTRUCT) && WT.remove_fuel(2, user))
				to_chat(user, SPAN_NOTICE("You finish repairing the damage to [src]."))
				restore_health(damage)
		return TRUE

	// Basic dismantling.
	if(isnull(construction_stage) || !reinf_material)
		var/cut_delay = 60 - material.cut_delay
		var/dismantle_verb
		var/dismantle_sound
		var/strict_timer_flags = FALSE

		if(istype(W,/obj/item/weldingtool))
			var/obj/item/weldingtool/WT = W
			if(!WT.can_use(1,user))
				return TRUE
			dismantle_verb = "cutting"
			dismantle_sound = 'sound/items/Welder.ogg'
			cut_delay *= 0.7
			WT.remove_fuel(1, user)

		else if(istype(W,/obj/item/melee/energy/blade) || istype(W,/obj/item/psychic_power/psiblade/master) || istype(W, /obj/item/gun/energy/plasmacutter))
			if(istype(W, /obj/item/gun/energy/plasmacutter))
				var/obj/item/gun/energy/plasmacutter/cutter = W
				if(!cutter.slice(user))
					return TRUE
			dismantle_sound = "sparks"
			dismantle_verb = "slicing"
			cut_delay *= 0.5
			strict_timer_flags = TRUE

		else if(istype(W,/obj/item/pickaxe))
			var/obj/item/pickaxe/P = W
			dismantle_verb = P.drill_verb
			dismantle_sound = P.drill_sound
			cut_delay -= P.digspeed
			strict_timer_flags = TRUE

		if(dismantle_verb)
			to_chat(user, SPAN_NOTICE("You begin [dismantle_verb] through the outer plating."))
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay < 0)
				cut_delay = 0

			if (do_after(user, cut_delay, src, strict_timer_flags ? DO_PUBLIC_UNIQUE : DO_REPAIR_CONSTRUCT))
				dismantle_wall()
				user.visible_message(SPAN_WARNING("\The [src] was torn open by [user]!"), SPAN_NOTICE("You remove the outer plating."))
			return TRUE

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)
				if(istype(W, /obj/item/psychic_power/psiblade/master/grand/paramount))
					to_chat(user, SPAN_NOTICE("You sink \the [W] into the wall and begin trying to rip out the support frame..."))
					playsound(src, 'sound/items/Welder.ogg', 100, 1)

					if(!do_after(user, 6 SECONDS, src, DO_PUBLIC_UNIQUE))
						return TRUE

					to_chat(user, SPAN_NOTICE("You tear through the wall's support system and plating!"))
					kill_health()
					user.visible_message(SPAN_WARNING("The wall was torn open by [user]!"))
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					return TRUE

				else if(isWirecutter(W))
					playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
					construction_stage = 5
					new /obj/item/stack/material/rods( src )
					to_chat(user, SPAN_NOTICE("You cut the outer grille."))
					update_icon()
					return TRUE
			if(5)
				if(isScrewdriver(W))
					to_chat(user, SPAN_NOTICE("You begin removing the support lines."))
					playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
					if(!do_after(user, (W.toolspeed * 4) SECONDS, src, DO_REPAIR_CONSTRUCT) || construction_stage != 5)
						return TRUE
					construction_stage = 4
					update_icon()
					to_chat(user, SPAN_NOTICE("You remove the support lines."))
					return TRUE
				else if( istype(W, /obj/item/stack/material/rods) )
					var/obj/item/stack/O = W
					if (!O.can_use(1))
						USE_FEEDBACK_STACK_NOT_ENOUGH(O, user, "to replace the outer grille.")
						return TRUE
					O.use(1)
					construction_stage = 6
					update_icon()
					to_chat(user, SPAN_NOTICE("You replace the outer grille."))
					return TRUE
			if(4)
				var/cut_cover
				var/strict_timer_flags = FALSE
				if(istype(W,/obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if(!WT.can_use(1, user))
						return TRUE
					WT.remove_fuel(1, user)
					cut_cover=1

				else if (istype(W, /obj/item/gun/energy/plasmacutter) || istype(W, /obj/item/psychic_power/psiblade/master))
					if(istype(W, /obj/item/gun/energy/plasmacutter))
						var/obj/item/gun/energy/plasmacutter/cutter = W
						if(!cutter.slice(user))
							return TRUE
					cut_cover = 1
					strict_timer_flags = TRUE

				if(cut_cover)
					to_chat(user, SPAN_NOTICE("You begin slicing through the metal cover."))
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user, (W.toolspeed * 6) SECONDS, src, strict_timer_flags ? DO_PUBLIC_UNIQUE : DO_REPAIR_CONSTRUCT) || construction_stage != 4)
						return TRUE
					construction_stage = 3
					update_icon()
					to_chat(user, SPAN_NOTICE("You press firmly on the cover, dislodging it."))
					return TRUE
			if(3)
				if(isCrowbar(W))
					to_chat(user, SPAN_NOTICE("You struggle to pry off the cover."))
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(!do_after(user, (W.toolspeed * 10) SECONDS, src, DO_REPAIR_CONSTRUCT) || construction_stage != 3)
						return TRUE
					construction_stage = 2
					update_icon()
					to_chat(user, SPAN_NOTICE("You pry off the cover."))
					return TRUE
			if(2)
				if(isWrench(W))
					to_chat(user, SPAN_NOTICE("You start loosening the anchoring bolts which secure the support rods to their frame."))
					playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
					if(!do_after(user, (W.toolspeed * 4) SECONDS, src, DO_REPAIR_CONSTRUCT) || construction_stage != 2)
						return TRUE
					construction_stage = 1
					update_icon()
					to_chat(user, SPAN_NOTICE("You remove the bolts anchoring the support rods."))
					return TRUE
			if(1)
				var/cut_cover
				var/strict_timer_flags = FALSE
				if(istype(W, /obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if(!WT.can_use(1, user))
						return TRUE
					WT.remove_fuel(1, user)
					cut_cover=1

				else if(istype(W, /obj/item/gun/energy/plasmacutter) || istype(W,/obj/item/psychic_power/psiblade/master))
					if(istype(W, /obj/item/gun/energy/plasmacutter))
						var/obj/item/gun/energy/plasmacutter/cutter = W
						if(!cutter.slice(user))
							return TRUE
					cut_cover = 1
					strict_timer_flags = TRUE

				if(cut_cover)
					to_chat(user, SPAN_NOTICE("You begin slicing through the support rods."))
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user, (W.toolspeed * 7) SECONDS, src, strict_timer_flags ? DO_PUBLIC_UNIQUE : DO_REPAIR_CONSTRUCT) || construction_stage != 1)
						return TRUE
					construction_stage = 0
					update_icon()
					new /obj/item/stack/material/rods(src)
					to_chat(user, SPAN_NOTICE("The support rods drop out as you cut them loose from the frame."))
					return TRUE
			if(0)
				if(isCrowbar(W))
					to_chat(user, SPAN_NOTICE("You struggle to pry off the outer sheath."))
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(!do_after(user, (W.toolspeed * 10) SECONDS, src, DO_REPAIR_CONSTRUCT) || !W || !T )
						return TRUE
					if(user.loc == T && user.get_active_hand() == W )
						to_chat(user, SPAN_NOTICE("You pry off the outer sheath."))
						dismantle_wall()
					return TRUE

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src)
		return TRUE

	return ..()
