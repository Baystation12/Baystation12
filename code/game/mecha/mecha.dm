#define MECHA_INT_FIRE 1
#define MECHA_INT_TEMP_CONTROL 2
#define MECHA_INT_SHORT_CIRCUIT 4
#define MECHA_INT_TANK_BREACH 8
#define MECHA_INT_CONTROL_LOST 16

#define MELEE 1
#define RANGED 2


/obj/mecha
	name = "Mecha"
	desc = "An exosuit."
	icon = 'icons/mecha/mecha.dmi'
	density = 1 //Dense. To raise the heat.
	opacity = 1 ///opaque. Menacing.
	anchored = 1 //no pulling around.
	unacidable = 1 //and no deleting hoomans inside
	plane = OBJ_PLANE
	layer = ABOVE_WINDOW_LAYER //icon draw layer
	infra_luminosity = 15 //byond implementation is bugged.
	anchor_fall = TRUE
	w_class = ITEM_SIZE_NO_CONTAINER
	var/initial_icon = null //Mech type for resetting icon. Only used for reskinning kits (see custom items)
	var/can_move = 1
	var/mob/living/carbon/occupant = null
	var/list/dropped_items = list()
	var/step_in = 10 //make a step in step_in/10 sec.
	var/dir_in = 2//What direction will the mech face when entered/powered on? Defaults to South.
	var/step_energy_drain = 200		// Energy usage per step in joules.
	var/health = 300 //health is health
	var/deflect_chance = 10 //chance to deflect incoming projectiles, hits, or lesser the effect of ex_act.
	var/r_deflect_coeff = 1
	var/m_deflect_coeff = 1
	//ranged and melee damage multipliers
	var/r_damage_coeff = 1
	var/m_damage_coeff = 1
	var/rhit_power_use = 0
	var/mhit_power_use = 0

	//the values in this list show how much damage will pass through, not how much will be absorbed.
	var/list/damage_absorption = list("brute"=0.8,"fire"=1.2,"bullet"=0.9,"laser"=1,"energy"=1,"bomb"=1)
	var/obj/item/weapon/cell/cell
	var/state = 0
	var/list/log = new
	var/last_message = 0
	var/add_req_access = 1
	var/maint_access = 1
	var/dna	//dna-locking the mech
	var/datum/effect/effect/system/spark_spread/spark_system = new
	var/lights = 0
	var/lights_power = 6
	var/force = 0

	//inner atmos
	var/use_internal_tank = 0
	var/internal_tank_valve = ONE_ATMOSPHERE
	var/obj/machinery/portable_atmospherics/canister/internal_tank
	var/datum/gas_mixture/cabin_air
	var/obj/machinery/atmospherics/portables_connector/connected_port = null

	var/obj/item/device/radio/radio = null

	var/max_temperature = 25000
	var/internal_damage_threshold = 50 //health percentage below which internal damage is possible
	var/internal_damage = 0 //contains bitflags

	var/list/operation_req_access = list()//required access level for mecha operation
	var/list/internals_req_access = list(access_engine,access_robotics)//required access level to open cell compartment

	var/datum/global_iterator/pr_int_temp_processor //normalizes internal air mixture temperature
	var/datum/global_iterator/pr_inertial_movement //controls intertial movement in spesss
	var/datum/global_iterator/pr_give_air //moves air from tank to cabin
	var/datum/global_iterator/pr_internal_damage //processes internal damage


	var/wreckage

	var/list/equipment = new
	var/obj/item/mecha_parts/mecha_equipment/selected
	var/max_equip = 3
	var/datum/events/events

/obj/mecha/drain_power(var/drain_check)

	if(drain_check)
		return 1

	if(!cell)
		return 0

	return cell.drain_power(drain_check)

/obj/mecha/New()
	..()
	events = new

	icon_state += "-open"
	add_radio()
	add_cabin()
	add_airtank() //All mecha currently have airtanks. No need to check unless changes are made.
	spark_system.set_up(2, 0, src)
	spark_system.attach(src)
	add_cell()
	add_iterators()
	removeVerb(/obj/mecha/verb/disconnect_from_port)
	log_message("[src.name] created.")
	loc.Entered(src)
	mechas_list += src //global mech list
	return

/obj/mecha/Destroy()
	src.go_out()
	for(var/mob/M in src) //Let's just be ultra sure
		M.Move(loc)

	if(loc)
		loc.Exited(src)

	if(prob(30))
		explosion(get_turf(loc), 0, 0, 1, 3)

	if(wreckage)
		var/obj/effect/decal/mecha_wreckage/WR = new wreckage(loc)
		for(var/obj/item/mecha_parts/mecha_equipment/E in equipment)
			if(E.salvageable && prob(30))
				WR.crowbar_salvage += E
				E.forceMove(WR)
				E.equip_ready = 1
			else
				E.forceMove(loc)
				E.destroy()
		if(cell)
			WR.crowbar_salvage += cell
			cell.forceMove(WR)
			cell.charge = rand(0, cell.charge)
		if(internal_tank)
			WR.crowbar_salvage += internal_tank
			internal_tank.forceMove(WR)
	else
		for(var/obj/item/mecha_parts/mecha_equipment/E in equipment)
			E.detach(loc)
			E.destroy()
		if(cell)
			qdel(cell)
		if(internal_tank)
			qdel(internal_tank)
	equipment.Cut()
	cell = null
	internal_tank = null

	QDEL_NULL(pr_int_temp_processor)
	QDEL_NULL(pr_inertial_movement)
	QDEL_NULL(pr_give_air)
	QDEL_NULL(pr_internal_damage)
	QDEL_NULL(spark_system)

	mechas_list -= src //global mech list
	. = ..()

////////////////////////
////// Helpers /////////
////////////////////////

/obj/mecha/proc/removeVerb(verb_path)
	verbs -= verb_path

/obj/mecha/proc/addVerb(verb_path)
	verbs += verb_path

/obj/mecha/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

/obj/mecha/proc/add_cell()
	cell = new /obj/item/weapon/cell/mecha(src)

/obj/mecha/proc/add_cabin()
	cabin_air = new
	cabin_air.temperature = T20C
	cabin_air.volume = 200
	cabin_air.adjust_multi("oxygen", O2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature), "nitrogen", N2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature))
	return cabin_air

/obj/mecha/proc/add_radio()
	radio = new(src)
	radio.SetName("[src] radio")
	radio.icon = icon
	radio.icon_state = icon_state
	radio.subspace_transmission = 1

/obj/mecha/proc/add_iterators()
	pr_int_temp_processor = new /datum/global_iterator/mecha_preserve_temp(list(src))
	pr_inertial_movement = new /datum/global_iterator/mecha_inertial_movement(null,0)
	pr_give_air = new /datum/global_iterator/mecha_tank_give_air(list(src))
	pr_internal_damage = new /datum/global_iterator/mecha_internal_damage(list(src),0)

/obj/mecha/proc/do_after(delay as num)
	sleep(delay)
	if(src)
		return 1
	return 0

/obj/mecha/proc/enter_after(delay as num, var/mob/user as mob, var/numticks = 5)
	var/delayfraction = delay/numticks

	var/turf/T = user.loc

	for(var/i = 0, i<numticks, i++)
		sleep(delayfraction)
		if(!src || !user || !user.canmove || !(user.loc == T))
			return 0

	return 1



/obj/mecha/proc/check_for_support()
	if(locate(/obj/structure/grille, orange(1, src)) || locate(/obj/structure/lattice, orange(1, src)) || locate(/turf/simulated, orange(1, src)) || locate(/turf/unsimulated, orange(1, src)))
		return 1
	else
		return 0

/obj/mecha/examine(mob/user)
	. = ..(user)
	var/integrity = health/initial(health)*100
	switch(integrity)
		if(85 to 100)
			to_chat(user, "It's fully intact.")
		if(65 to 85)
			to_chat(user, "It's slightly damaged.")
		if(45 to 65)
			to_chat(user, "It's badly damaged.")
		if(25 to 45)
			to_chat(user, "It's heavily damaged.")
		else
			to_chat(user, "It's falling apart.")
	if(equipment && equipment.len)
		to_chat(user, "It's equipped with:")
		for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
			to_chat(user, "\icon[ME] [ME]")
	return


/obj/mecha/proc/drop_item()//Derpfix, but may be useful in future for engineering exosuits.
	return

