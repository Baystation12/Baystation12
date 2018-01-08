#define ZONE_BLOCKED 2
#define AIR_BLOCKED 1
//Interactions
/turf/simulated/wall/proc/toggle_open(var/mob/user)

	if(can_open == WALL_OPENING)
		return

	radiation_repository.resistance_cache.Remove(src)

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
		set_light(1)
		src.blocks_air = 1
		set_opacity(1)
		for(var/turf/simulated/turf in loc)
			SSair.mark_for_update(turf)

	can_open = WALL_CAN_OPEN
	update_icon()

#undef ZONE_BLOCKED
#undef AIR_BLOCKED

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
	take_damage(rand(25,75))

/turf/simulated/wall/proc/success_smash(var/mob/user)
	to_chat(user, "<span class='danger'>You smash through \the [src]!</span>")
	user.do_attack_animation(src)
	spawn(1)
		dismantle_wall(1)

/turf/simulated/wall/proc/try_touch(var/mob/user, var/rotting)

	if(rotting)
		if(reinf_material)
			to_chat(user, "<span class='danger'>\The [reinf_material.display_name] feels porous and crumbly.</span>")
		else
			to_chat(user, "<span class='danger'>\The [material.display_name] crumbles under your touch!</span>")
			dismantle_wall()
			return 1

	if(..()) return 1

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
	if (HULK in user.mutations)
		if (rotting || !prob(material.hardness))
			success_smash(user)
		else
			fail_smash(user)
			return 1

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

