//Interactions
/turf/simulated/wall/proc/toggle_open(var/mob/user)

	if(can_open == WALL_OPENING)
		return

	SSradiation.resistance_cache.Remove(src)

	if(density)
		can_open = WALL_OPENING
		//flick("[material.icon_base]fwall_opening", src)
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
		//flick("[material.icon_base]fwall_closing", src)
		set_density(1)
		set_opacity(1)
		blocks_air = AIR_BLOCKED
		update_icon()
		update_air()
		sleep(15)
		set_light(0.4, 0.1, 1)
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


/turf/simulated/wall/proc/update_thermal(var/turf/simulated/source)
	if(istype(source))
		if(density && opacity)
			source.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)



/turf/simulated/wall/proc/fail_smash(var/mob/user)
	to_chat(user, "<span class='danger'>You smash against \the [src]!</span>")
	damage_health(rand(25, 75), DAMAGE_BRUTE)

/turf/simulated/wall/proc/success_smash(var/mob/user)
	to_chat(user, "<span class='danger'>You smash through \the [src]!</span>")
	user.do_attack_animation(src)
	kill_health()

/turf/simulated/wall/proc/try_touch(var/mob/user, var/rotting)

	if(rotting)
		if(reinf_material)
			to_chat(user, "<span class='danger'>\The [reinf_material.display_name] feels porous and crumbly.</span>")
		else
			to_chat(user, "<span class='danger'>\The [material.display_name] crumbles under your touch!</span>")
			kill_health()
			return 1

	if(!can_open)
		to_chat(user, "<span class='notice'>You push \the [src], but nothing happens.</span>")
		playsound(src, hitsound, 25, 1)
	else
		toggle_open(user)
	return 0


/turf/simulated/wall/attack_hand(var/mob/user)

	radiate()
	add_fingerprint(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if (MUTATION_HULK in user.mutations)
		if (rotting || !prob(material.hardness))
			success_smash(user)
		else
			fail_smash(user)
			return 1

	if(iscarbon(user))
		var/mob/living/carbon/M = user
		switch(M.a_intent)
			if(I_HELP)
				return
			if(I_DISARM, I_GRAB)
				try_touch(M, rotting)
			if(I_HURT)
				var/obj/item/organ/external/organ_hand = M.organs_by_name[M.hand ? BP_L_HAND : BP_R_HAND]
				if (!(organ_hand?.is_usable()))
					to_chat(user, SPAN_WARNING("You can't use that hand."))
					return
				if(rotting && !reinf_material)
					M.visible_message(SPAN_DANGER("[M.name] punches \the [src] and it crumbles!"), SPAN_DANGER("You punch \the [src] and it crumbles!"))
					kill_health()
					playsound(src, pick(GLOB.punch_sound), 20)
				if (MUTATION_FERAL in user.mutations)
					M.visible_message(SPAN_DANGER("[M.name] slams into \the [src]!"), SPAN_DANGER("You slam into \the [src]!"))
					playsound(src, pick(GLOB.punch_sound), 45)
					damage_health(5, DAMAGE_BRUTE)
					user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*2) //Additional cooldown
					attack_animation(user)
				else
					M.visible_message(SPAN_DANGER("[M.name] punches \the [src]!"), SPAN_DANGER("You punch \the [src]!"))
					M.apply_damage(3, DAMAGE_BRUTE, M.hand ? BP_L_HAND : BP_R_HAND)
					playsound(src, pick(GLOB.punch_sound), 40)

	else
		try_touch(user, rotting)

/turf/simulated/wall/attack_generic(var/mob/user, var/damage, var/attack_message, var/wallbreaker)

	radiate()
	if(!istype(user))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if(!damage || !wallbreaker)
		try_touch(user, rotting)
		return

	if(rotting)
		return success_smash(user)

	if(reinf_material)
		if(damage >= max(material.hardness,reinf_material.hardness))
			return success_smash(user)
	else if(wallbreaker == 2 || damage >= material.hardness)
		return success_smash(user)
	return fail_smash(user)

