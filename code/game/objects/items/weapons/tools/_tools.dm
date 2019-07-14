/obj/item/weapon/tool
	name = "tool"
	icon = 'icons/obj/tools.dmi'
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	w_class = ITEM_SIZE_SMALL

	var/tool_in_use = FALSE

	var/sparks_on_use = FALSE	//Set to TRUE if you want to have sparks on each use of a tool
	var/eye_hazard = FALSE	//Set to TRUE should damage users eyes if they without eye protection

	var/use_power_cost = 0	//For tool system, determinze how much power tool will drain from cells, 0 means no cell needed
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = null	//Dont forget to edit this for a tool, if you want in to consume cells

	var/use_fuel_cost = 0	//Same, only for fuel. And for the sake of God, DONT USE CELLS AND FUEL SIMULTANEOUSLY.
	var/passive_fuel_cost = 0.03 //Fuel consumed per process tick while active
	var/max_fuel = 0

	//Third type of resource, stock. A tool that uses physical objects (or itself) in order to work
	//Currently used for tape roll
	var/use_stock_cost = 0
	var/stock = 0
	var/max_stock = 0
	var/allow_decimal_stock = TRUE
	var/delete_when_empty = TRUE


	//Variables used for tool degradation
	var/degradation = 0.08 //If nonzero, the unreliability of the tool increases by 0..this after each tool operation
	var/unreliability = 0 //This is added to the failure rate of operations with this tool
	var/repair_frequency = 0 //How many times this tool has been repaired

	var/toggleable = FALSE	//Determinze if it can be switched ON or OFF, for example, if you need a tool that will consume power/fuel upon turning it ON only. Such as welder.
	var/switched_on = FALSE	//Curent status of tool. Dont edit this in subtypes vars, its for procs only.
	var/switched_on_qualities = null	//This var will REPLACE tool_qualities when tool will be toggled on.
	var/switched_on_force = null
	var/switched_off_qualities = null	//This var will REPLACE tool_qualities when tool will be toggled off. So its possible for tool to have diferent qualities both for ON and OFF state.
	var/create_hot_spot = FALSE	 //Set this TRUE to ignite plasma on turf with tool upon activation
	var/glow_color = null	//Set color of glow upon activation, or leave it null if you dont want any light
	var/last_tooluse = 0 //When the tool was last used for a tool operation. This is set both at the start of an operation, and after the doafter call

	//Vars for tool upgrades
	var/list/upgrades = list()
	var/max_upgrades = 3
	var/precision = 0	//Subtracted from failure rates
	var/workspeed = 1	//Worktimes are divided by this
	var/extra_bulk = 0 	//Extra physicial volume added by certain mods
	var/silenced = FALSE //If true the tool makes far less noise when used
	var/list/prefixes = list()

	//Mods that come already applied on a tool
	var/list/preinstalled_mods = list()

/******************************
	/* Core Procs */
*******************************/
//Fuel and cell spawn
/obj/item/weapon/tool/New()
	..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

	if(use_fuel_cost)
		var/datum/reagents/R = new/datum/reagents(max_fuel, src)
		reagents = R
		R.add_reagent(/datum/reagent/fuel, max_fuel)

	if (use_stock_cost)
		stock = max_stock

	update_icon()
	return

/obj/item/weapon/tool/Initialize()
	..()
	for(var/modtype in preinstalled_mods)
		var/obj/item/weapon/tool_upgrade/TU = new modtype(src)
		TU.apply(src)
		TU.removeable = FALSE //Preinstalled mods are permanant

//Fuel and cell spawn
/obj/item/weapon/tool/Created()
	QDEL_NULL(cell)
	if(use_fuel_cost)
		consume_fuel(get_fuel())



//For killing processes like hot spots
/obj/item/weapon/tool/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

//Ignite plasma around, if we need it
/obj/item/weapon/tool/Process()
	if(switched_on)
		if(create_hot_spot)
			var/turf/location = get_turf(src)
			if (location)
				location.hotspot_expose(700, 5)
		if(tool_in_use && sparks_on_use && !silenced && prob(50))
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(3, 0, get_turf(src))
			sparks.start()

		if (passive_fuel_cost)
			if(!consume_fuel(passive_fuel_cost))
				turn_off()


