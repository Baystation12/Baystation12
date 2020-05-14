//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define DOOR_REPAIR_AMOUNT 50	//amount of health regained per stack amount used

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door1"
	anchored = 1
	opacity = 1
	density = 1
	layer = CLOSED_DOOR_LAYER
	interact_offline = TRUE

	var/open_layer = OPEN_DOOR_LAYER
	var/closed_layer = CLOSED_DOOR_LAYER

	var/visible = 1
	var/p_open = 0
	var/operating = 0
	var/autoclose = 0
	var/glass = 0
	var/normalspeed = 1
	var/heat_proof = 0 // For glass airlocks/opacity firedoors
	var/air_properties_vary_with_direction = 0
	var/maxhealth = 300
	var/health
	var/destroy_hits = 10 //How many strong hits it takes to destroy the door
	var/min_force = 10 //minimum amount of force needed to damage the door with a melee weapon
	var/hitsound = 'sound/weapons/smash.ogg' //sound door makes when hit with a weapon
	var/pry_mod = 1 //difficulty scaling for simple animal door prying
	var/obj/item/stack/material/repairing
	var/block_air_zones = 1 //If set, air zones cannot merge across the door even when it is opened.
	var/close_door_at = 0 //When to automatically close the door, if possible
	var/list/connections = list("0", "0", "0", "0")
	var/list/blend_objects = list(/obj/structure/wall_frame, /obj/structure/window, /obj/structure/grille) // Objects which to blend with

	var/autoset_access = TRUE // Determines whether the door will automatically set its access from the areas surrounding it. Can be used for mapping.

	//Multi-tile doors
	dir = SOUTH
	var/width = 1

	//Used for intercepting clicks on our turf. Set 0 to disable click interception
	var/turf_hand_priority = 3

	// turf animation
	var/atom/movable/overlay/c_animation = null

	atmos_canpass = CANPASS_PROC

/obj/machinery/door/attack_generic(var/mob/user, var/damage, var/attack_verb, var/environment_smash)
	if(environment_smash >= 1)
		damage = max(damage, 10)

	if(damage >= 10)
		visible_message("<span class='danger'>\The [user] [attack_verb] into \the [src]!</span>")
		take_damage(damage)
	else
		visible_message("<span class='notice'>\The [user] bonks \the [src] harmlessly.</span>")
	attack_animation(user)

/obj/machinery/door/New()
	. = ..()
	if(density)
		layer = closed_layer
		update_heat_protection(get_turf(src))
	else
		layer = open_layer


	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	if (turf_hand_priority)
		set_extension(src, /datum/extension/turf_hand, turf_hand_priority)

	health = maxhealth
	update_connections(1)
	update_icon()

	update_nearby_tiles(need_rebuild=1)

/obj/machinery/door/Initialize()
	set_extension(src, /datum/extension/penetration, /datum/extension/penetration/proc_call, .proc/CheckPenetration)
	. = ..()
	if(autoset_access)
#ifdef UNIT_TEST
		if(length(req_access))
			crash_with("A door with mapped access restrictions was set to autoinitialize access.")
#endif
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/door/LateInitialize()
	..()
	if(autoset_access) // Delayed because apparently the dir is not set by mapping and we need to wait for nearby walls to init and turn us.
		inherit_access_from_area()

/obj/machinery/door/Destroy()
	set_density(0)
	update_nearby_tiles()
	. = ..()

/obj/machinery/door/Process()
	if(close_door_at && world.time >= close_door_at)
		if(autoclose)
			close_door_at = next_close_time()
			close()
		else
			close_door_at = 0

/obj/machinery/door/proc/can_open()
	if(!density || operating)
		return 0
	return 1

/obj/machinery/door/proc/can_close()
	if(density || operating)
		return 0
	return 1

/obj/machinery/door/Bumped(atom/AM)
	if(p_open || operating) return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10) return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(!M.restrained() && (!issmall(M) || ishuman(M) || issilicon(M)))
			bumpopen(M)
		return

	if(istype(AM, /mob/living/bot))
		var/mob/living/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pulling && (src.allowed(wheel.pulling)))
				open()
			else
				do_animate("deny")
		return
	return


/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return !block_air_zones
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return !opacity
	return !density


/obj/machinery/door/proc/bumpopen(mob/user as mob)
	if(operating)	return
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return
	src.add_fingerprint(user)
	if(density)
		if(allowed(user))
			open()
		else
			do_animate("deny")
	return

/obj/machinery/door/bullet_act(var/obj/item/projectile/Proj)
	..()

	var/damage = Proj.get_structure_damage()

	// Emitter Blasts - these will eventually completely destroy the door, given enough time.
	if (damage > 90)
		destroy_hits--
		if (destroy_hits <= 0)
			visible_message("<span class='danger'>\The [src.name] disintegrates!</span>")
			switch (Proj.damage_type)
				if(BRUTE)
					new /obj/item/stack/material/steel(src.loc, 2)
					new /obj/item/stack/material/rods(src.loc, 3)
				if(BURN)
					new /obj/effect/decal/cleanable/ash(src.loc) // Turn it to ashes!
			qdel(src)

	if(damage)
		//cap projectile damage so that there's still a minimum number of hits required to break the door
		take_damage(min(damage, 100))