/obj/mecha/hear_talk(mob/M as mob, text)
	if(M==occupant && radio.broadcasting)
		radio.talk_into(M, text)
	return

////////////////////////////
///// Action processing ////
////////////////////////////
/*
/atom/DblClick(object,location,control,params)
	var/mob/M = src.mob
	if(M && M.in_contents_of(/obj/mecha))

		if(mech_click == world.time) return
		mech_click = world.time

		if(!istype(object, /atom)) return
		if(istype(object, /obj/screen))
			var/obj/screen/using = object
			if(using.screen_loc == ui_acti || using.screen_loc == ui_iarrowleft || using.screen_loc == ui_iarrowright)//ignore all HUD objects save 'intent' and its arrows
				return ..()
			else
				return
		var/obj/mecha/Mech = M.loc
		spawn() //this helps prevent clickspam fest.
			if (Mech)
				Mech.click_action(object,M)
//	else
//		return ..()
*/

/obj/mecha/proc/click_action(atom/target,mob/user)
	if(!src.occupant || src.occupant != user ) return
	if(user.stat) return
	if(state)
		occupant_message("<font color='red'>Maintenance protocols in effect.</font>")
		return
	if(!get_charge()) return
	if(src == target) return
	var/dir_to_target = get_dir(src,target)
	if(dir_to_target && !(dir_to_target & src.dir))
		return
	if(hasInternalDamage(MECHA_INT_CONTROL_LOST))
		target = safepick(view(3,target))
		if(!target)
			return
	if(istype(target, /obj/machinery))
		if (src.interface_action(target))
			return
	if(!target.Adjacent(src))
		if(selected && selected.is_ranged())
			selected.action(target)
	else if(selected && selected.is_melee())
		selected.action(target)
	else
		src.melee_action(target)
	return

/obj/mecha/proc/interface_action(obj/machinery/target)
	if(istype(target, /obj/machinery/access_button) && target.Adjacent(src))
		src.occupant_message("<span class='notice'>Interfacing with [target].</span>")
		src.log_message("Interfaced with [target].")
		target.attack_hand(src.occupant)
		return 1
	if(istype(target, /obj/machinery/embedded_controller))
		if(target in view(2,src))
			src.occupant_message("<span class='notice'>Interfacing with [target]...</span>")
			src.log_message("Interfaced with [target].")
			target.ui_interact(src.occupant)
		else
			src.occupant_message("<span class='notice'>Unable to interface with [target], target out of range.</span>")
		return 1
	return 0

/obj/mecha/contents_nano_distance(var/src_object, var/mob/living/user)
	. = user.shared_living_nano_distance(src_object) //allow them to interact with anything they can interact with normally.
	if(. != STATUS_INTERACTIVE)
		//Allow interaction with the mecha or anything that is part of the mecha
		if(src_object == src || (src_object in src))
			return STATUS_INTERACTIVE
		if(src.Adjacent(src_object))
			return STATUS_INTERACTIVE
		if(src_object in view(2, src))
			return STATUS_UPDATE //if they're close enough, allow the occupant to see the screen through the viewport or whatever.

/obj/mecha/proc/melee_action(atom/target)
	return

/obj/mecha/proc/range_action(atom/target)
	return


//////////////////////////////////
////////  Movement procs  ////////
//////////////////////////////////

/obj/mecha/Move()
	. = ..()
	if(.)
		events.fireEvent("onMove",get_turf(src))
	return

/obj/mecha/relaymove(mob/user,direction)
	if(user != src.occupant) //While not "realistic", this piece is player friendly.
		user.forceMove(get_turf(src))
		to_chat(user, "You climb out from [src]")
		return 0
	if(connected_port)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while connected to the air system port.")
			last_message = world.time
		return 0
	if(state)
		occupant_message("<font color='red'>Maintenance protocols in effect.</font>")
		return
	return do_move(direction)

/obj/mecha/proc/do_move(direction)
	if(!can_move)
		return 0
	if(src.pr_inertial_movement.active())
		return 0
	if(!has_charge(step_energy_drain))
		return 0
	var/move_result = 0
	if(hasInternalDamage(MECHA_INT_CONTROL_LOST))
		move_result = mechsteprand()
	else if(src.dir!=direction)
		move_result = mechturn(direction)
	else
		move_result	= mechstep(direction)
	if(move_result)
		can_move = 0
		use_power(step_energy_drain)
		if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				src.pr_inertial_movement.start(list(src,direction))
				src.log_message("Movement control lost. Inertial movement started.")
		if(do_after(step_in))
			can_move = 1
		return 1
	return 0

/obj/mecha/proc/mechturn(direction)
	set_dir(direction)
	playsound(src,'sound/mecha/mechturn.ogg',40,1)
	return 1

/obj/mecha/proc/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		playsound(src,'sound/mecha/mechstep.ogg',40,1)
	return result


/obj/mecha/proc/mechsteprand()
	var/result = step_rand(src)
	if(result)
		playsound(src,'sound/mecha/mechstep.ogg',40,1)
	return result

/obj/mecha/Bump(var/atom/obstacle)
//	src.inertia_dir = null
	if(istype(obstacle, /obj))
		var/obj/O = obstacle
		if(istype(O, /obj/effect/portal)) //derpfix
			src.anchored = 0
			O.Crossed(src)
			spawn(0)//countering portal teleport spawn(0), hurr
				src.anchored = 1
		else if(!O.anchored)
			step(obstacle,src.dir)
		else //I have no idea why I disabled this
			obstacle.Bumped(src)
	else if(istype(obstacle, /mob))
		step(obstacle,src.dir)
	else
		obstacle.Bumped(src)
	return

///////////////////////////////////
////////  Internal damage  ////////
///////////////////////////////////

/obj/mecha/proc/check_for_internal_damage(var/list/possible_int_damage,var/ignore_threshold=null)
	if(!islist(possible_int_damage) || isemptylist(possible_int_damage)) return
	if(prob(20))
		if(ignore_threshold || src.health*100/initial(src.health)<src.internal_damage_threshold)
			for(var/T in possible_int_damage)
				if(internal_damage & T)
					possible_int_damage -= T
			var/int_dam_flag = safepick(possible_int_damage)
			if(int_dam_flag)
				setInternalDamage(int_dam_flag)
	if(prob(5))
		if(ignore_threshold || src.health*100/initial(src.health)<src.internal_damage_threshold)
			var/obj/item/mecha_parts/mecha_equipment/destr = safepick(equipment)
			if(destr)
				destr.destroy()
	return

/obj/mecha/proc/hasInternalDamage(int_dam_flag=null)
	return int_dam_flag ? internal_damage&int_dam_flag : internal_damage


/obj/mecha/proc/setInternalDamage(int_dam_flag)
	if(!pr_internal_damage) return

	internal_damage |= int_dam_flag
	pr_internal_damage.start()
	log_append_to_last("Internal damage of type [int_dam_flag].",1)
	sound_to(occupant, sound('sound/machines/warning-buzzer.ogg',wait=0))
	return

/obj/mecha/proc/clearInternalDamage(int_dam_flag)
	internal_damage &= ~int_dam_flag
	switch(int_dam_flag)
		if(MECHA_INT_TEMP_CONTROL)
			occupant_message("<font color='blue'><b>Life support system reactivated.</b></font>")
			pr_int_temp_processor.start()
		if(MECHA_INT_FIRE)
			occupant_message("<font color='blue'><b>Internal fire extinquished.</b></font>")
		if(MECHA_INT_TANK_BREACH)
			occupant_message("<font color='blue'><b>Damaged internal tank has been sealed.</b></font>")
	return


////////////////////////////////////////
////////  Health related procs  ////////
////////////////////////////////////////

/obj/mecha/proc/take_damage(amount, type="brute")
	if(amount)
		var/damage = absorb_damage(amount,type)
		health -= damage
		update_health()
		log_append_to_last("Took [damage] points of damage. Damage type: \"[type]\".",1)
	return

/obj/mecha/proc/absorb_damage(damage,damage_type)
	return damage*(listgetindex(damage_absorption,damage_type) || 1)