//Cell reload
/obj/item/weapon/tool/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen) && eject_item(cell, usr)) ///Formerly checked for /obj/screeninventory/hand. Not sure how that fits with bay's UI system
		cell = null
		update_icon()
	else
		..()

/obj/item/weapon/tool/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C
		update_icon()
		return

	//Removing upgrades from a tool. Very difficult, but passing the check only gets you the perfect result
	//You can also get a lesser success (remove the upgrade but break it in the process) if you fail
	//Using a laser guided stabilised screwdriver is recommended. Precision mods will make this easier
	if (upgrades.len && C.has_quality(QUALITY_SCREW_DRIVING))
		var/list/possibles = upgrades.Copy()
		for (var/obj/item/weapon/tool_upgrade/TU in possibles)
			if (!TU.removeable)
				possibles.Remove(TU) //Some mods cannot be removed
		possibles += "Cancel"
		var/obj/item/weapon/tool_upgrade/toremove = input("Which upgrade would you like to try to remove? The upgrade will probably be destroyed in the process","Removing Upgrades") in possibles
		if (toremove == "Cancel")
			return

		if (C.use_tool(user = user, target =  src, base_time = WORKTIME_SLOW, required_quality = QUALITY_SCREW_DRIVING, fail_chance = FAILCHANCE_CHALLENGING, required_stat = "construction"))
			//If you pass the check, then you manage to remove the upgrade intact
			user << SPAN_NOTICE("You successfully remove [toremove] while leaving it intact.")
			upgrades -= toremove
			toremove.forceMove(get_turf(src))
			toremove.holder = null
			if (!toremove.recoverable)
				qdel(toremove) //Some upgrades are always lost upon removal
			refresh_upgrades()
			return 1
		else
			//You failed the check, lets see what happens
			if (prob(50))
				//50% chance to break the upgrade and remove it
				user << SPAN_DANGER("You successfully remove [toremove], but destroy it in the process.")
				upgrades -= toremove
				toremove.forceMove(get_turf(src))
				toremove.holder = null
				spawn(1)
					QDEL_NULL(toremove)
				refresh_upgrades()
				return 1
			else if (degradation) //Because robot tools are unbreakable
				//otherwise, damage the host tool a bit, and give you another try
				user << SPAN_DANGER("You only managed to damage [src], but you can retry.")
				unreliability += 10*degradation
				refresh_upgrades()
				return 1
	.=..()


//Turning it on/off
/obj/item/weapon/tool/attack_self(mob/user)
	if(toggleable)
		if (switched_on)
			turn_off(user)
		else
			turn_on(user)
	..()
	return

//Damaged tools are worth less matter for recycling
/obj/item/weapon/tool/get_matter()
	if (!matter || !matter.len || !degradation)
		return ..()

	//If it's this broken, you get nothing
	if (unreliability >= 50)
		return null

	var/list/tm = matter.Copy()
	//Every point of damage reduces matter by 2% of total
	for (var/mat in tm)
		tm[mat] *= 1 - (unreliability * 0.02)

	return tm

/obj/item/weapon/tool/get_storage_cost()
	return (..() + extra_bulk)

/******************************
	/* Tool Usage */
*******************************/

//Simple form ideal for basic use. That proc will return TRUE only when everything was done right, and FALSE if something went wrong, ot user was unlucky.
//Editionaly, handle_failure proc will be called for a critical failure roll.
/obj/proc/use_tool(var/mob/living/user, var/atom/target, var/base_time, var/required_quality, var/fail_chance, var/required_stat, var/instant_finish_tier = 110, forced_sound = null, var/sound_repeat = 2.5)
	var/obj/item/weapon/tool/T
	if (istool(src))
		T = src
		T.tool_in_use = TRUE

	var/result = use_tool_extended(user, target, base_time, required_quality, fail_chance, required_stat, instant_finish_tier, forced_sound)

	if (T)
		T.tool_in_use = FALSE

	switch(result)
		if(TOOL_USE_CANCEL)
			return FALSE
		if(TOOL_USE_FAIL)
			handle_failure(user, target, required_stat = required_stat, required_quality = required_quality)	//We call it here because extended proc mean to be used only when you need to handle tool fail by yourself
			return FALSE
		if(TOOL_USE_SUCCESS)
			return TRUE

