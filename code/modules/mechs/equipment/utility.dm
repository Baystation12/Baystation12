/obj/item/mech_equipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mech_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/obj/carrying
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mech_equipment/clamp/attack()
	return 0

/obj/item/mech_equipment/clamp/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()

	if(. && !carrying)
		if(istype(target, /obj))


			var/obj/O = target
			if(O.buckled_mob)
				return
			if(locate(/mob/living) in O)
				to_chat(user,"<span class='warning'>You can't load living things into the cargo compartment.</span>")
				return

			if(O.anchored)
				to_chat(user, "<span class='warning'>[target] is firmly secured.</span>")
				return


			owner.visible_message(SPAN_NOTICE("\The [owner] begins loading \the [O]."))
			if(do_after(owner, 20, O, 0, 1))
				O.forceMove(src)
				carrying = O
				owner.visible_message(SPAN_NOTICE("\The [owner] loads \the [O] into its cargo compartment."))


		//attacking - Cannot be carrying something, cause then your clamp would be full
		else if(istype(target,/mob/living))
			var/mob/living/M = target
			if(user.a_intent == I_HURT)

				owner.setClickCooldown(owner.arms ? owner.arms.action_delay * 3 : 30) //This is an inefficient use of your powers
				if(prob(33))
					owner.visible_message(SPAN_DANGER("[owner] swings its [src] in a wide arc at [target] but misses completely!"))
					return
				M.attack_generic(src, (owner.arms ? owner.arms.melee_damage * 1.5 : 0), "slammed") //Honestly you should not be able to do this without hands, but still
				M.throw_at(get_edge_target_turf(owner ,owner.dir),5, 2)
				//to_chat(user, "<span class='warning'>You slam [target] with [src.name].</span>")
				//owner.visible_message("<span class='warning'>[owner] slams [target] with the hydraulic clamp.</span>")
			else
				step_away(M, owner)
				to_chat(user, "You push [target] out of the way.")
				owner.visible_message("[owner] pushes [target] out of the way.")

/obj/item/mech_equipment/clamp/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(!carrying)
			to_chat(user, SPAN_WARNING("You are not carrying anything in \the [src]."))
		else
			owner.visible_message(SPAN_NOTICE("\The [owner] unloads \the [carrying]."))
			carrying.forceMove(get_turf(src))
			carrying = null

/obj/item/mech_equipment/clamp/get_hardpoint_maptext()
	if(carrying)
		return carrying.name
	. = ..()

// A lot of this is copied from floodlights.
/obj/item/mech_equipment/light
	name = "floodlight"
	desc = "An exosuit-mounted light."
	icon_state = "mech_floodlight"
	item_state = "mech_floodlight"
	restricted_hardpoints = list(HARDPOINT_HEAD)
	layer_offset = -0.02

	var/on = 0
	var/l_max_bright = 0.9
	var/l_inner_range = 1
	var/l_outer_range = 6
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)

/obj/item/mech_equipment/light/attack_self(var/mob/user)
	. = ..()
	if(.)
		on = !on
		to_chat(user, "You switch \the [src] [on ? "on" : "off"].")
		update_icon()
		owner.update_icon()

/obj/item/mech_equipment/light/on_update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(l_max_bright, l_inner_range, l_outer_range)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0, 0)

/obj/item/mech_equipment/catapult
	name = "\improper gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	icon_state = "mech_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/mode = 1
	var/atom/movable/locked
	equipment_delay = 30 //Stunlocks are not ideal
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_MAGNET = 4)

/obj/item/mech_equipment/catapult/get_hardpoint_maptext()
	var/string
	if(locked)
		string = locked.name + " - "
	if(mode == 1)
		string += "Pull"
	else string += "Push"
	return string


/obj/item/mech_equipment/catapult/attack_self(var/mob/user)
	. = ..()
	if(.)
		mode = mode == 1 ? 2 : 1
		to_chat(user, SPAN_NOTICE("You set \the [src] to [mode == 1 ? "single" : "multi"]-target mode."))
		update_icon()