/obj/mecha/proc/hit_damage(damage, type="brute", is_melee=0)

	var/power_to_use
	var/damage_coeff_to_use

	if(is_melee)
		power_to_use = mhit_power_use
		damage_coeff_to_use = m_damage_coeff
	else
		power_to_use = rhit_power_use
		damage_coeff_to_use = r_damage_coeff

	if(power_to_use && use_power(power_to_use))
		take_damage(round(damage*damage_coeff_to_use), type)
		start_booster_cooldown(is_melee)
		return
	else
		start_booster_cooldown(is_melee)
		take_damage(round(damage*damage_coeff_to_use), type)

	return

/obj/mecha/proc/deflect_hit(is_melee=0)

	var/power_to_use
	var/deflect_coeff_to_use

	if(is_melee)
		power_to_use = mhit_power_use
		deflect_coeff_to_use = m_damage_coeff
	else
		power_to_use = rhit_power_use
		deflect_coeff_to_use = r_damage_coeff

	if(power_to_use)
		if(prob(src.deflect_chance*deflect_coeff_to_use))
			use_power(power_to_use)
			start_booster_cooldown(is_melee)
			return 1
		else
			return 0

	else
		start_booster_cooldown(is_melee)
		if(prob(src.deflect_chance*deflect_coeff_to_use))
			return 1

	return 0

/obj/mecha/proc/start_booster_cooldown(is_melee)

	for(var/obj/item/mecha_parts/mecha_equipment/armor_booster/B in equipment) //Ideally this would be done by the armor booster itself; attempts weren't great for performance.
		if(B.melee == is_melee && B.equip_ready)
			B.set_ready_state(0)
			B.do_after_cooldown()

/obj/mecha/airlock_crush(var/crush_damage)
	..()
	hit_damage(crush_damage, is_melee=1)
	check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return 1

/obj/mecha/proc/update_health()
	if(src.health > 0)
		src.spark_system.start()
	else
		qdel(src)
	return

/obj/mecha/attack_hand(mob/user as mob)
	src.log_message("Attack by hand/paw. Attacker - [user].",1)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(user))
			if(!deflect_hit(is_melee=1))
				src.hit_damage(damage=15, is_melee=1)
				src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
				playsound(src.loc, 'sound/weapons/slash.ogg', 50, 1, -1)
				to_chat(user, "<span class='danger'>You slash at the armored suit!</span>")
				visible_message("<span class='danger'>\The [user] slashes at [src.name]'s armor!</span>")
			else
				src.log_append_to_last("Armor saved.")
				playsound(src.loc, 'sound/weapons/slash.ogg', 50, 1, -1)
				to_chat(user, "<span class='danger'>Your claws had no effect!</span>")
				src.occupant_message("<span class='notice'>\The [user]'s claws are stopped by the armor.</span>")
				visible_message("<span class='warning'>\The [user] rebounds off [src.name]'s armor!</span>")
		else
			user.visible_message("<span class='danger'>\The [user] hits \the [src]. Nothing happens.</span>","<span class='danger'>You hit \the [src] with no visible effect.</span>")
			src.log_append_to_last("Armor saved.")
		return
	else if ((HULK in user.mutations) && !deflect_hit(is_melee=1))
		src.hit_damage(damage=15, is_melee=1)
		src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		user.visible_message("<font color='red'><b>[user] hits [src.name], doing some damage.</b></font>", "<font color='red'><b>You hit [src.name] with all your might. The metal creaks and bends.</b></font>")
	else
		user.visible_message("<font color='red'><b>[user] hits [src.name]. Nothing happens</b></font>","<font color='red'><b>You hit [src.name] with no visible effect.</b></font>")
		src.log_append_to_last("Armor saved.")
	return

/obj/mecha/hitby(atom/movable/A as mob|obj)
	..()
	src.log_message("Hit by [A].",1)
	if(istype(A, /obj/item/mecha_parts/mecha_tracking))
		A.forceMove(src)
		src.visible_message("The [A] fastens firmly to [src].")
		return
	if(deflect_hit(is_melee=0) || istype(A, /mob))
		src.occupant_message("<span class='notice'>\The [A] bounces off the armor.</span>")
		src.visible_message("\The [A] bounces off \the [src] armor.")
		src.log_append_to_last("Armor saved.")
		if(istype(A, /mob/living))
			var/mob/living/M = A
			M.take_organ_damage(10)
	else if(istype(A, /obj))
		var/obj/O = A
		if(O.throwforce)
			src.hit_damage(O.throwforce, is_melee=0)
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return

/obj/mecha/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.damage_type == PAIN && !(src.r_deflect_coeff > 1))
		use_power(Proj.agony * 5)

	src.log_message("Hit by projectile. Type: [Proj.name]([Proj.check_armour]).",1)
	if(deflect_hit(is_melee=0))
		src.occupant_message("<span class='notice'>The armor deflects incoming projectile.</span>")
		src.visible_message("The [src.name] armor deflects the projectile.")
		src.log_append_to_last("Armor saved.")
		return

	if(!(Proj.nodamage))
		var/ignore_threshold
		if(istype(Proj, /obj/item/projectile/beam/pulse))
			ignore_threshold = 1
		src.hit_damage(Proj.damage, Proj.check_armour, is_melee=0)
		if(prob(25)) spark_system.start()
		src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),ignore_threshold)

		//AP projectiles have a chance to cause additional damage
		if(Proj.penetrating)
			var/distance = get_dist(Proj.starting, get_turf(loc))
			var/hit_occupant = 1 //only allow the occupant to be hit once
			for(var/i in 1 to min(Proj.penetrating, round(Proj.damage/15)))
				if(src.occupant && hit_occupant && prob(20))
					Proj.attack_mob(src.occupant, distance)
					hit_occupant = 0
				else
					src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT), 1)

				Proj.penetrating--

				if(prob(15))
					break //give a chance to exit early

	Proj.on_hit(src) //on_hit just returns if it's argument is not a living mob so does this actually do anything?
	..()
	return

/obj/mecha/ex_act(severity)
	src.log_message("Affected by explosion of severity: [severity].",1)
	if(prob(src.deflect_chance))
		severity++
		src.log_append_to_last("Armor saved, changing severity to [severity].")
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(30))
				qdel(src)
			else
				src.take_damage(initial(src.health)/2)
				src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),1)
		if(3.0)
			if (prob(5))
				qdel(src)
			else
				src.take_damage(initial(src.health)/5)
				src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),1)
	return

/*Will fix later -Sieve
/obj/mecha/attack_blob(mob/user as mob)
	src.log_message("Attack by blob. Attacker - [user].",1)
	if(!prob(src.deflect_chance))
		src.take_damage(6)
		src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		playsound(src.loc, 'sound/effects/blobattack.ogg', 50, 1, -1)
		to_chat(user, "<span class='danger'>You smash at the armored suit!</span>")
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message("<span class='danger'>\The [user] smashes against [src.name]'s armor!</span>", 1)
	else
		src.log_append_to_last("Armor saved.")
		playsound(src.loc, 'sound/effects/blobattack.ogg', 50, 1, -1)
		to_chat(user, "<span class='warning'>Your attack had no effect!</span>")
		src.occupant_message("<span class='warning'>\The [user]'s attack is stopped by the armor.</span>")
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message("<span class='warning'>\The [user] rebounds off the [src.name] armor!</span>", 1)
	return
*/

/obj/mecha/emp_act(severity)
	if(use_power((cell.charge/2)/severity))
		take_damage(50 / severity,"energy")
	src.log_message("EMP detected",1)
	check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),1)
	return

/obj/mecha/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature>src.max_temperature)
		src.log_message("Exposed to dangerous temperature.",1)
		src.take_damage(5,"fire")
		src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL))
	return


//////////////////////
////// AttackBy //////
//////////////////////

