/obj/machinery/shield
	name = "Emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = TRUE
	opacity = 0
	anchored = TRUE
	unacidable = TRUE
	var/const/max_health = 200
	var/health = max_health //The shield can only take so much beating (prevents perma-prisons)
	var/shield_generate_power = 7500	//how much power we use when regenerating
	var/shield_idle_power = 1500		//how much power we use when just being sustained.

/obj/machinery/shield/malfai
	name = "emergency forcefield"
	desc = "A weak forcefield which seems to be projected by the emergency atmosphere containment field."
	health = max_health/2 // Half health, it's not suposed to resist much.

/obj/machinery/shield/malfai/Process()
	health -= 0.5 // Slowly lose integrity over time
	check_failure()

/obj/machinery/shield/proc/check_failure()
	if (src.health <= 0)
		visible_message("<span class='notice'>\The [src] dissipates!</span>")
		qdel(src)
		return

/obj/machinery/shield/New()
	src.set_dir(pick(1,2,3,4))
	..()
	update_nearby_tiles(need_rebuild=1)

/obj/machinery/shield/Destroy()
	set_opacity(0)
	set_density(0)
	update_nearby_tiles()
	..()

/obj/machinery/shield/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!height || air_group) return 0
	else return ..()

/obj/machinery/shield/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W)) return

	//Calculate damage
	var/aforce = W.force
	if(W.damtype == BRUTE || W.damtype == BURN)
		src.health -= aforce

	//Play a fitting sound
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 75, 1)

	check_failure()
	set_opacity(1)
	spawn(20) if(!QDELETED(src)) set_opacity(0)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	..()

/obj/machinery/shield/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()
	check_failure()
	set_opacity(1)
	spawn(20) if(!QDELETED(src)) set_opacity(0)

/obj/machinery/shield/ex_act(severity)
	switch(severity)
		if(1.0)
			if (prob(75))
				qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(25))
				qdel(src)
	return

/obj/machinery/shield/emp_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)


/obj/machinery/shield/hitby(AM as mob|obj, var/datum/thrownthing/TT)
	//Let everyone know we've been hit!
	visible_message("<span class='notice'><B>\[src] was hit by [AM].</B></span>")

	//Super realistic, resource-intensive, real-time damage calculations.
	var/tforce = 0

	if(ismob(AM)) // All mobs have a multiplier and a size according to mob_defines.dm
		var/mob/I = AM
		tforce = I.mob_size * (TT.speed/THROWFORCE_SPEED_DIVISOR)
	else
		var/obj/O = AM
		tforce = O.throwforce * (TT.speed/THROWFORCE_SPEED_DIVISOR)

	src.health -= tforce

	//This seemed to be the best sound for hitting a force field.
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)

	check_failure()

	//The shield becomes dense to absorb the blow.. purely asthetic.
	set_opacity(1)
	spawn(20) if(!QDELETED(src)) set_opacity(0)

	..()
/obj/machinery/shieldgen
	name = "Emergency shield projector"
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	density = TRUE
	opacity = 0
	anchored = FALSE
	req_access = list(access_engine)
	var/const/max_health = 100
	var/health = max_health
	var/active = 0
	var/malfunction = 0 //Malfunction causes parts of the shield to slowly dissapate
	var/list/deployed_shields = list()
	var/list/regenerating = list()
	var/is_open = 0 //Whether or not the wires are exposed
	var/locked = 0
	var/check_delay = 60	//periodically recheck if we need to rebuild a shield
	use_power = POWER_USE_OFF
	idle_power_usage = 0

/obj/machinery/shieldgen/Destroy()
	collapse_shields()
	..()

/obj/machinery/shieldgen/proc/shields_up()
	if(active) return 0 //If it's already turned on, how did this get called?

	src.active = 1
	update_icon()

	create_shields()

	var/new_idle_power_usage = 0
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		new_idle_power_usage += shield_tile.shield_idle_power
	change_power_consumption(new_idle_power_usage, POWER_USE_IDLE)
	update_use_power(POWER_USE_IDLE)

/obj/machinery/shieldgen/proc/shields_down()
	if(!active) return 0 //If it's already off, how did this get called?

	src.active = 0
	update_icon()

	collapse_shields()

	update_use_power(POWER_USE_OFF)

/obj/machinery/shieldgen/proc/create_shields()
	for(var/turf/target_tile in range(8, src))
		if ((istype(target_tile,/turf/space)|| istype(target_tile, /turf/simulated/open)) && !(locate(/obj/machinery/shield) in target_tile))
			if (malfunction && prob(33) || !malfunction)
				var/obj/machinery/shield/S = new/obj/machinery/shield(target_tile)
				deployed_shields += S
				use_power_oneoff(S.shield_generate_power)

	for(var/turf/above in range(8, GetAbove(src)))//Probably a better way to do this.
		if ((istype(above,/turf/space)|| istype(above, /turf/simulated/open)) && !(locate(/obj/machinery/shield) in above))
			if (malfunction && prob(33) || !malfunction)
				var/obj/machinery/shield/A = new/obj/machinery/shield(above)
				deployed_shields += A
				use_power_oneoff(A.shield_generate_power)