/obj/item/mech_equipment/catapult/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)

		switch(mode)
			if(1)
				if(!locked)
					var/atom/movable/AM = target
					if(!istype(AM) || AM.anchored)
						to_chat(user, SPAN_NOTICE("Unable to lock on [target]"))
						return
					locked = AM
					to_chat(user, SPAN_NOTICE("Locked on [AM]"))
					return
				else if(target != locked)
					if(locked in view(owner))
						locked.throw_at(target, 14, 1.5, owner)
						locked = null

						owner.get_cell().use(active_power_use * CELLRATE)

					else
						locked = null
						to_chat(user, SPAN_NOTICE("Lock on [locked] disengaged."))
			if(2)

				var/list/atoms = list()
				if(isturf(target))
					atoms = range(target,3)
				else
					atoms = orange(target,3)
				for(var/atom/movable/A in atoms)
					if(A.anchored) continue
					spawn(0)
						var/iter = 5-get_dist(A,target)
						for(var/i=0 to iter)
							step_away(A,target)
							sleep(2)

				
				owner.get_cell().use(active_power_use * CELLRATE)

		return



/obj/item/weapon/material/drill_head
	var/durability = 0
	name = "drill head"
	desc = "A replaceable drill head usually used in exosuit drills."
	icon_state = "drill_head"
	
/obj/item/weapon/material/drill_head/New(newloc, material_key)
	. = ..()
	durability = 2 * material.integrity

/obj/item/mech_equipment/drill
	name = "\improper drill"
	desc = "This is the drill that'll pierce the heavens!"
	icon_state = "mech_drill"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	equipment_delay = 10

	//Drill can have a head
	var/obj/item/weapon/material/drill_head/drill_head
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	


/obj/item/mech_equipment/drill/Initialize()
	. = ..()
	drill_head = new /obj/item/weapon/material/drill_head(src, "steel")//You start with a basic steel head

/obj/item/mech_equipment/drill/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(drill_head)
			owner.visible_message(SPAN_WARNING("[owner] revs the [drill_head], menancingly."))
			playsound(src, 'sound/weapons/circsawhit.ogg', 50, 1)


/obj/item/mech_equipment/drill/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)
		if(isobj(target))
			var/obj/target_obj = target
			if(!target_obj.vars.Find("unacidable") || target_obj.unacidable)	return
		if(istype(target,/obj/item/weapon/material/drill_head))
			var/obj/item/weapon/material/drill_head/DH = target
			if(drill_head)
				owner.visible_message(SPAN_NOTICE("\The [owner] detaches the [drill_head] mounted the [src]"))
				drill_head.forceMove(owner.loc)
			DH.forceMove(src)
			drill_head = DH
			owner.visible_message(SPAN_NOTICE("\The [owner] mounts the [drill_head] on the [src]"))
			return

		if(drill_head == null)
			to_chat(user, SPAN_WARNING("Your drill doesn't have a head!"))
			return
		owner.get_cell().use(active_power_use * CELLRATE)
		owner.visible_message("<span class='danger'>\The [owner] starts to drill \the [target]</span>", "<span class='warning'>You hear a large drill.</span>")
		to_chat(user, "<span class='danger'>You start to drill \the [target]</span>")

		var/T = target.loc

		//Better materials = faster drill! 
		var/delay = max(5, 20 - drill_head.material.brute_armor)
		owner.setClickCooldown(delay) //Don't spamclick!
		if(do_after(owner, delay, target))
			if(src == owner.selected_system)
				if(drill_head.durability <= 0)
					drill_head.shatter()
					drill_head = null
					return
				if(istype(target, /turf/simulated/wall))
					var/turf/simulated/wall/W = target
					if(max(W.material.hardness, W.reinf_material ? W.reinf_material.hardness : 0) > drill_head.material.hardness)
						to_chat(user, "<span class='warning'>\The [target] is too hard to drill through with this drill head.</span>")
					target.ex_act(2)
					drill_head.durability -= 1
				else if(istype(target, /turf/simulated/mineral))
					for(var/turf/simulated/mineral/M in range(target,1))
						if(get_dir(owner,M)&owner.dir)
							M.GetDrilled()
							drill_head.durability -= 1
				else if(istype(target, /turf/simulated/floor/asteroid))
					for(var/turf/simulated/floor/asteroid/M in range(target,1))
						if(get_dir(owner,M)&owner.dir)
							M.gets_dug()
							drill_head.durability -= 1
				else if(target.loc == T)
					target.ex_act(2)
					drill_head.durability -= 1

				

	
				if(owner.hardpoints.len) //if this isn't true the drill should not be working to be fair
					for(var/hardpoint in owner.hardpoints)
						var/obj/item/I = owner.hardpoints[hardpoint]
						if(!istype(I))
							continue
						var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in I //clamps work, but anythin that contains an ore crate internally is valid
						if(ore_box)
							for(var/obj/item/weapon/ore/ore in range(T,1))
								if(get_dir(owner,ore)&owner.dir)
									ore.Move(ore_box)

				playsound(src, 'sound/weapons/circsawhit.ogg', 50, 1)
		
		else
			to_chat(user, "You must stay still while the drill is engaged!")		

				
		return 1
		