//Use this proc if you want to handle all types of failure yourself. It used in surgery, for example, to deal damage to patient.
/obj/proc/use_tool_extended(var/mob/living/user, var/atom/target, base_time, required_quality, fail_chance, required_stat = null, instant_finish_tier = 110, forced_sound = null, var/sound_repeat = 2.5 SECONDS)

	var/obj/item/weapon/tool/T
	if(istool(src))

		T = src
		T.last_tooluse = world.time

	if (is_hot() >= HEAT_MOBIGNITE_THRESHOLD)
		if (isliving(target))
			var/mob/living/L = target
			L.IgniteMob()

	if(target.used_now)
		user << SPAN_WARNING("[target.name] is used by someone. Wait for them to finish.")
		return TOOL_USE_CANCEL



	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.shock_stage >= 30)
			user << SPAN_WARNING("Pain distracts you from your task.")
			fail_chance += round(H.shock_stage/120 * 40)
			base_time += round(H.shock_stage/120 * 40)


	//Start time and time spent are used to calculate resource use
	var/start_time = world.time
	var/time_spent = 0

	//Precalculate worktime here
	var/time_to_finish = 0
	if (base_time)
		time_to_finish = base_time - get_tool_quality(required_quality) - 30//TODO: Factor in bay skills here user.stats.getStat(required_stat)

		//Workspeed var, can be improved by upgrades
		if (T && T.workspeed > 0)
			time_to_finish /= T.workspeed

	if((instant_finish_tier < get_tool_quality(required_quality)) || time_to_finish < 0)
		time_to_finish = 0

	if (T)
		if(!T.check_tool_effects(user, time_to_finish))
			return TOOL_USE_CANCEL

	//Repeating sound code!
	//A datum/repeating_sound is a little object we can use to make a sound repeat a few times
	var/datum/repeating_sound/toolsound = null
	if(forced_sound != NO_WORKSOUND)
		var/volume = 70
		var/extrarange = 0

		if (T && T.silenced)
			volume = 3
			extrarange = -6

		var/soundfile
		if(forced_sound)
			soundfile = forced_sound
		else
			soundfile = worksound

		if (sound_repeat && time_to_finish)
			//It will repeat roughly every 2.5 seconds until our tool finishes
			toolsound = new/datum/repeating_sound(sound_repeat,time_to_finish,0.15, src, soundfile, volume, 1, extrarange)
		else
			playsound(src.loc, soundfile, volume, 1, extrarange)

	//The we handle the doafter for the tool usage
	if(time_to_finish)
		target.used_now = TRUE

		if(!do_after(user, time_to_finish, target))
			//If the doafter fails
			user << SPAN_WARNING("You need to stand still to finish the task properly!")
			target.used_now = FALSE
			time_spent = world.time - start_time //We failed, spent only part of the time working
			if (T)
				T.consume_resources(time_spent, user)
				T.last_tooluse = world.time
			if (toolsound)
				//We abort the repeating sound.
				//Stop function will delete itself too
				toolsound.stop()
				toolsound = null
			return TOOL_USE_CANCEL
		else
			if (T)
				T.last_tooluse = world.time

			target.used_now = FALSE

	//If we get here the operation finished correctly, we spent the full time working
	time_spent = time_to_finish
	if (T)
		T.consume_resources(time_spent, user)

	//Safe cleanup
	if (toolsound)
		toolsound.stop()
		toolsound = null

	var/stat_modifer = 0
	if(required_stat)
		stat_modifer = 30//TODO: Factor in bay skills here //user.stats.getStat(required_stat)
	fail_chance = fail_chance - get_tool_quality(required_quality) - stat_modifer

	//Unreliability increases failure rates, and precision reduces it
	if (T)
		fail_chance += T.unreliability
		fail_chance -= T.precision

	if (fail_chance < 0)
		fail_chance = 0
	if(prob(fail_chance))
		user << SPAN_WARNING("You failed to finish your task with [src.name]! There was a [fail_chance]% chance to screw this up.")
		return TOOL_USE_FAIL

	return TOOL_USE_SUCCESS