/obj/mecha/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W, /obj/item/mecha_parts/mecha_equipment))
		var/obj/item/mecha_parts/mecha_equipment/E = W
		spawn()
			if(E.can_attach(src))
				user.drop_item()
				E.attach(src)
				user.visible_message("[user] attaches [W] to [src]", "You attach [W] to [src]")
			else
				to_chat(user, "You were unable to attach [W] to [src]")
		return

	var/obj/item/weapon/card/id/id_card = W.GetIdCard()
	if(id_card)
		if(add_req_access || maint_access)
			if(internals_access_allowed(usr))
				output_maintenance_dialog(id_card, user)
				return
			else
				to_chat(user, "<span class='warning'>Invalid ID: Access denied.</span>")
		else
			to_chat(user, "<span class='warning'>Maintenance protocols disabled by operator.</span>")
	else if(isWrench(W))
		if(state==1)
			state = 2
			to_chat(user, "You undo the securing bolts.")
		else if(state==2)
			state = 1
			to_chat(user, "You tighten the securing bolts.")
		return
	else if(isCrowbar(W))
		if(state==2)
			state = 3
			to_chat(user, "You open the hatch to the power unit")
		else if(state==3)
			state=2
			to_chat(user, "You close the hatch to the power unit")
		return
	else if(isCoil(W))
		if(state == 3 && hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
			var/obj/item/stack/cable_coil/CC = W
			if(CC.use(2))
				clearInternalDamage(MECHA_INT_SHORT_CIRCUIT)
				to_chat(user, "You replace the fused wires.")
			else
				to_chat(user, "There's not enough wire to finish the task.")
		return
	else if(isScrewdriver(W))
		if(hasInternalDamage(MECHA_INT_TEMP_CONTROL))
			clearInternalDamage(MECHA_INT_TEMP_CONTROL)
			to_chat(user, "You repair the damaged temperature controller.")
		else if(state==3 && src.cell)
			src.cell.forceMove(src.loc)
			src.cell = null
			state = 4
			to_chat(user, "You unscrew and pry out the powercell.")
			src.log_message("Powercell removed.")
		else if(state==4 && src.cell)
			state=3
			to_chat(user, "You screw the cell in place.")
		return

	else if(isMultitool(W))
		if(state>=3 && src.occupant)
			to_chat(user, "You attempt to eject the pilot using the maintenance controls.")
			if(src.occupant.stat)
				src.go_out()
				src.log_message("[src.occupant] was ejected using the maintenance controls.")
			else
				to_chat(user, "<span class='warning'>Your attempt is rejected.</span>")
				src.occupant_message("<span class='warning'>An attempt to eject you was made using the maintenance controls.</span>")
				src.log_message("Eject attempt made using maintenance controls - rejected.")
		return

	else if(istype(W, /obj/item/weapon/cell))
		if(state==4)
			if(!src.cell)
				to_chat(user, "You install the powercell")
				user.drop_item()
				W.forceMove(src)
				src.cell = W
				src.log_message("Powercell installed")
			else
				to_chat(user, "There's already a powercell installed.")
		return

	else if(isWelder(W) && user.a_intent != I_HURT)
		var/obj/item/weapon/weldingtool/WT = W
		if (WT.remove_fuel(0,user))
			if (hasInternalDamage(MECHA_INT_TANK_BREACH))
				clearInternalDamage(MECHA_INT_TANK_BREACH)
				to_chat(user, "<span class='notice'>You repair the damaged gas tank.</span>")
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		else
			return
		if(src.health<initial(src.health))
			to_chat(user, "<span class='notice'>You repair some damage to [src.name].</span>")
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			src.health += min(10, initial(src.health)-src.health)
		else
			to_chat(user, "The [src.name] is at full integrity")
		return

	else if(istype(W, /obj/item/mecha_parts/mecha_tracking))
		user.drop_from_inventory(W)
		W.forceMove(src)
		user.visible_message("[user] attaches [W] to [src].", "You attach [W] to [src]")
		return

	else
		src.log_message("Attacked by [W]. Attacker - [user]")

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(deflect_hit(is_melee=1))
			to_chat(user, "<span class='danger'>\The [W] bounces off [src.name].</span>")
			src.log_append_to_last("Armor saved.")
		else
			src.occupant_message("<font color='red'><b>[user] hits [src] with [W].</b></font>")
			user.visible_message("<font color='red'><b>[user] hits [src] with [W].</b></font>", "<font color='red'><b>You hit [src] with [W].</b></font>")
			src.hit_damage(W.force, W.damtype, is_melee=1)
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))

	return

/*
/obj/mecha/attack_ai(var/mob/living/silicon/ai/user as mob)
	if(!istype(user, /mob/living/silicon/ai))
		return
	var/output = {"<b>Assume direct control over [src]?</b>
						<a href='?src=\ref[src];ai_take_control=\ref[user];duration=3000'>Yes</a><br>
						"}
	user << browse(output, "window=mecha_attack_ai")
	return
*/

/////////////////////////////////////
////////  Atmospheric stuff  ////////
/////////////////////////////////////

/obj/mecha/proc/get_turf_air()
	var/turf/T = get_turf(src)
	if(T)
		. = T.return_air()
	return

/obj/mecha/remove_air(amount)
	if(use_internal_tank)
		return cabin_air.remove(amount)
	else
		var/turf/T = get_turf(src)
		if(T)
			return T.remove_air(amount)
	return

/obj/mecha/return_air()
	if(use_internal_tank)
		return cabin_air
	return get_turf_air()

/obj/mecha/proc/return_pressure()
	. = 0
	if(use_internal_tank)
		. =  cabin_air.return_pressure()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.return_pressure()
	return

//skytodo: //No idea what you want me to do here, mate.
/obj/mecha/proc/return_temperature()
	. = 0
	if(use_internal_tank)
		. = cabin_air.temperature
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.temperature
	return

/obj/mecha/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != src.loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !(internal_tank.return_air() in network.gases))
		network.gases += internal_tank.return_air()
		network.update = 1
	log_message("Connected to gas port.")
	return 1

/obj/mecha/proc/disconnect()
	if(!connected_port)
		return 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= internal_tank.return_air()

	connected_port.connected_device = null
	connected_port = null
	src.log_message("Disconnected from gas port.")
	return 1


/////////////////////////
////////  Verbs  ////////
/////////////////////////


/obj/mecha/verb/connect_to_port()
	set name = "Connect to port"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(!src.occupant) return
	if(usr!=src.occupant)
		return
	var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector/) in loc
	if(possible_port)
		if(connect(possible_port))
			src.occupant_message("<span class='notice'>\The [name] connects to the port.</span>")
			src.verbs += /obj/mecha/verb/disconnect_from_port
			src.verbs -= /obj/mecha/verb/connect_to_port
			return
		else
			src.occupant_message("<span class='danger'>\The [name] failed to connect to the port.</span>")
			return
	else
		src.occupant_message("Nothing happens")


/obj/mecha/verb/disconnect_from_port()
	set name = "Disconnect from port"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(!src.occupant) return
	if(usr!=src.occupant)
		return
	if(disconnect())
		src.occupant_message("<span class='notice'>[name] disconnects from the port.</span>")
		src.verbs -= /obj/mecha/verb/disconnect_from_port
		src.verbs += /obj/mecha/verb/connect_to_port
	else
		src.occupant_message("<span class='danger'>[name] is not connected to the port at the moment.</span>")

/obj/mecha/verb/toggle_lights()
	set name = "Toggle Lights"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=occupant)	return
	lights = !lights
	if(lights)	set_light(0.6, 1, 6,)
	else		set_light(0)
	src.occupant_message("Toggled lights [lights?"on":"off"].")
	log_message("Toggled lights [lights?"on":"off"].")
	return


/obj/mecha/verb/toggle_internal_tank()
	set name = "Toggle internal airtank usage."
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	use_internal_tank = !use_internal_tank
	src.occupant_message("Now taking air from [use_internal_tank?"internal airtank":"environment"].")
	src.log_message("Now taking air from [use_internal_tank?"internal airtank":"environment"].")
	return


/obj/mecha/verb/move_inside()
	set category = "Object"
	set name = "Enter Exosuit"
	set src in oview(1)

	if (usr.stat || !ishuman(usr))
		return

	if (usr.buckled)
		to_chat(usr, "<span class='warning'>You can't climb into the exosuit while buckled!</span>")
		return

	src.log_message("[usr] tries to move in.")
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.handcuffed)
			to_chat(usr, "<span class='danger'>Kinda hard to climb in while handcuffed don't you think?</span>")
			return
	if (src.occupant)
		to_chat(usr, "<span class='danger'>The [src.name] is already occupied!</span>")
		src.log_append_to_last("Permission denied.")
		return
/*
	if (usr.abiotic())
		to_chat(usr, "<span class='notice'>Subject cannot have abiotic items on.</span>")
		return
*/
	var/passed
	if(src.dna)
		if(usr.dna.unique_enzymes==src.dna)
			passed = 1
	else if(src.operation_allowed(usr))
		passed = 1
	if(!passed)
		to_chat(usr, "<span class='warning'>Access denied</span>")
		src.log_append_to_last("Permission denied.")
		return
	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.Victim == usr)
			to_chat(usr, "You're too busy getting your life sucked out of you.")
			return