/turf/simulated/wall/attackby(obj/item/weapon/W as obj, mob/user as mob)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
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
			var/obj/item/weapon/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				to_chat(user, "<span class='notice'>You burn away the fungi with \the [WT].</span>")
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, "<span class='notice'>\The [src] crumbles away under the force of your [W.name].</span>")
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(isWelder(W))
			var/obj/item/weapon/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
			thermitemelt(user)
			return

		else if( istype(W, /obj/item/weapon/melee/energy/blade) )
			var/obj/item/weapon/melee/energy/blade/EB = W

			EB.spark_system.start()
			to_chat(user, "<span class='notice'>You slash \the [src] with \the [EB]; the thermite ignites!</span>")
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

			thermitemelt(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	if(damage && istype(W, /obj/item/weapon/weldingtool))

		var/obj/item/weapon/weldingtool/WT = W

		if(!WT.isOn())
			return

		if(WT.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5), src) && WT && WT.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
				take_damage(-damage)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
		return

	// Basic dismantling.
	if(isnull(construction_stage) || !reinf_material)

		var/cut_delay = 60 - material.cut_delay
		var/dismantle_verb
		var/dismantle_sound

		if(istype(W,/obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(!WT.isOn())
				return
			if(!WT.remove_fuel(0,user))
				to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
				return
			dismantle_verb = "cutting"
			dismantle_sound = 'sound/items/Welder.ogg'
			cut_delay *= 0.7
		else if(istype(W,/obj/item/weapon/melee/energy/blade))
			dismantle_sound = "sparks"
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else if(istype(W,/obj/item/weapon/pickaxe))
			var/obj/item/weapon/pickaxe/P = W
			dismantle_verb = P.drill_verb
			dismantle_sound = P.drill_sound
			cut_delay -= P.digspeed

		if(dismantle_verb)

			to_chat(user, "<span class='notice'>You begin [dismantle_verb] through the outer plating.</span>")
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay<0)
				cut_delay = 0

			if(!do_after(user,cut_delay,src))
				return

			to_chat(user, "<span class='notice'>You remove the outer plating.</span>")
			dismantle_wall()
			user.visible_message("<span class='warning'>\The [src] was torn open by [user]!</span>")
			return

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)
				if(isWirecutter(W))
					playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
					construction_stage = 5
					new /obj/item/stack/rods( src )
					to_chat(user, "<span class='notice'>You cut the outer grille.</span>")
					update_icon()
					return
			if(5)
				if(isScrewdriver(W))
					to_chat(user, "<span class='notice'>You begin removing the support lines.</span>")
					playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
					if(!do_after(user,40,src) || !istype(src, /turf/simulated/wall) || construction_stage != 5)
						return
					construction_stage = 4
					update_icon()
					to_chat(user, "<span class='notice'>You remove the support lines.</span>")
					return
				else if( istype(W, /obj/item/stack/rods) )
					var/obj/item/stack/O = W
					if(O.get_amount()>0)
						O.use(1)
						construction_stage = 6
						update_icon()
						to_chat(user, "<span class='notice'>You replace the outer grille.</span>")
						return
			if(4)
				var/cut_cover
				if(istype(W,/obj/item/weapon/weldingtool))
					var/obj/item/weapon/weldingtool/WT = W
					if(!WT.isOn())
						return
					if(WT.remove_fuel(0,user))
						cut_cover=1
					else
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
				else if (istype(W, /obj/item/weapon/pickaxe/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the metal cover.</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user, 60, src) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 3
					update_icon()
					to_chat(user, "<span class='notice'>You press firmly on the cover, dislodging it.</span>")
					return
			if(3)
				if(isCrowbar(W))
					to_chat(user, "<span class='notice'>You struggle to pry off the cover.</span>")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(!do_after(user,100,src) || !istype(src, /turf/simulated/wall) || construction_stage != 3)
						return
					construction_stage = 2
					update_icon()
					to_chat(user, "<span class='notice'>You pry off the cover.</span>")
					return
			if(2)
				if(isWrench(W))
					to_chat(user, "<span class='notice'>You start loosening the anchoring bolts which secure the support rods to their frame.</span>")
					playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
					if(!do_after(user,40,src) || !istype(src, /turf/simulated/wall) || construction_stage != 2)
						return
					construction_stage = 1
					update_icon()
					to_chat(user, "<span class='notice'>You remove the bolts anchoring the support rods.</span>")
					return
			if(1)
				var/cut_cover
				if(istype(W, /obj/item/weapon/weldingtool))
					var/obj/item/weapon/weldingtool/WT = W
					if( WT.remove_fuel(0,user) )
						cut_cover=1
					else
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
				else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the support rods.</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user,70,src) || !istype(src, /turf/simulated/wall) || construction_stage != 1)
						return
					construction_stage = 0
					update_icon()
					new /obj/item/stack/rods(src)
					to_chat(user, "<span class='notice'>The support rods drop out as you cut them loose from the frame.</span>")
					return
			if(0)
				if(isCrowbar(W))
					to_chat(user, "<span class='notice'>You struggle to pry off the outer sheath.</span>")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(!do_after(user,100,src) || !istype(src, /turf/simulated/wall) || !user || !W || !T )	return
					if(user.loc == T && user.get_active_hand() == W )
						to_chat(user, "<span class='notice'>You pry off the outer sheath.</span>")
						dismantle_wall()
					return

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src)
		return

	else if(!istype(W,/obj/item/weapon/rcd) && !istype(W, /obj/item/weapon/reagent_containers))
		if(!W.force)
			return attack_hand(user)
		var/dam_threshhold = material.integrity
		if(reinf_material)
			dam_threshhold = ceil(max(dam_threshhold,reinf_material.integrity)/2)
		var/dam_prob = min(100,material.hardness*1.5)
		if(dam_prob < 100 && W.force > (dam_threshhold/10))
			playsound(src, hitsound, 80, 1)
			if(!prob(dam_prob))
				visible_message("<span class='danger'>\The [user] attacks \the [src] with \the [W] and it [material.destruction_desc]!</span>")
				dismantle_wall(1)
			else
				visible_message("<span class='danger'>\The [user] attacks \the [src] with \the [W]!</span>")
		else
			visible_message("<span class='danger'>\The [user] attacks \the [src] with \the [W], but it bounces off!</span>")
		return