/******************************
	/* Tool Failure */
*******************************/

//Critical failure rolls. If you use use_tool_extended, you might want to call that proc as well.
/obj/proc/handle_failure(var/mob/living/user, var/atom/target, var/required_stat, required_quality)
	var/obj/item/I = src
	var/obj/item/weapon/tool/T
	if (istype(src, /obj/item))
		I = src
		if(istype(src, /obj/item/weapon/tool))
			T = src

	var/crit_fail_chance = 25
	if (T)
		crit_fail_chance = max(crit_fail_chance, T.unreliability * 0.5) //At high unreliability, critical failures are more common
		if (T.degradation)
			T.unreliability += 15*T.degradation //Failing incurs 30 uses worth of damage
	if(required_stat)
		crit_fail_chance = crit_fail_chance - 30// TODO: Bay stats here: user.stats.getStat(required_stat)




	if (crit_fail_chance <= 0)
		return

	//This list initially contains the fail types that are always valid, even for robots
	var/list/failtypes = list()

	if(T && T.use_fuel_cost)
		//Robots can do this one too
		failtypes["burn"] = 0.5




	if(I.canremove)
		failtypes["throw"] = 1

		if(T && T.degradation)
			failtypes["damage"] = 2.5
			if(T.unreliability >= 3)
				failtypes["break"] = T.unreliability * 0.1 // Damaged tools are more likely to break.
		else
			failtypes["break"] = 0.5

	if(user)
		failtypes["slip"] = 2
		failtypes["swing"] = 1
		if(ishuman(user))
			if(I.canremove)
				failtypes["drop"] = 2
			if (I.sharp)
				failtypes["stab"] = 1

			//This one is limited to humans only since robots often can't remove/replace their device cells
			if(locate(/obj/item/weapon/cell) in contents)
				failtypes["overload"] = 0.5

	if(prob(crit_fail_chance))
		var/fail_type = pickweight(failtypes)

		switch(fail_type)
			//Drop the tool on the floor
			if("damage")
				if(user)
					user << SPAN_DANGER("Your hand slips and you damage [src] a bit.")
				T.unreliability += 5
				return

			//Drop the tool on the floor
			if("drop")
				if(user)
					user << SPAN_DANGER("You drop [src] on the floor.")
					user.drop_from_inventory(src)
				else if(istype(loc, /obj/machinery/door/airlock))
					//var/obj/machinery/door/airlock/AD = loc
					//AD.take_out_wedged_item() //Airlock tool wedging system, not ported yet
				else
					forceMove(get_turf(src))
				return

			//Hit yourself
			if("slip")
				var/mob/living/carbon/human/H = user
				user << SPAN_DANGER("Your hand slips while working with [src]!")
				I.attack(H, H, H.get_holding_hand(src))
				return

			//Hit a random atom around you
			if("swing")
				var/list/targets = list()
				for (var/atom/movable/AM in orange(user, 1))
					targets.Add(AM)
				if (!targets.len)
					return

				var/newtarget = pick(targets)
				var/mob/living/carbon/human/H = user

				user << SPAN_DANGER("Your hand slips and you hit [target] with [src]!")
				spawn()
					H.ClickOn(newtarget)
				return

			//Throw the tool in a random direction
			if("throw")
				if(user)
					var/mob/living/carbon/human/H = user
					var/throw_target = pick(trange(6, user))
					user << SPAN_DANGER("Your [src] flies away!")
					H.unEquip(src)
					throw_at(throw_target, src.throw_range, src.throw_speed, H)
					return
				if(istype(loc, /obj/machinery/door/airlock))
					//var/obj/machinery/door/airlock/AD = loc
					//AD.take_out_wedged_item() //Airlock tool wedging system, not ported yet
				else
					forceMove(get_turf(src))
				var/throw_target = pick(trange(6, src))
				throw_at(throw_target, src.throw_range, src.throw_speed)
				return

			//Stab yourself in the hand so hard your tool embeds
			if("stab")
				var/mob/living/carbon/human/H = user
				user << SPAN_DANGER("You accidentally stuck [src] in your hand!")
				H.get_organ(H.get_holding_hand(src)).embed(src)
				return

			//The tool completely breaks, permanantly gone
			if("break")
				if(user)
					user << SPAN_DANGER("Your [src] broke beyond repair!")
					new /obj/item/weapon/material/shard/shrapnel(user.loc)
				else
					new /obj/item/weapon/material/shard/shrapnel(get_turf(src))

				//To encourage using makeshift tools, upgrades are preserved if the tool breaks
				if (T)
					for (var/obj/item/weapon/tool_upgrade/A in T.upgrades)
						A.forceMove(get_turf(src))
						A.holder = null

				//Airlock tool wedging system, not ported yet
				//if(istype(loc, /obj/machinery/door/airlock))
					//var/obj/machinery/door/airlock/AD = loc
					//AD.take_out_wedged_item()

				qdel(src)
				return

			//The fuel in the tool ignites and sets you aflame
			if("burn")
				user << SPAN_DANGER("You ignite the fuel of the [src]!")
				var/fuel = T.get_fuel()
				T.consume_fuel(fuel)
				user.adjust_fire_stacks(fuel/10)
				user.IgniteMob()
				T.update_icon()
				return

			//The cell explodes
			//This can happen even with non-tools which contain a cell
			if("overload")
				var/obj/item/weapon/cell/C
				if(T)
					C = T.cell
				else
					C = locate(/obj/item/weapon/cell) in contents


				if(user)
					user << SPAN_DANGER("You overload the cell in the [src]!")
				C.explode()
				if (T)
					T.cell = null

				update_icon()
				return