/obj/machinery/door/hitby(AM as mob|obj, var/datum/thrownthing/TT)

	..()
	visible_message("<span class='danger'>[src.name] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 3 * TT.speed
	else
		tforce = AM:throwforce * (TT.speed/THROWFORCE_SPEED_DIVISOR)
	playsound(src.loc, hitsound, 100, 1)
	take_damage(tforce)
	return

// This is legacy code that should be revisited, probably by moving the bulk of the logic into here.
/obj/machinery/door/interface_interact(user)
	if(CanInteract(user, DefaultTopicState()))
		return attackby(user, user)

/obj/machinery/door/attackby(obj/item/I as obj, mob/user as mob)
	src.add_fingerprint(user, 0, I)

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
		if(stat & BROKEN)
			to_chat(user, "<span class='notice'>It looks like \the [src] is pretty busted. It's going to need more than just patching up now.</span>")
			return
		if(health >= maxhealth)
			to_chat(user, "<span class='notice'>Nothing to fix!</span>")
			return
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
			return

		//figure out how much metal we need
		var/amount_needed = (maxhealth - health) / DOOR_REPAIR_AMOUNT
		amount_needed = ceil(amount_needed)

		var/obj/item/stack/stack = I
		var/transfer
		if (repairing)
			transfer = stack.transfer_to(repairing, amount_needed - repairing.amount)
			if (!transfer)
				to_chat(user, "<span class='warning'>You must weld or remove \the [repairing] from \the [src] before you can add anything else.</span>")
		else
			repairing = stack.split(amount_needed, force=TRUE)
			if (repairing)
				repairing.dropInto(src)
				transfer = repairing.amount
				repairing.uses_charge = FALSE //for clean robot door repair - stacks hint immortal if true

		if (transfer)
			to_chat(user, "<span class='notice'>You fit [transfer] [stack.singular_name]\s to damaged and broken parts on \the [src].</span>")

		return

	if(repairing && isWelder(I))
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
			return

		var/obj/item/weapon/weldingtool/welder = I
		if(welder.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You start to fix dents and weld \the [repairing] into place.</span>")
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, 5 * repairing.amount, src) && welder && welder.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to \the [src].</span>")
				health = between(health, health + repairing.amount*DOOR_REPAIR_AMOUNT, maxhealth)
				update_icon()
				qdel(repairing)
				repairing = null
		return

	if(repairing && isCrowbar(I))
		to_chat(user, "<span class='notice'>You remove \the [repairing].</span>")
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		repairing.dropInto(user.loc)
		repairing = null
		return

	check_force(I, user)

	if(src.operating > 0 || isrobot(user))	return //borgs can't attack doors open because it conflicts with their AI-like interaction with them.

	if(src.operating) return

	if(src.allowed(user) && operable())
		if(src.density)
			open()
		else
			close()
		return

	if(src.density)
		do_animate("deny")
	update_icon()
	return

/obj/machinery/door/emag_act(var/remaining_charges)
	if(density && operable())
		do_animate("emag")
		sleep(6)
		open()
		operating = -1
		return 1

//psa to whoever coded this, there are plenty of objects that need to call attack() on doors without bludgeoning them.
/obj/machinery/door/proc/check_force(obj/item/I as obj, mob/user as mob)
	if(src.density && istype(I, /obj/item/weapon) && user.a_intent == I_HURT && !istype(I, /obj/item/weapon/card))
		var/obj/item/weapon/W = I
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			if(W.force < min_force)
				user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W] with no visible effect.</span>")
			else
				user.visible_message("<span class='danger'>\The [user] forcefully strikes \the [src] with \the [W]!</span>")
				playsound(src.loc, hitsound, 100, 1)
				take_damage(W.force)

/obj/machinery/door/proc/take_damage(var/damage)
	var/initialhealth = src.health
	src.health = max(0, src.health - damage)
	if(src.health <= 0 && initialhealth > 0)
		src.set_broken(TRUE)
	else if(src.health < src.maxhealth / 4 && initialhealth >= src.maxhealth / 4)
		visible_message("\The [src] looks like it's about to break!" )
	else if(src.health < src.maxhealth / 2 && initialhealth >= src.maxhealth / 2)
		visible_message("\The [src] looks seriously damaged!" )
	else if(src.health < src.maxhealth * 3/4 && initialhealth >= src.maxhealth * 3/4)
		visible_message("\The [src] shows signs of damage!" )
	update_icon()
	return


/obj/machinery/door/examine(mob/user)
	. = ..()
	if(src.health <= 0)
		to_chat(user, "\The [src] is broken!")
	else if(src.health < src.maxhealth / 4)
		to_chat(user, "\The [src] looks like it's about to break!")
	else if(src.health < src.maxhealth / 2)
		to_chat(user, "\The [src] looks seriously damaged!")
	else if(src.health < src.maxhealth * 3/4)
		to_chat(user, "\The [src] shows signs of damage!")


