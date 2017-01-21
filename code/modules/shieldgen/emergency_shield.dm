/obj/machinery/shield
	name = "Emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = 1
	opacity = 0
	anchored = 1
	unacidable = 1
	var/const/max_health = 200
	var/health = max_health //The shield can only take so much beating (prevents perma-prisons)
	var/shield_generate_power = 7500	//how much power we use when regenerating
	var/shield_idle_power = 1500		//how much power we use when just being sustained.

/obj/machinery/shield/malfai
	name = "emergency forcefield"
	desc = "A weak forcefield which seems to be projected by the station's emergency atmosphere containment field."
	health = max_health/2 // Half health, it's not suposed to resist much.

/obj/machinery/shield/malfai/process()
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

/obj/machinery/shield/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!istype(W)) return

	//Calculate damage
	var/aforce = W.force
	if(W.damtype == BRUTE || W.damtype == BURN)
		src.health -= aforce

	//Play a fitting sound
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 75, 1)

	check_failure()
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	..()

/obj/machinery/shield/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()
	check_failure()
	opacity = 1
	spawn(20) if(src) opacity = 0

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


/obj/machinery/shield/hitby(AM as mob|obj)
	//Let everyone know we've been hit!
	visible_message("<span class='notice'><B>\[src] was hit by [AM].</B></span>")

	//Super realistic, resource-intensive, real-time damage calculations.
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce

	src.health -= tforce

	//This seemed to be the best sound for hitting a force field.
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)

	check_failure()

	//The shield becomes dense to absorb the blow.. purely asthetic.
	opacity = 1
	spawn(20) if(src) opacity = 0

	..()
	return
/obj/machinery/shieldgen
	name = "Emergency shield projector"
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	density = 1
	opacity = 0
	anchored = 0
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
	use_power = 0
	idle_power_usage = 0

/obj/machinery/shieldgen/Destroy()
	collapse_shields()
	..()

/obj/machinery/shieldgen/proc/shields_up()
	if(active) return 0 //If it's already turned on, how did this get called?

	src.active = 1
	update_icon()

	create_shields()

	idle_power_usage = 0
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		idle_power_usage += shield_tile.shield_idle_power
	update_use_power(1)

/obj/machinery/shieldgen/proc/shields_down()
	if(!active) return 0 //If it's already off, how did this get called?

	src.active = 0
	update_icon()

	collapse_shields()

	update_use_power(0)

/obj/machinery/shieldgen/proc/create_shields()
	for(var/turf/target_tile in range(2, src))
		if (istype(target_tile,/turf/space) && !(locate(/obj/machinery/shield) in target_tile))
			if (malfunction && prob(33) || !malfunction)
				var/obj/machinery/shield/S = new/obj/machinery/shield(target_tile)
				deployed_shields += S
				use_power(S.shield_generate_power)

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

/obj/machinery/shieldgen/process()
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
				idle_power_usage = new_power_usage
				use_power(0)

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

/obj/machinery/shieldgen/attack_hand(mob/user as mob)
	if(locked)
		to_chat(user, "The machine is locked, you are unable to use it.")
		return
	if(is_open)
		to_chat(user, "The panel must be closed before operating this machine.")
		return

	if (src.active)
		user.visible_message("<span class='notice'>\icon[src] [user] deactivated the shield generator.</span>", \
			"<span class='notice'>\icon[src] You deactivate the shield generator.</span>", \
			"You hear heavy droning fade out.")
		src.shields_down()
	else
		if(anchored)
			user.visible_message("<span class='notice'>\icon[src] [user] activated the shield generator.</span>", \
				"<span class='notice'>\icon[src] You activate the shield generator.</span>", \
				"You hear heavy droning.")
			src.shields_up()
		else
			to_chat(user, "The device must first be secured to the floor.")
	return

/obj/machinery/shieldgen/emag_act(var/remaining_charges, var/mob/user)
	if(!malfunction)
		malfunction = 1
		update_icon()
		return 1

/obj/machinery/shieldgen/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		if(is_open)
			to_chat(user, "<span class='notice'>You close the panel.</span>")
			is_open = 0
		else
			to_chat(user, "<span class='notice'>You open the panel and expose the wiring.</span>")
			is_open = 1

	else if(istype(W, /obj/item/stack/cable_coil) && malfunction && is_open)
		var/obj/item/stack/cable_coil/coil = W
		to_chat(user, "<span class='notice'>You begin to replace the wires.</span>")
		//if(do_after(user, min(60, round( ((maxhealth/health)*10)+(malfunction*10) ))) //Take longer to repair heavier damage
		if(do_after(user, 30,src))
			if (coil.use(1))
				health = max_health
				malfunction = 0
				to_chat(user, "<span class='notice'>You repair the [src]!</span>")
				update_icon()

	else if(istype(W, /obj/item/weapon/wrench))
		if(locked)
			to_chat(user, "The bolts are covered, unlocking this would retract the covers.")
			return
		if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "<span class='notice'>'You unsecure the [src] from the floor!</span>")
			if(active)
				to_chat(user, "<span class='notice'>The [src] shuts off!</span>")
				src.shields_down()
			anchored = 0
		else
			if(istype(get_turf(src), /turf/space)) return //No wrenching these in space!
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You secure the [src] to the floor!</span>")
			anchored = 1


	else if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda))
		if(src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
	else
		..()


/obj/machinery/shieldgen/update_icon()
	if(active && !(stat & NOPOWER))
		src.icon_state = malfunction ? "shieldonbr":"shieldon"
	else
		src.icon_state = malfunction ? "shieldoffbr":"shieldoff"
	return
