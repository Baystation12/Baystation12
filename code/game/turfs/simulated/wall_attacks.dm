//Interactions
/turf/simulated/wall/proc/toggle_open(var/mob/user)

	if(can_open == WALL_OPENING)
		return

	if(density)
		can_open = WALL_OPENING
		set_wall_state("[material.icon_base]fwall_open")
		//flick("[material.icon_base]fwall_opening", src)
		sleep(15)
		density = 0
		opacity = 0
		set_light(0)
	else
		can_open = WALL_OPENING
		//flick("[material.icon_base]fwall_closing", src)
		set_wall_state("[material.icon_base]0")
		density = 1
		opacity = 1
		sleep(15)
		set_light(1)

	can_open = WALL_CAN_OPEN
	update_icon()

/turf/simulated/wall/proc/fail_smash(var/mob/user)
	user << "<span class='danger'>You smash against the wall!</span>"
	take_damage(rand(25,75))

/turf/simulated/wall/proc/success_smash(var/mob/user)
	user << "<span class='danger'>You smash through the wall!</span>"
	user.do_attack_animation(src)
	spawn(1)
		dismantle_wall(1)

/turf/simulated/wall/proc/try_touch(var/mob/user, var/rotting)

	if(rotting)
		if(reinf_material)
			user << "<span class='danger'>\The [reinf_material.display_name] feels porous and crumbly.</span>"
		else
			user << "<span class='danger'>\The [material.display_name] crumbles under your touch!</span>"
			dismantle_wall()
			return 1

	if(..()) return 1

	if(!can_open)
		user << "<span class='notice'>You push the wall, but nothing happens.</span>"
		playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
	else
		toggle_open(user)
	return 0


/turf/simulated/wall/attack_hand(var/mob/user)

	radiate()
	add_fingerprint(user)
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
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if(!damage || !wallbreaker)
		try_touch(user, rotting)
		return

	if(rotting)
		return success_smash(user)

	if(reinf_material)
		if((wallbreaker == 2) || (damage >= max(material.hardness,reinf_material.hardness)))
			return success_smash(user)
	else if(damage >= material.hardness)
		return success_smash(user)
	return fail_smash(user)

/turf/simulated/wall/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (!user.)
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return

	//get the user's location
	if(!istype(user.loc, /turf))	return	//can't do this stuff whilst inside objects and such

	if(W)
		radiate()
		if(is_hot(W))
			burn(is_hot(W))

	if(locate(/obj/effect/overlay/wallrot) in src)
		if(istype(W, /obj/item/weapon/weldingtool) )
			var/obj/item/weapon/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				user << "<span class='notice'>You burn away the fungi with \the [WT].</span>"
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			user << "<span class='notice'>\The [src] crumbles away under the force of your [W.name].</span>"
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if( istype(W, /obj/item/weapon/weldingtool) )
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
			user << "<span class='notice'>You slash \the [src] with \the [EB]; the thermite ignites!</span>"
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
			user << "<span class='notice'>You start repairing the damage to [src].</span>"
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5)) && WT && WT.isOn())
				user << "<span class='notice'>You finish repairing the damage to [src].</span>"
				take_damage(-damage)
		else
			user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
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
				user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
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

			user << "<span class='notice'>You begin [dismantle_verb] through the outer plating.</span>"
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay<0)
				cut_delay = 0

			if(!do_after(user,cut_delay))
				return

			user << "<span class='notice'>You remove the outer plating.</span>"
			dismantle_wall()
			user.visible_message("<span class='warning'>The wall was torn open by [user]!</span>")
			return

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)
				if (istype(W, /obj/item/weapon/wirecutters))
					playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
					construction_stage = 5
					new /obj/item/stack/rods( src )
					user << "<span class='notice'>You cut the outer grille.</span>"
					set_wall_state()
					return
			if(5)
				if (istype(W, /obj/item/weapon/screwdriver))
					user << "<span class='notice'>You begin removing the support lines.</span>"
					playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
					if(!do_after(user,40) || !istype(src, /turf/simulated/wall) || construction_stage != 5)
						return
					construction_stage = 4
					set_wall_state()
					user << "<span class='notice'>You remove the support lines.</span>"
					return
				else if( istype(W, /obj/item/stack/rods) )
					var/obj/item/stack/O = W
					if(O.get_amount()>0)
						O.use(1)
						construction_stage = 6
						set_wall_state()
						user << "<span class='notice'>You replace the outer grille.</span>"
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
						user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
						return
				else if (istype(W, /obj/item/weapon/pickaxe/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					user << "<span class='notice'>You begin slicing through the metal cover.</span>"
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user, 60) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 3
					set_wall_state()
					user << "<span class='notice'>You press firmly on the cover, dislodging it.</span>"
					return
			if(3)
				if (istype(W, /obj/item/weapon/crowbar))
					user << "<span class='notice'>You struggle to pry off the cover.</span>"
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(!do_after(user,100) || !istype(src, /turf/simulated/wall) || construction_stage != 3)
						return
					construction_stage = 2
					set_wall_state()
					user << "<span class='notice'>You pry off the cover.</span>"
					return
			if(2)
				if (istype(W, /obj/item/weapon/wrench))
					user << "<span class='notice'>You start loosening the anchoring bolts which secure the support rods to their frame.</span>"
					playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
					if(!do_after(user,40) || !istype(src, /turf/simulated/wall) || construction_stage != 2)
						return
					construction_stage = 1
					set_wall_state()
					user << "<span class='notice'>You remove the bolts anchoring the support rods.</span>"
					return
			if(1)
				var/cut_cover
				if(istype(W, /obj/item/weapon/weldingtool))
					var/obj/item/weapon/weldingtool/WT = W
					if( WT.remove_fuel(0,user) )
						cut_cover=1
					else
						user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
						return
				else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					user << "<span class='notice'>You begin slicing through the support rods.</span>"
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user,70) || !istype(src, /turf/simulated/wall) || construction_stage != 1)
						return
					construction_stage = 0
					set_wall_state()
					new /obj/item/stack/rods(src)
					user << "<span class='notice'>The support rods drop out as you cut them loose from the frame.</span>"
					return
			if(0)
				if(istype(W, /obj/item/weapon/crowbar))
					user << "<span class='notice'>You struggle to pry off the outer sheath.</span>"
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					sleep(100)
					if(!istype(src, /turf/simulated/wall) || !user || !W || !T )	return
					if(user.loc == T && user.get_active_hand() == W )
						user << "<span class='notice'>You pry off the outer sheath.</span>"
						dismantle_wall()
					return

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src)
		return

	else if(!istype(W,/obj/item/weapon/rcd) && !istype(W, /obj/item/weapon/reagent_containers))
		return attack_hand(user)