/******************************
	/* Data and Checking */
*******************************/
/obj/proc/has_quality(quality_id)
	return quality_id in tool_qualities


/obj/proc/ever_has_quality(quality_id)
	return has_quality(quality_id)

//A special version of the above that also checks the switched on list
//As a result, it checks what qualities the tool is ever capable of having, not just those it has right now
/obj/item/weapon/tool/ever_has_quality(quality_id)
	.=has_quality(quality_id)
	if (!.)
		if (quality_id in switched_on_qualities)
			return TRUE

/obj/proc/get_tool_quality(quality_id)
	if (tool_qualities && tool_qualities.len)
		return tool_qualities[quality_id]
	return 0

//We are cheking if our item got required qualities. If we require several qualities, and item posses more than one of those, we ask user to choose how that item should be used
/obj/proc/get_tool_type(var/mob/living/user, var/list/required_qualities, var/atom/use_on, var/datum/callback/CB)
	var/list/L = required_qualities & tool_qualities

	if(!L.len)
		return FALSE

	var/return_quality
	if(L.len > 1)
		return_quality = input(user,"What quality you using?", "Tool options", ABORT_CHECK) in L
		//for(var/i in L)
		//Radial menu not ported
		//L[i] = image(icon = 'icons/mob/radial/tools.dmi', icon_state = i)
		//return_quality = show_radial_menu(user, use_on ? use_on : user, L, tooltips = TRUE, require_near = TRUE, custom_check = CB)
	else
		return_quality = L[1]

	if(!return_quality)
		return

	return return_quality








/obj/item/weapon/tool/proc/turn_on(mob/user)
	switched_on = TRUE
	tool_qualities = switched_on_qualities
	if (!isnull(switched_on_force))
		force = switched_on_force
	if(glow_color)
		set_light(1, 1, 3, l_color = glow_color)
	update_icon()
	//update_wear_icon() //Too tied into eris' inventory system, need to find a better path to do this

/obj/item/weapon/tool/proc/turn_off(mob/user)
	switched_on = FALSE
	STOP_PROCESSING(SSobj, src)
	tool_qualities = switched_off_qualities
	force = initial(force)
	if(glow_color)
		set_light(0,0, 0)
	update_icon()
	//update_wear_icon() //Too tied into eris' inventory system, need to find a better path to do this








/*********************
	Resource Consumption
**********************/
/obj/proc/consume_resources(var/timespent, var/user)
	return