/obj/machinery/shieldgen/proc/collapse_shields()
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		qdel(shield_tile)

/obj/machinery/shieldgen/power_change()
	. = ..()
	if(!. || !active) return
	if (stat & NOPOWER)
		collapse_shields()
	else
		create_shields()

/obj/machinery/shieldgen/Process()
	if (!active || (stat & NOPOWER))
		return

	if(malfunction)
		if(deployed_shields.len && prob(5))
			qdel(pick(deployed_shields))
	else
		if (check_delay <= 0)
			create_shields()

			var/new_power_usage = 0
			for(var/obj/machinery/shield/shield_tile in deployed_shields)
				new_power_usage += shield_tile.shield_idle_power

			if (new_power_usage != idle_power_usage)
				change_power_consumption(new_power_usage, POWER_USE_IDLE)

			check_delay = 60
		else
			check_delay--

/obj/machinery/shieldgen/proc/checkhp()
	if(health <= 30)
		src.malfunction = 1
	if(health <= 0)
		spawn(0)
			explosion(get_turf(src.loc), 0, 0, 1, 0, 0, 0)
		qdel(src)
	update_icon()
	return

/obj/machinery/shieldgen/ex_act(severity)
	switch(severity)
		if(1.0)
			src.health -= 75
			src.checkhp()
		if(2.0)
			src.health -= 30
			if (prob(15))
				src.malfunction = 1
			src.checkhp()
		if(3.0)
			src.health -= 10
			src.checkhp()
	return

/obj/machinery/shieldgen/emp_act(severity)
	switch(severity)
		if(1)
			src.health /= 2 //cut health in half
			malfunction = 1
			locked = pick(0,1)
		if(2)
			if(prob(50))
				src.health *= 0.3 //chop off a third of the health
				malfunction = 1
	checkhp()

/obj/machinery/shieldgen/interface_interact(mob/user as mob)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(locked)
		to_chat(user, "The machine is locked, you are unable to use it.")
		return TRUE
	if(is_open)
		to_chat(user, "The panel must be closed before operating this machine.")
		return TRUE

	if (src.active)
		user.visible_message("<span class='notice'>[icon2html(src, viewers(get_turf(src)))] [user] deactivated the shield generator.</span>", \
			"<span class='notice'>[icon2html(src,user)] You deactivate the shield generator.</span>", \
			"You hear heavy droning fade out.")
		src.shields_down()
	else
		if(anchored)
			user.visible_message("<span class='notice'>[icon2html(src, viewers(get_turf(src)))] [user] activated the shield generator.</span>", \
				"<span class='notice'>[icon2html(src, user)] You activate the shield generator.</span>", \
				"You hear heavy droning.")
			src.shields_up()
		else
			to_chat(user, "The device must first be secured to the floor.")
	return TRUE

/obj/machinery/shieldgen/emag_act(var/remaining_charges, var/mob/user)
	if(!malfunction)
		malfunction = 1
		update_icon()
		return 1

/obj/machinery/shieldgen/attackby(obj/item/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		if(is_open)
			to_chat(user, "<span class='notice'>You close the panel.</span>")
			is_open = 0
		else
			to_chat(user, "<span class='notice'>You open the panel and expose the wiring.</span>")
			is_open = 1

	else if(isCoil(W) && malfunction && is_open)
		var/obj/item/stack/cable_coil/coil = W
		to_chat(user, "<span class='notice'>You begin to replace the wires.</span>")
		//if(do_after(user, min(60, round( ((maxhealth/health)*10)+(malfunction*10) ))) //Take longer to repair heavier damage
		if(do_after(user, 30,src))
			if (coil.use(1))
				health = max_health
				malfunction = 0
				to_chat(user, "<span class='notice'>You repair the [src]!</span>")
				update_icon()

	else if(istype(W, /obj/item/wrench))
		if(locked)
			to_chat(user, "The bolts are covered, unlocking this would retract the covers.")
			return
		if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "<span class='notice'>'You unsecure the [src] from the floor!</span>")
			if(active)
				to_chat(user, "<span class='notice'>The [src] shuts off!</span>")
				src.shields_down()
			anchored = FALSE
		else
			if(istype(get_turf(src), /turf/space)) return //No wrenching these in space!
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You secure the [src] to the floor!</span>")
			anchored = TRUE


	else if(istype(W, /obj/item/card/id) || istype(W, /obj/item/modular_computer/pda))
		if(src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
	else
		..()


/obj/machinery/shieldgen/on_update_icon()
	if(active && !(stat & NOPOWER))
		src.icon_state = malfunction ? "shieldonbr":"shieldon"
	else
		src.icon_state = malfunction ? "shieldoffbr":"shieldoff"
	return