//	to_chat(usr, "You start climbing into [src.name]")

	visible_message("<span class='notice'>\The [usr] starts to climb into [src.name]</span>")

	if(enter_after(40,usr))
		if(!src.occupant)
			moved_inside(usr)
		else if(src.occupant!=usr)
			to_chat(usr, "[src.occupant] was faster. Try better next time, loser.")
	else
		to_chat(usr, "You stop entering the exosuit.")
	return

/obj/mecha/proc/moved_inside(var/mob/living/carbon/human/H as mob)
	if(H && H.client && H in range(1))
		H.reset_view(src)
		/*
		H.client.perspective = EYE_PERSPECTIVE
		H.client.eye = src
		*/
		H.stop_pulling()
		H.forceMove(src)
		src.occupant = H
		src.add_fingerprint(H)
		src.forceMove(src.loc)
		src.log_append_to_last("[H] moved in as pilot.")
		src.icon_state = src.reset_icon()
		set_dir(dir_in)
		playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
		if(!hasInternalDamage())
			to_chat(src.occupant, sound('sound/mecha/nominal.ogg',volume=50))
		return 1
	else
		return 0

/obj/mecha/verb/view_stats()
	set name = "View Stats"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	//pr_update_stats.start()
	src.occupant << browse(src.get_stats_html(), "window=exosuit")
	return

/*
/obj/mecha/verb/force_eject()
	set category = "Object"
	set name = "Force Eject"
	set src in view(5)
	src.go_out()
	return
*/

/obj/mecha/verb/eject()
	set name = "Eject"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	src.go_out()
	add_fingerprint(usr)
	return


/obj/mecha/proc/go_out()
	if(!src.occupant) return
	var/atom/movable/mob_container
	if(ishuman(occupant))
		mob_container = src.occupant
	else if(istype(occupant, /mob/living/carbon/brain))
		var/mob/living/carbon/brain/brain = occupant
		mob_container = brain.container
	else
		return
	for(var/item in dropped_items)
		var/atom/movable/I = item
		I.forceMove(loc)
	dropped_items.Cut()
	if(mob_container.forceMove(src.loc))//ejecting mob container
	/*
		if(ishuman(occupant) && (return_pressure() > HAZARD_HIGH_PRESSURE))
			use_internal_tank = 0
			var/datum/gas_mixture/environment = get_turf_air()
			if(environment)
				var/env_pressure = environment.return_pressure()
				var/pressure_delta = (cabin.return_pressure() - env_pressure)
		//Can not have a pressure delta that would cause environment pressure > tank pressure

				var/transfer_moles = 0
				if(pressure_delta > 0)
					transfer_moles = pressure_delta*environment.volume/(cabin.return_temperature() * R_IDEAL_GAS_EQUATION)

			//Actually transfer the gas
					var/datum/gas_mixture/removed = cabin.air_contents.remove(transfer_moles)
					loc.assume_air(removed)

			occupant.SetStunned(5)
			occupant.SetWeakened(5)
			to_chat(occupant, "You were blown out of the mech!")
	*/
		src.log_message("[mob_container] moved out.")
		occupant.reset_view()
		/*
		if(src.occupant.client)
			src.occupant.client.eye = src.occupant.client.mob
			src.occupant.client.perspective = MOB_PERSPECTIVE
		*/
		src.occupant << browse(null, "window=exosuit")
		if(istype(mob_container, /obj/item/device/mmi))
			var/obj/item/device/mmi/mmi = mob_container
			if(mmi.brainmob)
				occupant.loc = mmi
			mmi.mecha = null
			src.occupant.canmove = 0
			src.verbs += /obj/mecha/verb/eject
		src.occupant = null
		src.icon_state = src.reset_icon()+"-open"
		src.set_dir(dir_in)
	return

/////////////////////////
////// Access stuff /////
/////////////////////////

/obj/mecha/proc/operation_allowed(mob/living/carbon/human/H)
	for(var/ID in list(H.get_active_hand(), H.wear_id, H.belt))
		if(src.check_access(ID,src.operation_req_access))
			return 1
	return 0


/obj/mecha/proc/internals_access_allowed(mob/living/carbon/human/H)
	for(var/atom/ID in list(H.get_active_hand(), H.wear_id, H.belt))
		if(src.check_access(ID,src.internals_req_access))
			return 1
	return 0


/obj/mecha/check_access(obj/item/weapon/card/id/I, list/access_list)
	if(!istype(access_list))
		return 1
	if(!access_list.len) //no requirements
		return 1
	I = I.GetIdCard()
	if(!istype(I) || !I.access) //not ID or no access
		return 0
	if(access_list==src.operation_req_access)
		for(var/req in access_list)
			if(!(req in I.access)) //doesn't have this access
				return 0
	else if(access_list==src.internals_req_access)
		for(var/req in access_list)
			if(req in I.access)
				return 1
	return 1


////////////////////////////////////
///// Rendering stats window ///////
////////////////////////////////////