/obj/machinery/door/set_broken(new_state)
	. = ..()
	if(. && new_state)
		visible_message("<span class = 'warning'>\The [src.name] breaks!</span>")

/obj/machinery/door/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(25))
				qdel(src)
			else
				take_damage(100)
			take_damage(200)
		if(3)
			if(prob(80))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
			else
				take_damage(100)
			take_damage(100)


/obj/machinery/door/on_update_icon()
	if(connections in list(NORTH, SOUTH, NORTH|SOUTH))
		if(connections in list(WEST, EAST, EAST|WEST))
			set_dir(SOUTH)
		else
			set_dir(EAST)
	else
		set_dir(SOUTH)

	if(density)
		icon_state = "door1"
	else
		icon_state = "door0"
	SSradiation.resistance_cache.Remove(get_turf(src))
	return


/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(p_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && !(stat & (NOPOWER|BROKEN)))
				flick("door_deny", src)
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
	return


/obj/machinery/door/proc/open(var/forced = 0)
	if(!can_open(forced))
		return
	operating = 1

	do_animate("opening")
	icon_state = "door0"
	set_opacity(0)
	sleep(3)
	src.set_density(0)
	update_nearby_tiles()
	sleep(7)
	src.layer = open_layer
	update_icon()
	set_opacity(0)
	operating = 0

	if(autoclose)
		close_door_at = next_close_time()

	return 1

/obj/machinery/door/proc/next_close_time()
	return world.time + (normalspeed ? 150 : 5)

/obj/machinery/door/proc/close(var/forced = 0)
	if(!can_close(forced))
		return
	operating = 1

	close_door_at = 0
	do_animate("closing")
	sleep(3)
	src.set_density(1)
	src.layer = closed_layer
	update_nearby_tiles()
	sleep(7)
	update_icon()
	if(visible && !glass)
		set_opacity(1)	//caaaaarn!
	operating = 0

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	if(fire)
		qdel(fire)
	return

/obj/machinery/door/proc/toggle(forced = 0)
	if(density)
		open(forced)
	else
		close(forced)

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/allowed(mob/M)
	if(!requiresID())
		return ..(null) //don't care who they are or what they have, act as if they're NOTHING
	return ..(M)

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	. = ..()
	for(var/turf/simulated/turf in locs)
		update_heat_protection(turf)
		SSair.mark_for_update(turf)
	return 1

/obj/machinery/door/proc/update_heat_protection(var/turf/simulated/source)
	if(istype(source))
		if(src.density && (src.opacity || src.heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/Move(new_loc, new_dir)
	update_nearby_tiles()

	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	if(.)
		deconstruct(null, TRUE)

/obj/machinery/door/proc/CheckPenetration(var/base_chance, var/damage)
	. = damage/maxhealth*180
	if(glass)
		. *= 2
	. = round(.)

/obj/machinery/door/proc/deconstruct(mob/user, var/moved = FALSE)
	return null

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'

/obj/machinery/door/proc/update_connections(var/propagate = 0)
	var/dirs = 0

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0

		if( istype(T, /turf/simulated/wall))
			success = 1
			if(propagate)
				var/turf/simulated/wall/W = T
				W.update_connections(1)
				W.update_icon()

		else if( istype(T, /turf/simulated/shuttle/wall) ||	istype(T, /turf/unsimulated/wall))
			success = 1
		else
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if( istype(O, b_type))
						success = 1

					if(success)
						break
				if(success)
					break

		if(success)
			dirs |= direction
	connections = dirs

/obj/machinery/door/CanFluidPass(var/coming_from)
	return !density

// Most doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/proc/create_electronics(var/electronics_type = /obj/item/weapon/airlock_electronics)
	var/obj/item/weapon/airlock_electronics/electronics = new electronics_type(loc)
	electronics.set_access(src)
	electronics.autoset = autoset_access
	return electronics

/obj/machinery/door/proc/access_area_by_dir(direction)
	var/turf/T = get_turf(get_step(src, direction))
	if (T && !T.density)
		return get_area(T)

/obj/machinery/door/proc/inherit_access_from_area()
	var/area/fore = access_area_by_dir(dir)
	var/area/aft = access_area_by_dir(GLOB.reverse_dir[dir])
	fore = fore || aft
	aft = aft || fore

	if (!fore && !aft)
		req_access = list()
	else if (fore.secure || aft.secure)
		req_access = req_access_union(fore, aft)
	else
		req_access = req_access_diff(fore, aft)

/obj/machinery/door/do_simple_ranged_interaction(var/mob/user)
	if(!requiresID() || allowed(null))
		toggle()
	return TRUE

// Public access

/decl/public_access/public_method/open_door
	name = "open door"
	desc = "Opens the door if possible."
	call_proc = /obj/machinery/door/proc/open

/decl/public_access/public_method/toggle_door
	name = "toggle door"
	desc = "Toggles whether the door is open or not, if possible."
	call_proc = /obj/machinery/door/proc/toggle