/obj/item/mech_equipment/mounted_system/taser/plasma
	name = "Mounted plasma cutter"
	desc = "An industrial plasma cutter mounted onto the chassis of the mech. "
	icon_state = "railauto" //TODO: Make a new sprite that doesn't get sec called on you.
	holding_type = /obj/item/weapon/gun/energy/plasmacutter/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)

/obj/item/weapon/gun/energy/plasmacutter/mounted/mech
	use_external_power = TRUE
	has_safety = FALSE
	

/obj/item/mech_equipment/jumpjets
	name = "\improper exosuit jumpjets"
	desc = "A testament to the fact that sometimes more is actually more. These oversized ion boosters can briefly lift even an entire exosuit"
	icon_state = "mech_sleeper"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	equipment_delay = 40 //It's quite the setup
	active_power_use = 100 KILOWATTS //It's expensive, yo
	var/start_time = 0
	var/duration = 30
	var/burst_interval = 2
	var/next_burst = 0
	var/using = FALSE
	var/prev_y = 0
	var/prev_alpha = 0
	origin_tech = list(TECH_ENGINEERING = 6, TECH_MAGNET = 4, TECH_MATERIAL = 5)


/obj/item/mech_equipment/jumpjets/proc/setup()
	prev_y = owner.pixel_y
	prev_alpha = owner.alpha



/obj/item/mech_equipment/jumpjets/proc/reset()
	animate(owner)
	owner.pixel_y = prev_y
	owner.alpha = prev_alpha


/obj/item/mech_equipment/jumpjets/Process()
	if (world.time >= next_burst)

		var/obj/effect/effect/E = new /obj/effect/temporary(owner.loc, 10, 'icons/effects/effects.dmi',"jet")
		//Since the user will have their pixel offset animated by the transition, we must compensate the visuals
		//We will calculate a pixel offset for the thrust particle based on the progress
		var/max = 64

		var/progress = ((world.time - start_time) / duration)
		E.pixel_y = (max * progress) - 12 //-12 makes it offset down from the player a bit
		E.pixel_x = rand(-4,4) //Slight side to side randomness so it looks chaotic
		E.alpha = (255 - (255 * progress))*2 //Fade out as the player does, but less so
		E.layer = owner.layer-0.01 //Match the player's layer so it doesn't render over foreground turfs when moving downwards

		next_burst = world.time + burst_interval



/obj/item/mech_equipment/jumpjets/attack_self(var/mob/user)
	if(using)
		return
	. = ..()
	if(.)
		START_PROCESSING(SSobj, src)
		start_time = world.time
		owner.setClickCooldown(duration)
		setup()
		animate(owner, alpha = 0, pixel_y = 42, time = duration*0.9, easing = SINE_EASING)
		owner.visible_message(SPAN_DANGER("Up up and away! [owner] takes off!"))
		if(do_after(owner, duration, null, 0))
			owner.get_cell().use(active_power_use * CELLRATE)
	
		STOP_PROCESSING(SSobj,src)
		reset()
		next_burst = 0
			


/obj/item/mech_equipment/jumpjets/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