/obj/item/weapon/tool/consume_resources(var/timespent, var/user)
	//We will always use a minimum of 0.5 second worth of resources
	if (timespent < 5)
		timespent = 5

	if(use_power_cost)
		if (!cell.checked_use(use_power_cost*timespent))
			user << SPAN_WARNING("[src] battery is dead or missing.")
			return FALSE

	if(use_fuel_cost)
		if(!consume_fuel(use_fuel_cost*timespent))
			user << SPAN_NOTICE("You need more welding fuel to complete this task.")
			return FALSE

	if(use_stock_cost)
		var/scost = use_stock_cost * timespent
		if (!allow_decimal_stock)
			scost = round(scost, 1)
		consume_stock(scost)

	//Gradual degradation
	if (degradation)
		unreliability += rand_between(0, degradation)

//Power and fuel drain, sparks spawn
/obj/item/weapon/tool/proc/check_tool_effects(mob/living/user, var/time)

	if(use_power_cost)
		if(!cell || !cell.check_charge(use_power_cost*time))
			user << SPAN_WARNING("[src] battery is dead or missing.")
			return FALSE

	if(use_fuel_cost)
		if(get_fuel() < (use_fuel_cost*time))
			user << SPAN_NOTICE("You need more welding fuel to complete this task.")
			return FALSE

	if (use_stock_cost)
		if(stock < (use_stock_cost*time))
			user << SPAN_NOTICE("There is not enough left in [src] to complete this task.")
			return FALSE

	if(eye_hazard)
		eyecheck(user)

	if(sparks_on_use && !silenced)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, get_turf(src))
		sparks.start()

	update_icon()
	return TRUE

//Returns the amount of fuel in tool
/obj/item/weapon/tool/proc/get_fuel()
	return reagents.get_reagent_amount(/datum/reagent/fuel)

/obj/item/weapon/tool/proc/consume_fuel(var/volume)
	if (get_fuel() >= volume)
		reagents.remove_reagent(/datum/reagent/fuel, volume)
		return TRUE
	return FALSE


/obj/item/weapon/tool/proc/consume_stock(var/number)
	if (stock >= number)
		stock -= number
	else
		stock = 0

	if (delete_when_empty && stock <= 0)
		qdel(src)


/***************************
	Tool Upgrades
****************************/
/obj/item/weapon/tool/proc/refresh_upgrades()
//First of all, lets reset any var that could possibly be altered by an upgrade
	degradation = initial(degradation) * 1.05 ** repair_frequency //Degradation gets slightly worse each time the tool is repaired
	workspeed = initial(workspeed)
	precision = initial(precision)
	suitable_cell = initial(suitable_cell)
	max_fuel = initial(max_fuel)

	use_fuel_cost = initial(use_fuel_cost)
	use_power_cost = initial(use_power_cost)
	force = initial(force)
	switched_on_force = initial(switched_on_force)
	extra_bulk = initial(extra_bulk)
	silenced = initial(silenced)
	name = initial(name)
	max_upgrades = initial(max_upgrades)
	color = initial(color)
	sharp = initial(sharp)
	prefixes = list()

	//Now lets have each upgrade reapply its modifications
	for (var/obj/item/weapon/tool_upgrade/T in upgrades)
		T.apply_values()

	for (var/prefix in prefixes)
		name = "[prefix] [name]"

	//Set the fuel volume, incase any mods altered our max fuel
	if (reagents)
		reagents.maximum_volume = max_fuel