/turf/simulated/wall/attackby(var/obj/item/W, var/mob/user)

	var/area/A = get_area(src)
	if (!A.can_modify_area())
		to_chat(user, SPAN_NOTICE("\The [src] deflects all attempts to interact with it!"))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(!construction_stage && try_graffiti(user, W))
		return

	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	//get the user's location
	if(!istype(user.loc, /turf))	return	//can't do this stuff whilst inside objects and such

	if(W)
		radiate()
		if(is_hot(W))
			burn(is_hot(W))

	if(locate(/obj/effect/overlay/wallrot) in src)
		if(isWelder(W))
			var/obj/item/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				to_chat(user, "<span class='notice'>You burn away the fungi with \the [WT].</span>")
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, "<span class='notice'>\The [src] crumbles away under the force of your [W.name].</span>")
			kill_health()
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(isWelder(W))
			var/obj/item/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/gun/energy/plasmacutter))
			thermitemelt(user)
			return

		else if( istype(W, /obj/item/melee/energy/blade) )
			var/obj/item/melee/energy/blade/EB = W

			EB.spark_system.start()
			to_chat(user, "<span class='notice'>You slash \the [src] with \the [EB]; the thermite ignites!</span>")
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

			thermitemelt(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	var/damage = get_damage_value()
	if(damage && istype(W, /obj/item/weldingtool))

		var/obj/item/weldingtool/WT = W

		if(WT.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5), src, DO_PUBLIC_UNIQUE) && WT && WT.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
				restore_health(damage)
		return

	// Basic dismantling.
	if(isnull(construction_stage) || !reinf_material)

		var/cut_delay = 60 - material.cut_delay
		var/dismantle_verb
		var/dismantle_sound

		if(istype(W,/obj/item/weldingtool))
			var/obj/item/weldingtool/WT = W
			if(!WT.remove_fuel(0,user))
				return
			dismantle_verb = "cutting"
			dismantle_sound = 'sound/items/Welder.ogg'
			cut_delay *= 0.7
		else if(istype(W,/obj/item/melee/energy/blade) || istype(W,/obj/item/psychic_power/psiblade/master) || istype(W, /obj/item/gun/energy/plasmacutter))
			if(istype(W, /obj/item/gun/energy/plasmacutter))
				var/obj/item/gun/energy/plasmacutter/cutter = W
				if(!cutter.slice(user))
					return
			dismantle_sound = "sparks"
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else if(istype(W,/obj/item/pickaxe))
			var/obj/item/pickaxe/P = W
			dismantle_verb = P.drill_verb
			dismantle_sound = P.drill_sound
			cut_delay -= P.digspeed

		if(dismantle_verb)

			to_chat(user, SPAN_NOTICE("You begin [dismantle_verb] through the outer plating."))
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay < 0)
				cut_delay = 0

			if (do_after(user, cut_delay, src, DO_PUBLIC_UNIQUE))
				dismantle_wall()
				user.visible_message(SPAN_WARNING("\The [src] was torn open by [user]!"), SPAN_NOTICE("You remove the outer plating."))
				return
			else
				return

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)

				if(istype(W, /obj/item/psychic_power/psiblade/master/grand/paramount))

					to_chat(user, "<span class='notice'>You sink \the [W] into the wall and begin trying to rip out the support frame...</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)

					if(!do_after(user, 6 SECONDS, src, DO_PUBLIC_UNIQUE))
						return

					to_chat(user, "<span class='notice'>You tear through the wall's support system and plating!</span>")
					kill_health()
					user.visible_message("<span class='warning'>The wall was torn open by [user]!</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)

				else if(isWirecutter(W))

					playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
					construction_stage = 5
					new /obj/item/stack/material/rods( src )
					to_chat(user, "<span class='notice'>You cut the outer grille.</span>")
					update_icon()
					return
			if(5)
				if(isScrewdriver(W))
					to_chat(user, "<span class='notice'>You begin removing the support lines.</span>")
					playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
					if(!do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE) || construction_stage != 5)
						return
					construction_stage = 4
					update_icon()
					to_chat(user, "<span class='notice'>You remove the support lines.</span>")
					return
				else if( istype(W, /obj/item/stack/material/rods) )
					var/obj/item/stack/O = W
					if(O.use(1))
						construction_stage = 6
						update_icon()
						to_chat(user, "<span class='notice'>You replace the outer grille.</span>")
						return
			if(4)
				var/cut_cover
				if(istype(W,/obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if(WT.remove_fuel(0,user))
						cut_cover=1
					else
						return
				else if (istype(W, /obj/item/gun/energy/plasmacutter) || istype(W, /obj/item/psychic_power/psiblade/master))
					if(istype(W, /obj/item/gun/energy/plasmacutter))
						var/obj/item/gun/energy/plasmacutter/cutter = W
						if(!cutter.slice(user))
							return
					cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the metal cover.</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user, 6 SECONDS, src, DO_PUBLIC_UNIQUE) || construction_stage != 4)
						return
					construction_stage = 3
					update_icon()
					to_chat(user, "<span class='notice'>You press firmly on the cover, dislodging it.</span>")
					return
			if(3)
				if(isCrowbar(W))
					to_chat(user, "<span class='notice'>You struggle to pry off the cover.</span>")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(!do_after(user, 10 SECONDS, src, DO_PUBLIC_UNIQUE) || construction_stage != 3)
						return
					construction_stage = 2
					update_icon()
					to_chat(user, "<span class='notice'>You pry off the cover.</span>")
					return
			if(2)
				if(isWrench(W))
					to_chat(user, "<span class='notice'>You start loosening the anchoring bolts which secure the support rods to their frame.</span>")
					playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
					if(!do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE) || construction_stage != 2)
						return
					construction_stage = 1
					update_icon()
					to_chat(user, "<span class='notice'>You remove the bolts anchoring the support rods.</span>")
					return
			if(1)
				var/cut_cover
				if(istype(W, /obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if( WT.remove_fuel(0,user) )
						cut_cover=1
					else
						return
				else if(istype(W, /obj/item/gun/energy/plasmacutter) || istype(W,/obj/item/psychic_power/psiblade/master))
					if(istype(W, /obj/item/gun/energy/plasmacutter))
						var/obj/item/gun/energy/plasmacutter/cutter = W
						if(!cutter.slice(user))
							return
					cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the support rods.</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user, 7 SECONDS, src, DO_PUBLIC_UNIQUE) || construction_stage != 1)
						return
					construction_stage = 0
					update_icon()
					new /obj/item/stack/material/rods(src)
					to_chat(user, "<span class='notice'>The support rods drop out as you cut them loose from the frame.</span>")
					return
			if(0)
				if(isCrowbar(W))
					to_chat(user, "<span class='notice'>You struggle to pry off the outer sheath.</span>")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(!do_after(user, 10 SECONDS, src, DO_PUBLIC_UNIQUE) || !W || !T )	return
					if(user.loc == T && user.get_active_hand() == W )
						to_chat(user, "<span class='notice'>You pry off the outer sheath.</span>")
						dismantle_wall()
					return

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src)
		return

	else if(!istype(W,/obj/item/rcd) && !istype(W, /obj/item/reagent_containers))
		if(!W.force)
			return attack_hand(user)

		if (!can_damage_health(W.force, W.damtype))
			playsound(src, hitsound, 25, 1)
			user.visible_message(
				SPAN_WARNING("\The [user] attacks \the [src] with \the [W], but it bounces off!"),
				SPAN_WARNING("You attack \the [src] with \the [W], but it bounces off! You need something stronger."),
				SPAN_WARNING("You hear the sound of something hitting a wall.")
			)
			return
		playsound(src, hitsound, 50, 1)
		user.visible_message(
			SPAN_DANGER("\The [user] attacks \the [src] with \the [W]!"),
			SPAN_WARNING("You attack \the [src] with \the [W]!"),
			SPAN_WARNING("You hear the sound of something hitting a wall.")
		)
		damage_health(W.force, W.damtype)
		return