/obj/mecha/proc/get_stats_html()
	var/output = {"<html>
						<head><title>[src.name] data</title>
						<style>
						body {color: #00ff00; background: #000000; font-family:"Lucida Console",monospace; font-size: 12px;}
						hr {border: 1px solid #0f0; color: #0f0; background-color: #0f0;}
						a {padding:2px 5px;;color:#0f0;}
						.wr {margin-bottom: 5px;}
						.header {cursor:pointer;}
						.open, .closed {background: #32cd32; color:#000; padding:1px 2px;}
						.links a {margin-bottom: 2px;padding-top:3px;}
						.visible {display: block;}
						.hidden {display: none;}
						</style>
						<script language='javascript' type='text/javascript'>
						[js_byjax]
						[js_dropdowns]
						function ticker() {
						    setInterval(function(){
						        window.location='byond://?src=\ref[src]&update_content=1';
						    }, 1000);
						}

						window.onload = function() {
							dropdowns();
							ticker();
						}
						</script>
						</head>
						<body>
						<div id='content'>
						[src.get_stats_part()]
						</div>
						<div id='eq_list'>
						[src.get_equipment_list()]
						</div>
						<hr>
						<div id='commands'>
						[src.get_commands()]
						</div>
						</body>
						</html>
					 "}
	return output


/obj/mecha/proc/report_internal_damage()
	var/output = null
	var/list/dam_reports = list(
										"[MECHA_INT_FIRE]" = "<font color='red'><b>INTERNAL FIRE</b></font>",
										"[MECHA_INT_TEMP_CONTROL]" = "<font color='red'><b>LIFE SUPPORT SYSTEM MALFUNCTION</b></font>",
										"[MECHA_INT_TANK_BREACH]" = "<font color='red'><b>GAS TANK BREACH</b></font>",
										"[MECHA_INT_CONTROL_LOST]" = "<font color='red'><b>COORDINATION SYSTEM CALIBRATION FAILURE</b></font> - <a href='?src=\ref[src];repair_int_control_lost=1'>Recalibrate</a>",
										"[MECHA_INT_SHORT_CIRCUIT]" = "<font color='red'><b>SHORT CIRCUIT</b></font>"
										)
	for(var/tflag in dam_reports)
		var/intdamflag = text2num(tflag)
		if(hasInternalDamage(intdamflag))
			output += dam_reports[tflag]
			output += "<br />"
	if(return_pressure() > WARNING_HIGH_PRESSURE)
		output += "<font color='red'><b>DANGEROUSLY HIGH CABIN PRESSURE</b></font><br />"
	return output


/obj/mecha/proc/get_stats_part()
	var/integrity = health/initial(health)*100
	var/cell_charge = get_charge()
	var/tank_pressure = internal_tank ? round(internal_tank.return_pressure(),0.01) : "None"
	var/tank_temperature = internal_tank ? internal_tank.return_temperature() : "Unknown" //Results in type mismatch if there is no tank.
	var/cabin_pressure = round(return_pressure(),0.01)
	var/output = {"[report_internal_damage()]
						[integrity<30?"<font color='red'><b>DAMAGE LEVEL CRITICAL</b></font><br>":null]
						<b>Integrity: </b> [integrity]%<br>
						<b>Powercell charge: </b>[isnull(cell_charge)?"No powercell installed":"[cell.percent()]%"]<br>
						<b>Air source: </b>[use_internal_tank?"Internal Airtank":"Environment"]<br>
						<b>Airtank pressure: </b>[tank_pressure]kPa<br>
						<b>Airtank temperature: </b>[tank_temperature]K|[isnum(tank_temperature) ? "tank_temperature - T0C&deg;C" : ""]<br>
						<b>Cabin pressure: </b>[cabin_pressure>WARNING_HIGH_PRESSURE ? "<font color='red'>[cabin_pressure]</font>": cabin_pressure]kPa<br>
						<b>Cabin temperature: </b> [return_temperature()]K|[return_temperature() - T0C]&deg;C<br>
						<b>Lights: </b>[lights?"on":"off"]<br>
						[src.dna?"<b>DNA-locked:</b><br> <span style='font-size:10px;letter-spacing:-1px;'>[src.dna]</span> \[<a href='?src=\ref[src];reset_dna=1'>Reset</a>\]<br>":null]
					"}
	return output

/obj/mecha/proc/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Electronics</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_lights=1'>Toggle Lights</a><br>
						<b>Radio settings:</b><br>
						Microphone: <a href='?src=\ref[src];rmictoggle=1'><span id="rmicstate">[radio.broadcasting?"Engaged":"Disengaged"]</span></a><br>
						Speaker: <a href='?src=\ref[src];rspktoggle=1'><span id="rspkstate">[radio.listening?"Engaged":"Disengaged"]</span></a><br>
						Frequency:
						<a href='?src=\ref[src];rfreq=-10'>-</a>
						<a href='?src=\ref[src];rfreq=-2'>-</a>
						<span id="rfreq">[format_frequency(radio.frequency)]</span>
						<a href='?src=\ref[src];rfreq=2'>+</a>
						<a href='?src=\ref[src];rfreq=10'>+</a><br>
						</div>
						</div>
						<div class='wr'>
						<div class='header'>Airtank</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_airtank=1'>Toggle Internal Airtank Usage</a><br>
						[(/obj/mecha/verb/disconnect_from_port in src.verbs)?"<a href='?src=\ref[src];port_disconnect=1'>Disconnect from port</a><br>":null]
						[(/obj/mecha/verb/connect_to_port in src.verbs)?"<a href='?src=\ref[src];port_connect=1'>Connect to port</a><br>":null]
						</div>
						</div>
						<div class='wr'>
						<div class='header'>Permissions & Logging</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_id_upload=1'><span id='t_id_upload'>[add_req_access?"L":"Unl"]ock ID upload panel</span></a><br>
						<a href='?src=\ref[src];toggle_maint_access=1'><span id='t_maint_access'>[maint_access?"Forbid":"Permit"] maintenance protocols</span></a><br>
						<a href='?src=\ref[src];dna_lock=1'>DNA-lock</a><br>
						<a href='?src=\ref[src];view_log=1'>View internal log</a><br>
						<a href='?src=\ref[src];change_name=1'>Change exosuit name</a><br>
						</div>
						</div>
						<div id='equipment_menu'>[get_equipment_menu()]</div>
						<hr>
						[(/obj/mecha/verb/eject in src.verbs)?"<a href='?src=\ref[src];eject=1'>Eject</a><br>":null]
						"}
	return output

/obj/mecha/proc/get_equipment_menu() //outputs mecha html equipment menu
	var/output
	if(equipment.len)
		output += {"<div class='wr'>
						<div class='header'>Equipment</div>
						<div class='links'>"}
		for(var/obj/item/mecha_parts/mecha_equipment/W in equipment)
			output += "[W.name] <a href='?src=\ref[W];detach=1'>Detach</a><br>"
		output += "<b>Available equipment slots:</b> [max_equip-equipment.len]"
		output += "</div></div>"
	return output

/obj/mecha/proc/get_equipment_list() //outputs mecha equipment list in html
	if(!equipment.len)
		return
	var/output = "<b>Equipment:</b><div style=\"margin-left: 15px;\">"
	for(var/obj/item/mecha_parts/mecha_equipment/MT in equipment)
		output += "<div id='\ref[MT]'>[MT.get_equip_info()]</div>"
	output += "</div>"
	return output


/obj/mecha/proc/get_log_html()
	var/output = "<html><head><title>[src.name] Log</title></head><body style='font: 13px 'Courier', monospace;'>"
	for(var/list/entry in log)
		output += {"<div style='font-weight: bold;'>[time2text(entry["time"],"DDD MMM DD hh:mm:ss")] [game_year]</div>
						<div style='margin-left:15px; margin-bottom:10px;'>[entry["message"]]</div>
						"}
	output += "</body></html>"
	return output


/obj/mecha/proc/output_access_dialog(obj/item/weapon/card/id/id_card, mob/user)
	if(!id_card || !user) return
	var/output = {"<html>
						<head><style>
						h1 {font-size:15px;margin-bottom:4px;}
						body {color: #00ff00; background: #000000; font-family:"Courier New", Courier, monospace; font-size: 12px;}
						a {color:#0f0;}
						</style>
						</head>
						<body>
						<h1>Following keycodes are present in this system:</h1>"}
	for(var/a in operation_req_access)
		output += "[get_access_desc(a)] - <a href='?src=\ref[src];del_req_access=[a];user=\ref[user];id_card=\ref[id_card]'>Delete</a><br>"
	output += "<hr><h1>Following keycodes were detected on portable device:</h1>"
	for(var/a in id_card.access)
		if(a in operation_req_access) continue
		var/a_name = get_access_desc(a)
		if(!a_name) continue //there's some strange access without a name
		output += "[a_name] - <a href='?src=\ref[src];add_req_access=[a];user=\ref[user];id_card=\ref[id_card]'>Add</a><br>"
	output += "<hr><a href='?src=\ref[src];finish_req_access=1;user=\ref[user]'>Finish</a> <font color='red'>(Warning! The ID upload panel will be locked. It can be unlocked only through Exosuit Interface.)</font>"
	output += "</body></html>"
	user << browse(output, "window=exosuit_add_access")
	onclose(user, "exosuit_add_access")
	return

/obj/mecha/proc/output_maintenance_dialog(obj/item/weapon/card/id/id_card,mob/user)
	if(!id_card || !user) return

	var/maint_options = "<a href='?src=\ref[src];set_internal_tank_valve=1;user=\ref[user]'>Set Cabin Air Pressure</a>"
	if (locate(/obj/item/mecha_parts/mecha_equipment/tool/passenger) in contents)
		maint_options += "<a href='?src=\ref[src];remove_passenger=1;user=\ref[user]'>Remove Passenger</a>"

	var/output = {"<html>
						<head>
						<style>
						body {color: #00ff00; background: #000000; font-family:"Courier New", Courier, monospace; font-size: 12px;}
						a {padding:2px 5px; background:#32cd32;color:#000;display:block;margin:2px;text-align:center;text-decoration:none;}
						</style>
						</head>
						<body>
						[add_req_access?"<a href='?src=\ref[src];req_access=1;id_card=\ref[id_card];user=\ref[user]'>Edit operation keycodes</a>":null]
						[maint_access?"<a href='?src=\ref[src];maint_access=1;id_card=\ref[id_card];user=\ref[user]'>Initiate maintenance protocol</a>":null]
						[(state>0) ? maint_options : ""]
						</body>
						</html>"}
	user << browse(output, "window=exosuit_maint_console")
	onclose(user, "exosuit_maint_console")
	return


////////////////////////////////
/////// Messages and Log ///////
////////////////////////////////

/obj/mecha/proc/occupant_message(message as text)
	if(message)
		if(src.occupant && src.occupant.client)
			to_chat(src.occupant, "\icon[src] [message]")
	return

/obj/mecha/proc/log_message(message as text,red=null)
	log.len++
	log[log.len] = list("time"=world.timeofday,"message"="[red?"<font color='red'>":null][message][red?"</font>":null]")
	return log.len

/obj/mecha/proc/log_append_to_last(message as text,red=null)
	var/list/last_entry = src.log[src.log.len]
	last_entry["message"] += "<br>[red?"<font color='red'>":null][message][red?"</font>":null]"
	return


/////////////////
///// Topic /////
/////////////////

/obj/mecha/Topic(href, href_list)
	..()
	if(href_list["update_content"])
		if(usr != src.occupant)	return
		send_byjax(src.occupant,"exosuit.browser","content",src.get_stats_part())
		return
	if(href_list["close"])
		return
	if(usr.stat > 0)
		return
	var/datum/topic_input/F = new /datum/topic_input(href,href_list)
	if(href_list["select_equip"])
		if(usr != src.occupant)	return
		var/obj/item/mecha_parts/mecha_equipment/equip = F.getObj("select_equip")
		if(equip)
			src.selected = equip
			src.occupant_message("You switch to [equip]")
			src.visible_message("[src] raises [equip]")
			send_byjax(src.occupant,"exosuit.browser","eq_list",src.get_equipment_list())
		return
	if(href_list["eject"])
		if(usr != src.occupant)	return
		src.eject()
		return
	if(href_list["toggle_lights"])
		if(usr != src.occupant)	return
		src.toggle_lights()
		return
	if(href_list["toggle_airtank"])
		if(usr != src.occupant)	return
		src.toggle_internal_tank()
		return
	if(href_list["rmictoggle"])
		if(usr != src.occupant)	return
		radio.broadcasting = !radio.broadcasting
		send_byjax(src.occupant,"exosuit.browser","rmicstate",(radio.broadcasting?"Engaged":"Disengaged"))
		return
	if(href_list["rspktoggle"])
		if(usr != src.occupant)	return
		radio.listening = !radio.listening
		send_byjax(src.occupant,"exosuit.browser","rspkstate",(radio.listening?"Engaged":"Disengaged"))
		return
	if(href_list["rfreq"])
		if(usr != src.occupant)	return
		var/new_frequency = (radio.frequency + F.getNum("rfreq"))
		if ((radio.frequency < PUBLIC_LOW_FREQ || radio.frequency > PUBLIC_HIGH_FREQ))
			new_frequency = sanitize_frequency(new_frequency)
		radio.set_frequency(new_frequency)
		send_byjax(src.occupant,"exosuit.browser","rfreq","[format_frequency(radio.frequency)]")
		return
	if(href_list["port_disconnect"])
		if(usr != src.occupant)	return
		src.disconnect_from_port()
		return
	if (href_list["port_connect"])
		if(usr != src.occupant)	return
		src.connect_to_port()
		return
	if (href_list["view_log"])
		if(usr != src.occupant)	return
		src.occupant << browse(src.get_log_html(), "window=exosuit_log")
		onclose(occupant, "exosuit_log")
		return
	if (href_list["change_name"])
		if(usr != src.occupant)	return
		var/newname = sanitizeSafe(input(occupant,"Choose new exosuit name","Rename exosuit",initial(name)) as text, MAX_NAME_LEN)
		if(newname)
			SetName(newname)
		else
			alert(occupant, "nope.avi")
		return
	if (href_list["toggle_id_upload"])
		if(usr != src.occupant)	return
		add_req_access = !add_req_access
		send_byjax(src.occupant,"exosuit.browser","t_id_upload","[add_req_access?"L":"Unl"]ock ID upload panel")
		return
	if(href_list["toggle_maint_access"])
		if(usr != src.occupant)	return
		if(state)
			occupant_message("<font color='red'>Maintenance protocols in effect</font>")
			return
		maint_access = !maint_access
		send_byjax(src.occupant,"exosuit.browser","t_maint_access","[maint_access?"Forbid":"Permit"] maintenance protocols")
		return
	if(href_list["req_access"] && add_req_access)
		if(!in_range(src, usr))	return
		output_access_dialog(F.getObj("id_card"),F.getMob("user"))
		return
	if(href_list["maint_access"] && maint_access)
		if(!in_range(src, usr))	return
		var/mob/user = F.getMob("user")
		if(user)
			if(state==0)
				state = 1
				to_chat(user, "The securing bolts are now exposed.")
			else if(state==1)
				state = 0
				to_chat(user, "The securing bolts are now hidden.")
			output_maintenance_dialog(F.getObj("id_card"),user)
		return
	if(href_list["set_internal_tank_valve"] && state >=1)
		if(!in_range(src, usr))	return
		var/mob/user = F.getMob("user")
		if(user)
			var/new_pressure = input(user,"Input new output pressure","Pressure setting",internal_tank_valve) as num
			if(new_pressure)
				internal_tank_valve = new_pressure
				to_chat(user, "The internal pressure valve has been set to [internal_tank_valve]kPa.")
	if(href_list["remove_passenger"] && state >= 1)
		var/mob/user = F.getMob("user")
		var/list/passengers = list()
		for (var/obj/item/mecha_parts/mecha_equipment/tool/passenger/P in contents)
			if (P.occupant)
				passengers["[P.occupant]"] = P

		if (!passengers)
			to_chat(user, "<span class='warning'>There are no passengers to remove.</span>")
			return

		var/pname = input(user, "Choose a passenger to forcibly remove.", "Forcibly Remove Passenger") as null|anything in passengers

		if (!pname)
			return

		var/obj/item/mecha_parts/mecha_equipment/tool/passenger/P = passengers[pname]
		var/mob/occupant = P.occupant

		user.visible_message("<span class='notice'>\The [user] begins opening the hatch on \the [P]...</span>", "<span class='notice'>You begin opening the hatch on \the [P]...</span>")
		if (!do_after(user, 40, needhand=0))
			return

		user.visible_message("<span class='notice'>\The [user] opens the hatch on \the [P] and removes [occupant]!</span>", "<span class='notice'>You open the hatch on \the [P] and remove [occupant]!</span>")
		P.go_out()
		P.log_message("[occupant] was removed.")
		return
	if(href_list["add_req_access"] && add_req_access && F.getObj("id_card"))
		if(!in_range(src, usr))	return
		operation_req_access += F.getNum("add_req_access")
		output_access_dialog(F.getObj("id_card"),F.getMob("user"))
		return
	if(href_list["del_req_access"] && add_req_access && F.getObj("id_card"))
		if(!in_range(src, usr))	return
		operation_req_access -= F.getNum("del_req_access")
		output_access_dialog(F.getObj("id_card"),F.getMob("user"))
		return
	if(href_list["finish_req_access"])
		if(!in_range(src, usr))	return
		add_req_access = 0
		var/mob/user = F.getMob("user")
		user << browse(null,"window=exosuit_add_access")
		return
	if(href_list["dna_lock"])
		if(usr != src.occupant)	return
		if(istype(occupant, /mob/living/carbon/brain))
			occupant_message("You are a brain. No.")
			return
		if(src.occupant)
			src.dna = src.occupant.dna.unique_enzymes
			src.occupant_message("You feel a prick as the needle takes your DNA sample.")
		return
	if(href_list["reset_dna"])
		if(usr != src.occupant)	return
		src.dna = null
	if(href_list["repair_int_control_lost"])
		if(usr != src.occupant)	return
		src.occupant_message("Recalibrating coordination system.")
		src.log_message("Recalibration of coordination system started.")
		var/T = src.loc
		if(do_after(100))
			if(T == src.loc)
				src.clearInternalDamage(MECHA_INT_CONTROL_LOST)
				src.occupant_message("<font color='blue'>Recalibration successful.</font>")
				src.log_message("Recalibration of coordination system finished with 0 errors.")
			else
				src.occupant_message("<font color='red'>Recalibration failed.</font>")
				src.log_message("Recalibration of coordination system failed with 1 error.",1)

	//debug
	/*
	if(href_list["debug"])
		if(href_list["set_i_dam"])
			setInternalDamage(F.getNum("set_i_dam"))
		if(href_list["clear_i_dam"])
			clearInternalDamage(F.getNum("clear_i_dam"))
		return
	*/



/*

	if (href_list["ai_take_control"])
		var/mob/living/silicon/ai/AI = locate(href_list["ai_take_control"])
		var/duration = text2num(href_list["duration"])
		var/mob/living/silicon/ai/O = new /mob/living/silicon/ai(src)
		var/cur_occupant = src.occupant
		O.invisibility = 0
		O.canmove = 1
		O.SetName(AI.name)
		O.real_name = AI.real_name
		O.anchored = 1
		O.aiRestorePowerRoutine = 0
		O.control_disabled = 1 // Can't control things remotely if you're stuck in a card!
		O.laws = AI.laws
		O.set_stat(AI.stat)
		O.oxyloss = AI.getOxyLoss()
		O.fireloss = AI.getFireLoss()
		O.bruteloss = AI.getBruteLoss()
		O.toxloss = AI.toxloss
		O.updatehealth()
		src.occupant = O
		if(AI.mind)
			AI.mind.transfer_to(O)
		AI.SetName("Inactive AI")
		AI.real_name = "Inactive AI"
		AI.icon_state = "ai-empty"
		spawn(duration)
			AI.SetName(O.name)
			AI.real_name = O.real_name
			if(O.mind)
				O.mind.transfer_to(AI)
			AI.control_disabled = 0
			AI.laws = O.laws
			AI.oxyloss = O.getOxyLoss()
			AI.fireloss = O.getFireLoss()
			AI.bruteloss = O.getBruteLoss()
			AI.toxloss = O.toxloss
			AI.updatehealth()
			qdel(O)
			if (!AI.stat)
				AI.icon_state = "ai"
			else
				AI.icon_state = "ai-crash"
			src.occupant = cur_occupant
*/
	return

///////////////////////
///// Power stuff /////
///////////////////////

/obj/mecha/proc/has_charge(amount)
	return (get_charge()>=amount)

/obj/mecha/proc/get_charge()
	if(!src.cell)
		return
	return max(0, src.cell.charge / CELLRATE)

/obj/mecha/proc/use_power(amount)
	if(get_charge())
		cell.use(amount * CELLRATE)
		return 1
	return 0

/obj/mecha/proc/give_power(amount)
	if(!isnull(get_charge()))
		cell.give(amount * CELLRATE)
		return 1
	return 0

/obj/mecha/proc/reset_icon()
	if (initial_icon)
		icon_state = initial_icon
	else
		icon_state = initial(icon_state)
	return icon_state

/obj/mecha/attack_generic(var/mob/user, var/damage, var/attack_message)

	if(!damage)
		return 0

	src.log_message("Attacked. Attacker - [user].",1)

	user.do_attack_animation(src)
	if(!deflect_hit(is_melee=1))
		src.hit_damage(damage, is_melee=1)
		src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		visible_message("<span class='danger'>[user] [attack_message] [src]!</span>")
		admin_attacker_log(user, "attacked \the [src]")
	else
		src.log_append_to_last("Armor saved.")
		playsound(src.loc, 'sound/weapons/slash.ogg', 50, 1, -1)
		src.occupant_message("<span class='notice'>\The [user]'s attack is stopped by the armor.</span>")
		visible_message("<span class='notice'>\The [user] rebounds off [src.name]'s armor!</span>")
		admin_attacker_log(user, "attacked \the [src] but rebounded")
	return 1

/obj/mecha/onDropInto(var/atom/movable/AM)
	dropped_items |= AM

//////////////////////////////////////////
////////  Mecha global iterators  ////////
//////////////////////////////////////////


/datum/global_iterator/mecha_preserve_temp  //normalizing cabin air temperature to 20 degrees celsius
	delay = 20

	process(var/obj/mecha/mecha)
		if(mecha.cabin_air && mecha.cabin_air.volume > 0)
			var/delta = mecha.cabin_air.temperature - T20C
			mecha.cabin_air.temperature -= max(-10, min(10, round(delta/4,0.1)))
		return

/datum/global_iterator/mecha_tank_give_air
	delay = 15

	process(var/obj/mecha/mecha)
		if(mecha.internal_tank)
			var/datum/gas_mixture/tank_air = mecha.internal_tank.return_air()
			var/datum/gas_mixture/cabin_air = mecha.cabin_air

			var/release_pressure = mecha.internal_tank_valve
			var/cabin_pressure = cabin_air.return_pressure()
			var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
			var/transfer_moles = 0
			if(pressure_delta > 0) //cabin pressure lower than release pressure
				if(tank_air.temperature > 0)
					transfer_moles = pressure_delta*cabin_air.volume/(cabin_air.temperature * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
					cabin_air.merge(removed)
			else if(pressure_delta < 0) //cabin pressure higher than release pressure
				var/datum/gas_mixture/t_air = mecha.get_turf_air()
				pressure_delta = cabin_pressure - release_pressure
				if(t_air)
					pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
				if(pressure_delta > 0) //if location pressure is lower than cabin pressure
					transfer_moles = pressure_delta*cabin_air.volume/(cabin_air.temperature * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
					if(t_air)
						t_air.merge(removed)
					else //just delete the cabin gas, we're in space or some shit
						qdel(removed)
		else
			return stop()
		return

/datum/global_iterator/mecha_inertial_movement //inertial movement in space
	delay = 7

	process(var/obj/mecha/mecha as obj,direction)
		if(direction)
			if(!step(mecha, direction)||mecha.check_for_support())
				src.stop()
		else
			src.stop()
		return

/datum/global_iterator/mecha_internal_damage // processing internal damage

	process(var/obj/mecha/mecha)
		if(!mecha.hasInternalDamage())
			return stop()
		if(mecha.hasInternalDamage(MECHA_INT_FIRE))
			if(!mecha.hasInternalDamage(MECHA_INT_TEMP_CONTROL) && prob(5))
				mecha.clearInternalDamage(MECHA_INT_FIRE)
			if(mecha.internal_tank)
				if(mecha.internal_tank.return_pressure()>mecha.internal_tank.maximum_pressure && !(mecha.hasInternalDamage(MECHA_INT_TANK_BREACH)))
					mecha.setInternalDamage(MECHA_INT_TANK_BREACH)
				var/datum/gas_mixture/int_tank_air = mecha.internal_tank.return_air()
				if(int_tank_air && int_tank_air.volume>0) //heat the air_contents
					int_tank_air.temperature = min(6000+T0C, int_tank_air.temperature+rand(10,15))
			if(mecha.cabin_air && mecha.cabin_air.volume>0)
				mecha.cabin_air.temperature = min(6000+T0C, mecha.cabin_air.temperature+rand(10,15))
				if(mecha.cabin_air.temperature>mecha.max_temperature/2)
					mecha.take_damage(4/round(mecha.max_temperature/mecha.cabin_air.temperature,0.1),"fire")
		if(mecha.hasInternalDamage(MECHA_INT_TEMP_CONTROL)) //stop the mecha_preserve_temp loop datum
			mecha.pr_int_temp_processor.stop()
		if(mecha.hasInternalDamage(MECHA_INT_TANK_BREACH)) //remove some air from internal tank
			if(mecha.internal_tank)
				var/datum/gas_mixture/int_tank_air = mecha.internal_tank.return_air()
				var/datum/gas_mixture/leaked_gas = int_tank_air.remove_ratio(0.10)
				if(mecha.loc && hascall(mecha.loc,"assume_air"))
					mecha.loc.assume_air(leaked_gas)
				else
					qdel(leaked_gas)
		if(mecha.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
			if(mecha.get_charge())
				mecha.spark_system.start()
				mecha.use_power(rand(1 KILOWATTS, 5 KILOWATTS))
		return


/////////////

//debug
/*
/obj/mecha/verb/test_int_damage()
	set name = "Test internal damage"
	set category = "Exosuit Interface"
	set src in view(0)
	if(!occupant) return
	if(usr!=occupant)
		return
	var/output = {"<html>
						<head>
						</head>
						<body>
						<h3>Set:</h3>
						<a href='?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_FIRE]'>MECHA_INT_FIRE</a><br />
						<a href='?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_TEMP_CONTROL]'>MECHA_INT_TEMP_CONTROL</a><br />
						<a href='?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_SHORT_CIRCUIT]'>MECHA_INT_SHORT_CIRCUIT</a><br />
						<a href='?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_TANK_BREACH]'>MECHA_INT_TANK_BREACH</a><br />
						<a href='?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_CONTROL_LOST]'>MECHA_INT_CONTROL_LOST</a><br />
						<hr />
						<h3>Clear:</h3>
						<a href='?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_FIRE]'>MECHA_INT_FIRE</a><br />
						<a href='?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_TEMP_CONTROL]'>MECHA_INT_TEMP_CONTROL</a><br />
						<a href='?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_SHORT_CIRCUIT]'>MECHA_INT_SHORT_CIRCUIT</a><br />
						<a href='?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_TANK_BREACH]'>MECHA_INT_TANK_BREACH</a><br />
						<a href='?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_CONTROL_LOST]'>MECHA_INT_CONTROL_LOST</a><br />
 					   </body>
						</html>"}

	occupant << browse(output, "window=ex_debug")
	//src.health = initial(src.health)/2.2
	//src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return
*/
/obj/mecha/fall_damage()
	return 550