/obj/item/weapon/tool/examine(mob/user)
	if(!..(user,2))
		return

	if(use_power_cost)
		if(!cell)
			user << SPAN_WARNING("There is no cell inside to power the tool")
		else
			user << "The charge meter reads [round(cell.percent() )]%."

	if(use_fuel_cost)
		user << text("\icon[] [] contains []/[] units of fuel!", src, src.name, get_fuel(),src.max_fuel )

	if (use_stock_cost)
		user << SPAN_NOTICE("it has [stock] / [max_stock] units remaining.")

	//Display a bunch of stats but only if they're nondefault values
	if (precision != 0)
		user << "Precision: [SPAN_NOTICE("[precision]")]"

	if (workspeed != 1)
		user << "Work Speed: [SPAN_NOTICE("[workspeed*100]%")]"

	if (upgrades.len)
		user << "It has the following upgrades installed:"
		for (var/obj/item/weapon/tool_upgrade/TU in upgrades)
			user << SPAN_NOTICE(TU.name)

	if (unreliability)
		if (unreliability < 2)
			return
		else if (unreliability < 4)
			user << "It has a few light scratches."
		else if (unreliability < 8)
			user << SPAN_NOTICE("It shows minor signs of stress and wear.")
		else if (unreliability < 12)
			user << SPAN_WARNING("It looks a bit cracked and worn.")
		else if (unreliability < 25)
			user << SPAN_WARNING("Whatever use this tool once had is fading fast.")
		else if (unreliability < 40)
			user << SPAN_WARNING("Attempting to use this thing as a tool is probably not going to work out well.")
		else
			user << SPAN_DANGER("It's falling apart. This is one slip away from just being a pile of assorted trash.")


//Recharge the fuel at fueltank, also explode if switched on
/obj/item/weapon/tool/afterattack(obj/O, mob/user, proximity)
	if(use_fuel_cost)
		if(!proximity) return
		if ((istype(O, /obj/structure/reagent_dispensers/fueltank)) && get_dist(src,O) <= 1 && !switched_on)
			O.reagents.trans_to_obj(src, max_fuel)
			user << SPAN_NOTICE("[src] refueled")
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			return
		else if ((istype(O, /obj/structure/reagent_dispensers/fueltank)) && get_dist(src,O) <= 1 && switched_on)
			message_admins("[key_name_admin(user)] triggered a fueltank explosion with a welding tool.")
			log_game("[key_name(user)] triggered a fueltank explosion with a welding tool.")
			user << SPAN_DANGER("You begin welding on the [O] and with a moment of lucidity you realize, this might not have been the smartest thing you've ever done.")
			var/obj/structure/reagent_dispensers/fueltank/tank = O
			tank.explode()
			return
		if (switched_on)
			var/turf/location = get_turf(user)
			if(isliving(O))
				var/mob/living/L = O
				L.IgniteMob()
			if (istype(location, /turf))
				location.hotspot_expose(700, 50, 1)

	if (has_quality(QUALITY_ADHESIVE) && proximity)
		//Tape can be used to repair other tools
		if (istool(O))
			var/obj/item/weapon/tool/T = O
			if (T.unreliability)
				user.visible_message(SPAN_NOTICE("[user] begins repairing \the [O] with the [src]!"))
				//Toolception!
				if(use_tool(user, T, 60 + (T.unreliability*10), QUALITY_ADHESIVE, T.unreliability, "construction"))
					//Repairs are imperfect, it'll never go back to being intact
					T.unreliability *= 0.1
					repair_frequency++
					refresh_upgrades()
				return

		if (stick(O, user))
			return
	//Triggers degradation and resource use upon attacks
	if (!(item_flags & ITEM_FLAG_NO_BLUDGEON) && (world.time - last_tooluse) > 2)
		consume_resources(5,user)
		if (prob(unreliability))
			handle_failure(user, O)

	return ..()

//Triggers degradation and resource use upon attacks
/obj/item/weapon/tool/resolve_attackby(atom/A, mob/user, params)
	.=..()
	//If the parent return value is true, then there won't be an attackby
	//If there will be an attackby, we'll handle it there
	//Checking the last tooluse time prevents consuming twice for a tool action
	if (. && loc == user && (!(item_flags & ITEM_FLAG_NO_BLUDGEON)) && (world.time - last_tooluse) > 2)
		consume_resources(5,user)
		if (prob(unreliability))
			handle_failure(user, A)

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weapon/tool/proc/eyecheck(mob/user as mob)
	if(!iscarbon(user))
		return TRUE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if(!E)
			return
		var/safety = H.eyecheck()
		switch(safety)
			if(FLASH_PROTECTION_MODERATE)
				H << SPAN_WARNING("Your eyes sting a little.")
				E.damage += rand(1, 2)
				if(E.damage > 12)
					H.eye_blurry += rand(3,6)
			if(FLASH_PROTECTION_NONE)
				H << SPAN_WARNING("Your eyes burn.")
				E.damage += rand(2, 4)
				if(E.damage > 10)
					E.damage += rand(4,10)
			if(FLASH_PROTECTION_REDUCED)
				H << SPAN_DANGER("Your equipment intensify the welder's glow. Your eyes itch and burn severely.")
				H.eye_blurry += rand(12,20)
				E.damage += rand(12, 16)
		if(safety<FLASH_PROTECTION_MAJOR)
			if(E.damage > 10)
				user << SPAN_WARNING("Your eyes are really starting to hurt. This can't be good for you!")

			if (E.damage >= E.min_broken_damage)
				H << SPAN_DANGER("You go blind!")
				H.sdisabilities |= BLIND
			else if (E.damage >= E.min_bruised_damage)
				H << SPAN_DANGER("You go blind!")
				H.eye_blind = 5
				H.eye_blurry = 5
				H.disabilities |= NEARSIGHTED
				spawn(100)
					H.disabilities &= ~NEARSIGHTED

// TODO: Figure out bay prosthetic repair then uncomment this
/obj/item/weapon/tool/attack(mob/living/M, mob/living/user, var/target_zone)
	if ((user.a_intent == I_HELP) && ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = H.organs_by_name[user.zone_sel.selecting]

		if (!istype(S) || !BP_IS_ROBOTIC(S))
			return ..()

		//TODO: Bay probably has its own code for this. Point to that instead
		if (get_tool_type(user, list(QUALITY_WELDING), H)) //Prosthetic repair
			if (S.brute_dam || S.burn_dam)
				if (use_tool(user, H, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_NORMAL, required_stat = "construction"))
					if(S.robo_repair(15, BRUTE, "some dents", src, user))
						//S.heal_damage(15,0,0,1)
						user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
						user.visible_message(SPAN_NOTICE("\The [user] patches some dents on \the [H]'s [S.name] with \the [src]."))
						return 1
			/*
				else if (S.open != 2)
					user << SPAN_DANGER("The damage is far too severe to patch over externally.")
					return 1
			else if (S.open != 2) // For surgery.
				user << SPAN_NOTICE("Nothing to fix!")
				return 1
				*/
			else
				user << SPAN_NOTICE("Nothing to fix!")
				return 1

	return ..()


/obj/item/weapon/tool/update_icon()
	overlays.Cut()

	if(switched_on && toggleable)
		overlays += "[icon_state]_on"

	if(use_power_cost)
		var/ratio = 0
		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(cell && cell.charge >= use_power_cost)
			ratio = cell.charge / cell.maxcharge
			ratio = max(round(ratio, 0.25) * 100, 25)
			overlays += "[icon_state]-[ratio]"

	if(use_fuel_cost)
		var/ratio = 0
		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(get_fuel() >= use_fuel_cost)
			ratio = get_fuel() / max_fuel
			ratio = max(round(ratio, 0.25) * 100, 25)
			overlays += "[icon_state]-[ratio]"

/***************************
	Misc/utility procs
****************************/

//Used by adhesive tools to stick an item to stuff
/obj/item/weapon/tool/proc/stick(var/obj/item/target, var/mob/user)
	return


/obj/item/weapon/tool/admin_debug
	name = "Electric Boogaloo 3000"
	icon_state = "omnitool"
	item_state = "omnitool"
	tool_qualities = list(QUALITY_BOLT_TURNING = 100,
							QUALITY_PRYING = 100,
							QUALITY_WELDING = 100,
							QUALITY_SCREW_DRIVING = 100,
							QUALITY_CLAMPING = 100,
							QUALITY_CAUTERIZING = 100,
							QUALITY_WIRE_CUTTING = 100,
							QUALITY_RETRACTING = 100,
							QUALITY_DRILLING = 100,
							QUALITY_SAWING = 100,
							QUALITY_VEIN_FIXING = 100,
							QUALITY_BONE_SETTING = 100,
							QUALITY_BONE_FIXING = 100,
							QUALITY_SHOVELING = 100,
							QUALITY_DIGGING = 100,
							QUALITY_EXCAVATION = 100,
							QUALITY_CUTTING = 100)


