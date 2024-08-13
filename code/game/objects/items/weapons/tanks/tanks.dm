var/global/list/tank_gauge_cache = list()

/obj/item/tank
	name = "tank"
	icon = 'icons/obj/tank.dmi'

	var/gauge_icon = "indicator_tank"
	var/gauge_cap = 6
	var/previous_gauge_pressure = null

	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_LARGE

	force = 15
	attack_cooldown = 2*DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -30
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4

	var/datum/gas_mixture/air_contents = null
	var/distribute_pressure = ONE_ATMOSPHERE
	var/integrity = 20
	var/maxintegrity = 20
	var/obj/item/device/tankassemblyproxy/proxyassembly

	var/volume = 70
	var/tank_size = TANK_SIZE_MEDIUM
	var/manipulated_by = null		//Used by _onclick/hud/screen_objects.dm internals to determine if someone has messed with our tank or not.
						//If they have and we haven't scanned it with the PDA or gas analyzer then we might just breath whatever they put in it.
	var/failure_temp = 173 //173 deg C Borate seal (yes it should be 153 F, but that's annoying)


	var/tank_flags = EMPTY_BITFIELD

	var/list/starting_pressure //list in format 'xgm gas id' = 'desired pressure at start'

/obj/item/tank/Initialize()
	. = ..()
	proxyassembly = new /obj/item/device/tankassemblyproxy(src)
	proxyassembly.tank = src

	air_contents = new /datum/gas_mixture(volume, T20C)
	for(var/gas in starting_pressure)
		air_contents.adjust_gas(gas, starting_pressure[gas]*volume/(R_IDEAL_GAS_EQUATION*T20C), 0)
	air_contents.update_values()

	START_PROCESSING(SSobj, src)
	update_icon(TRUE)

/obj/item/tank/Destroy()
	QDEL_NULL(air_contents)

	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(proxyassembly)

	if(istype(loc, /obj/item/device/transfer_valve))
		var/obj/item/device/transfer_valve/TTV = loc
		TTV.remove_tank(src)
		if(!QDELETED(TTV)) // It will delete tanks inside it on qdel.
			qdel(TTV)

	. = ..()

/obj/item/tank/examine(mob/user, distance)
	. = ..()

	if (distance < 5)
		var/list/mods = list()
		if (GET_FLAGS(tank_flags, TANK_FLAG_WIRED))
			mods += "some wires"
		if (proxyassembly.assembly)
			mods += user.skill_check(SKILL_DEVICES, SKILL_TRAINED) ? "an ignition assembly" : "a device"
		if (length(mods))
			to_chat(user, "[english_list(mods)] are attached.")
	else
		return

	if (distance < 3)
		if (GET_FLAGS(tank_flags, TANK_FLAG_WELDED))
			to_chat(user, SPAN_WARNING("The emergency relief valve has been welded shut!"))
		else if (GET_FLAGS(tank_flags, TANK_FLAG_FORCED))
			to_chat(user, SPAN_WARNING("The emergency relief valve has been forced open!"))
	else
		return

	if (distance < 1)
		var/descriptive
		if(!air_contents)
			descriptive = "empty"
		else
			var/celsius_temperature = air_contents.temperature - T0C
			switch(celsius_temperature)
				if(300 to INFINITY)
					descriptive = "furiously hot"
				if(100 to 300)
					descriptive = "hot"
				if(80 to 100)
					descriptive = "warm"
				if(40 to 80)
					descriptive = "lukewarm"
				if(20 to 40)
					descriptive = "room temperature"
				if(-20 to 20)
					descriptive = "cold"
				else
					descriptive = "bitterly cold"
		to_chat(user, SPAN_ITALIC("\The [src] feels [descriptive]."))

/obj/item/tank/use_tool(obj/item/W, mob/living/user, list/click_params)
	if (istype(loc, /obj/item/assembly))
		icon = loc
		return TRUE

	if (istype(W, /obj/item/device/scanner/gas))
		return ..()

	if (isScrewdriver(W))
		user.visible_message(
			SPAN_ITALIC("\The [user] starts to use \the [W] on \the [src]."),
			SPAN_ITALIC("You start to force \the [src]'s emergency relief valve with \the [W]."),
			SPAN_ITALIC("You can hear metal scratching on metal."),
			range = 5
		)
		if (GET_FLAGS(tank_flags, TANK_FLAG_WELDED))
			to_chat(user, SPAN_WARNING("The valve is stuck. You can't move it at all!"))
			return TRUE
		var/reduction = round(user.get_skill_value(SKILL_ATMOS) * 0.5) //0,1,1,2,2
		if (do_after(user, (5 - reduction) SECONDS, src, DO_PUBLIC_UNIQUE))
			if (GET_FLAGS(tank_flags, TANK_FLAG_WELDED))
				to_chat(user, SPAN_WARNING("The valve is stuck. You can't move it at all!"))
				return TRUE
			FLIP_FLAGS(tank_flags, TANK_FLAG_FORCED)
			to_chat(user, SPAN_NOTICE("You finish forcing the valve [GET_FLAGS(tank_flags, TANK_FLAG_FORCED) ? "open" : "closed"]."))
		return TRUE

	if (istype(W,/obj/item/latexballon))
		var/obj/item/latexballon/LB = W
		LB.blow(src)
		return TRUE

	if(isCoil(W))
		if (GET_FLAGS(tank_flags, TANK_FLAG_WIRED))
			to_chat(user, SPAN_WARNING("\The [src] is already wired."))
			return TRUE
		else
			var/obj/item/stack/cable_coil/C = W
			var/single = C.get_amount() == 1
			if(C.use(1))
				SET_FLAGS(tank_flags, TANK_FLAG_WIRED)
				to_chat(user, SPAN_NOTICE("You attach [single ? "" : "some of "]\the [C] to \the [src]."))
				update_icon(TRUE)
			return TRUE

	if(isWirecutter(W))
		if(GET_FLAGS(tank_flags, TANK_FLAG_WIRED) && proxyassembly.assembly)
			to_chat(user, SPAN_NOTICE("You carefully begin clipping the wires that attach to the tank."))
			if(do_after(user, 10 SECONDS, src))
				CLEAR_FLAGS(tank_flags, TANK_FLAG_WIRED)
				to_chat(user, SPAN_NOTICE("You cut the wire and remove the device."))

				var/obj/item/device/assembly_holder/assy = proxyassembly.assembly
				if(assy.a_left && assy.a_right)
					assy.dropInto(usr.loc)
					assy.master = null
					proxyassembly.assembly = null
				else
					if(!proxyassembly.assembly.a_left)
						assy.a_right.dropInto(usr.loc)
						assy.a_right.holder = null
						assy.a_right = null
						proxyassembly.assembly = null
						qdel(assy)
				update_icon(TRUE)
				return TRUE

			else
				to_chat(user, SPAN_DANGER("You slip and bump the igniter!"))
				if(prob(85))
					proxyassembly.receive_signal()
				return TRUE

		else if(GET_FLAGS(tank_flags, TANK_FLAG_WIRED))
			if(do_after(user, (W.toolspeed * 1) SECOND, src, DO_PUBLIC_UNIQUE))
				to_chat(user, SPAN_NOTICE("You quickly clip the wire from the tank."))
				CLEAR_FLAGS(tank_flags, TANK_FLAG_WIRED)
				update_icon(TRUE)
			return TRUE

		else
			to_chat(user, SPAN_NOTICE("There are no wires to cut!"))
			return TRUE

	if(istype(W, /obj/item/device/assembly_holder))
		if(GET_FLAGS(tank_flags, TANK_FLAG_WIRED))
			to_chat(user, SPAN_NOTICE("You begin attaching the assembly to \the [src]."))
			if(do_after(user, 5 SECONDS, src, DO_PUBLIC_UNIQUE))
				to_chat(user, SPAN_NOTICE("You finish attaching the assembly to \the [src]."))
				GLOB.bombers += "[key_name(user)] attached an assembly to a wired [src]. Temp: [air_contents.temperature-T0C]"
				log_and_message_admins("attached an assembly to a wired [src]. Temp: [air_contents.temperature-T0C]", user)
				assemble_bomb(W,user)
				return TRUE
			else
				to_chat(user, SPAN_NOTICE("You stop attaching the assembly."))
				return TRUE
		else
			to_chat(user, SPAN_NOTICE("You need to wire the device up first."))
			return TRUE

	if(isWelder(W))
		var/obj/item/weldingtool/WT = W
		if (GET_FLAGS(tank_flags, TANK_FLAG_FORCED))
			to_chat(user, SPAN_WARNING("\The [src]'s emergency relief valve must be closed before you can weld it shut!"))
			return TRUE
		if(WT.can_use(1,user))
			if(!GET_FLAGS(tank_flags, TANK_FLAG_WELDED))
				to_chat(user, SPAN_NOTICE("You begin welding the \the [src] emergency pressure relief valve."))
				if(do_after(user, (W.toolspeed * 4) SECONDS, src, DO_PUBLIC_UNIQUE) && WT.remove_fuel(1, user))
					to_chat(user, "[SPAN_NOTICE("You carefully weld \the [src] emergency pressure relief valve shut.")][SPAN_WARNING(" \The [src] may now rupture under pressure!")]")
					SET_FLAGS(tank_flags, TANK_FLAG_WELDED)
					CLEAR_FLAGS(tank_flags, TANK_FLAG_LEAKING)
					return TRUE
				else
					GLOB.bombers += "[key_name(user)] attempted to weld a [src]. [air_contents.temperature-T0C]"
					log_and_message_admins("attempted to weld a [src]. [air_contents.temperature-T0C]", user)
					if(WT.welding)
						to_chat(user, SPAN_DANGER("You accidentally rake \the [W] across \the [src]!"))
						maxintegrity -= rand(2,6)
						integrity = min(integrity,maxintegrity)
						air_contents.add_thermal_energy(rand(2000,50000))
					return TRUE
			else
				to_chat(user, SPAN_NOTICE("The emergency pressure relief valve has already been welded."))
				return TRUE
	return ..()

/obj/item/tank/attack_self(mob/user as mob)
	add_fingerprint(user)
	if (!air_contents)
		return
	ui_interact(user)

// There's GOT to be a better way to do this
	if (proxyassembly.assembly)
		proxyassembly.assembly.attack_self(user)

/obj/item/tank/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/mob/living/carbon/location = null

	if(istype(loc, /obj/item/rig))		// check for tanks in rigs
		if(istype(loc.loc, /mob/living/carbon))
			location = loc.loc
	else if(istype(loc, /mob/living/carbon))
		location = loc

	var/using_internal
	if(istype(location))
		if(location.internal==src)
			using_internal = 1

	// this is the data which will be sent to the ui
	var/data[0]
	data["tankPressure"] = round(air_contents && air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["releasePressure"] = round(distribute_pressure ? distribute_pressure : 0)
	data["defaultReleasePressure"] = round(initial(distribute_pressure))
	data["maxReleasePressure"] = round(TANK_MAX_RELEASE_PRESSURE)
	data["valveOpen"] = using_internal ? 1 : 0
	data["maskConnected"] = 0

	if(istype(location))
		var/mask_check = 0

		if(location.internal == src)	// if tank is current internal
			mask_check = 1
		else if(src in location)		// or if tank is in the mobs possession
			if(!location.internal)		// and they do not have any active internals
				mask_check = 1
		else if(istype(loc, /obj/item/rig) && (loc in location))	// or the rig is in the mobs possession
			if(!location.internal)		// and they do not have any active internals
				mask_check = 1

		if(mask_check)
			if(location.wear_mask && (location.wear_mask.item_flags & ITEM_FLAG_AIRTIGHT))
				data["maskConnected"] = 1
			else if(istype(location, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = location
				if(H.head && (H.head.item_flags & ITEM_FLAG_AIRTIGHT))
					data["maskConnected"] = 1

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "tanks.tmpl", "Tank", 500, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/item/tank/Topic(user, href_list, state = GLOB.inventory_state)
	..()

/obj/item/tank/OnTopic(user, href_list)
	if (href_list["dist_p"])
		if (href_list["dist_p"] == "reset")
			distribute_pressure = initial(distribute_pressure)
		else if (href_list["dist_p"] == "max")
			distribute_pressure = TANK_MAX_RELEASE_PRESSURE
		else
			var/cp = text2num(href_list["dist_p"])
			distribute_pressure += cp
		distribute_pressure = min(max(round(distribute_pressure), 0), TANK_MAX_RELEASE_PRESSURE)
		return TOPIC_REFRESH

	if (href_list["stat"])
		toggle_valve(usr)
		return TOPIC_REFRESH

/obj/item/tank/proc/toggle_valve(mob/user)

	var/mob/living/carbon/location
	if(istype(loc,/mob/living/carbon))
		location = loc
	else if(istype(loc,/obj/item/rig))
		var/obj/item/rig/rig = loc
		if(rig.wearer)
			location = rig.wearer
	else
		return

	if(location.internal == src)
		to_chat(user, SPAN_NOTICE("You close the tank release valve."))
		location.set_internals(null)
	else
		var/can_open_valve
		if(location.wear_mask && (location.wear_mask.item_flags & ITEM_FLAG_AIRTIGHT))
			can_open_valve = 1
		else if(istype(location,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = location
			if(H.head && (H.head.item_flags & ITEM_FLAG_AIRTIGHT))
				can_open_valve = 1

		if(can_open_valve)
			to_chat(user, SPAN_NOTICE("You open \the [src] valve."))
			location.set_internals(src)
		else
			to_chat(user, SPAN_WARNING("You need something to connect to \the [src]."))

/obj/item/tank/remove_air(amount)
	. = air_contents.remove(amount)
	if(.)
		queue_icon_update()

/obj/item/tank/proc/remove_air_ratio(ratio, out_group_multiplier = 1)
	. = air_contents.remove_ratio(ratio, out_group_multiplier)
	if(.)
		queue_icon_update()

/obj/item/tank/proc/remove_air_by_flag(flag, amount)
	. = air_contents.remove_by_flag(flag, amount)
	queue_icon_update()

/obj/item/tank/proc/air_adjust_gas(gasid, moles, update = 1)
	. = air_contents.adjust_gas(gasid, moles, update)
	if(.)
		queue_icon_update()

/obj/item/tank/return_air()
	return air_contents

/obj/item/tank/assume_air(datum/gas_mixture/giver)
	air_contents.merge(giver)
	check_status()
	queue_icon_update()
	return 1

/obj/item/tank/proc/remove_air_volume(volume_to_return)
	if(!air_contents)
		return null

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < distribute_pressure)
		distribute_pressure = tank_pressure

	var/datum/gas_mixture/removed = remove_air(distribute_pressure*volume_to_return/(R_IDEAL_GAS_EQUATION*air_contents.temperature))
	if(removed)
		removed.volume = volume_to_return
	return removed

/obj/item/tank/Process()
	//Allow for reactions
	air_contents.react() //cooking up air tanks - add phoron and oxygen, then heat above PHORON_MINIMUM_BURN_TEMPERATURE
	check_status()

#define TANK_IDEAL_PRESSURE 1015

/obj/item/tank/on_update_icon(override)

	var/list/overlays_to_add
	if(override && (proxyassembly.assembly || GET_FLAGS(tank_flags, TANK_FLAG_WIRED)))
		LAZYADD(overlays_to_add, image(icon,"bomb_assembly"))
		if(proxyassembly.assembly)
			var/image/bombthing = image(proxyassembly.assembly.icon, proxyassembly.assembly.icon_state)
			bombthing.CopyOverlays(proxyassembly.assembly)
			bombthing.pixel_y = -1
			bombthing.pixel_x = -3
			LAZYADD(overlays_to_add, bombthing)

	if(gauge_icon)
		var/gauge_pressure = 0
		if(air_contents)
			gauge_pressure = air_contents.return_pressure()
			if(gauge_pressure > TANK_IDEAL_PRESSURE)
				gauge_pressure = -1
			else
				gauge_pressure = round((gauge_pressure/TANK_IDEAL_PRESSURE)*gauge_cap)
		if(override || (previous_gauge_pressure != gauge_pressure))
			var/indicator = "[gauge_icon][(gauge_pressure == -1) ? "overload" : gauge_pressure]"
			if(!tank_gauge_cache[indicator])
				tank_gauge_cache[indicator] = image(icon, indicator)
			LAZYADD(overlays_to_add, tank_gauge_cache[indicator])
		previous_gauge_pressure = gauge_pressure

	SetOverlays(overlays_to_add)

#undef TANK_IDEAL_PRESSURE

//Handle exploding, leaking, and rupturing of the tank
/obj/item/tank/proc/check_status()
	set waitfor = FALSE
	if(!air_contents)
		return 0

	var/pressure = air_contents.return_pressure()

	if(pressure > TANK_FRAGMENT_PRESSURE)
		if(integrity <= 7)
			if(!istype(loc,/obj/item/device/transfer_valve))
				log_and_message_admins("Explosive tank rupture! last key to touch the tank was [fingerprintslast].", null, src)

			//Give the gas a chance to build up more pressure through reacting
			air_contents.react()
			air_contents.react()
			air_contents.react()

			pressure = air_contents.return_pressure()
			var/strength = ((pressure-TANK_FRAGMENT_PRESSURE)/TANK_FRAGMENT_SCALE)

			var/mult = ((air_contents.volume/140)**(1/2)) * (air_contents.total_moles**2/3)/((29*0.64) **2/3) //tanks appear to be experiencing a reduction on scale of about 0.64 total moles
			//tanks appear to be experiencing a reduction on scale of about 0.64 total moles

			var/turf/simulated/T = get_turf(src)
			T.hotspot_expose(air_contents.temperature, 70, 1)
			if(!T)
				return

			T.assume_air(air_contents)

			// Determine max power and range for the explosion
			var/range = mult * strength
			var/devst = round(range * 0.15)
			var/heavy = round(range * 0.35)
			var/max_power
			if (devst)
				max_power = EX_ACT_DEVASTATING
			else if (heavy)
				max_power = EX_ACT_HEAVY
			else
				max_power = EX_ACT_LIGHT

			explosion(
				get_turf(loc),
				round(min(BOMBCAP_RADIUS, range * 1.3)),
				max_power
			)

			var/num_fragments = round(rand(8,10) * sqrt(strength * mult))
			fragmentate(T, num_fragments, 7, list(/obj/item/projectile/bullet/pellet/fragment/tank/small = 7,/obj/item/projectile/bullet/pellet/fragment/tank = 2,/obj/item/projectile/bullet/pellet/fragment/strong = 1))

			if(istype(loc, /obj/item/device/transfer_valve))
				var/obj/item/device/transfer_valve/TTV = loc
				TTV.remove_tank(src)
				qdel(TTV)

			if(src)
				qdel(src)
		else
			integrity -=7
	else if(pressure > TANK_RUPTURE_PRESSURE)
		#ifdef FIREDBG
		log_debug(SPAN_WARNING("[x],[y] tank is rupturing: [pressure] kPa, integrity [integrity]"))
		#endif

		if(integrity <= 0)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			T.assume_air(air_contents)
			playsound(get_turf(src), 'sound/weapons/gunshot/shotgun.ogg', 20, 1)
			visible_message("[icon2html(src, viewers(get_turf(src)))] [SPAN_DANGER("\The [src] flies apart!")]", SPAN_WARNING("You hear a bang!"))
			T.hotspot_expose(air_contents.temperature, 70, 1)

			var/strength = 1+((pressure-TANK_LEAK_PRESSURE)/TANK_FRAGMENT_SCALE)

			var/mult = (air_contents.total_moles**2/3)/((29*0.64) **2/3) //tanks appear to be experiencing a reduction on scale of about 0.64 total moles

			var/num_fragments = round(rand(6,8) * sqrt(strength * mult)) //Less chunks, but bigger
			fragmentate(T, num_fragments, 7, list(/obj/item/projectile/bullet/pellet/fragment/tank/small = 1,/obj/item/projectile/bullet/pellet/fragment/tank = 5,/obj/item/projectile/bullet/pellet/fragment/strong = 4))

			if(istype(loc, /obj/item/device/transfer_valve))
				var/obj/item/device/transfer_valve/TTV = loc
				TTV.remove_tank(src)

			qdel(src)
		else
			integrity-= 5
	else if(pressure && (GET_FLAGS(tank_flags, TANK_FLAG_FORCED) || pressure > TANK_LEAK_PRESSURE || air_contents.temperature - T0C > failure_temp))
		if((integrity <= 19 || GET_FLAGS(tank_flags, TANK_FLAG_LEAKING | TANK_FLAG_FORCED)) && !GET_FLAGS(tank_flags, TANK_FLAG_WELDED))
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			var/datum/gas_mixture/environment = loc.return_air()
			var/env_pressure = environment.return_pressure()

			var/release_ratio = clamp(0.002, sqrt(max(pressure-env_pressure,0)/pressure),1)
			var/datum/gas_mixture/leaked_gas = air_contents.remove_ratio(release_ratio)
			//dynamic air release based on ambient pressure

			T.assume_air(leaked_gas)
			if(!GET_FLAGS(tank_flags, TANK_FLAG_LEAKING))
				visible_message("[icon2html(src, viewers(get_turf(src)))] [SPAN_WARNING("\The [src] relief valve flips open with a hiss!")]", "You hear hissing.")
				playsound(loc, 'sound/effects/spray.ogg', 10, 1, -3)
				SET_FLAGS(tank_flags, TANK_FLAG_LEAKING)
				#ifdef FIREDBG
				log_debug(SPAN_WARNING("[x],[y] tank is leaking: [pressure] kPa, integrity [integrity]"))
				#endif
		else
			integrity-= 2
	else
		if(integrity < maxintegrity)
			integrity++
			if(GET_FLAGS(tank_flags, TANK_FLAG_LEAKING))
				integrity++
			if(integrity == maxintegrity)
				CLEAR_FLAGS(tank_flags, TANK_FLAG_LEAKING)

/////////////////////////////////
///Prewelded tanks
/////////////////////////////////

/obj/item/tank/phoron/welded
	tank_flags = TANK_FLAG_WELDED
/obj/item/tank/oxygen/welded
	tank_flags = TANK_FLAG_WELDED

/////////////////////////////////
///Onetankbombs (added as actual items)
/////////////////////////////////

/obj/item/tank/proc/onetankbomb()
	var/phoron_amt = 4 + rand(4)
	var/oxygen_amt = 6 + rand(8)

	air_contents.gas[GAS_PHORON] = phoron_amt
	air_contents.gas[GAS_OXYGEN] = oxygen_amt
	air_contents.update_values()
	SET_FLAGS(tank_flags, TANK_FLAG_WELDED | TANK_FLAG_WIRED)
	air_contents.temperature = PHORON_MINIMUM_BURN_TEMPERATURE-1

	var/obj/item/device/assembly_holder/H = new(src)
	proxyassembly.assembly = H
	H.master = proxyassembly

	H.update_icon()
	update_icon(TRUE)

/obj/item/tank/phoron/onetankbomb/Initialize()
	. = ..()
	onetankbomb()

/obj/item/tank/oxygen/onetankbomb/Initialize()
	. = ..()
	onetankbomb()

/////////////////////////////////
///Pulled from rewritten bomb.dm
/////////////////////////////////

/obj/item/device/tankassemblyproxy
	name = "tank assembly proxy"
	desc = "Used as a stand in to trigger single tank assemblies... but you shouldn't see this."
	var/obj/item/tank/tank = null
	var/obj/item/device/assembly_holder/assembly = null

/obj/item/device/tankassemblyproxy/receive_signal()	//This is mainly called by the sensor through sense() to the holder, and from the holder to here.
	if (!tank || !assembly)
		log_debug(append_admin_tools("A tank assembly received a signal but lacks a valid assembly holder.", usr, get_turf(src)))
		to_chat(usr, SPAN_DEBUG("A tank assembly associated with you attempted to ignite but failed because it lacks a valid assembly holder. Please ahelp this bug to be investigated in-round."))
		return
	tank.ignite()	//boom (or not boom if you made shijwtty mix)

/obj/item/tank/proc/assemble_bomb(W,user)	//Bomb assembly proc. This turns assembly+tank into a bomb
	var/obj/item/device/assembly_holder/S = W
	var/mob/M = user
	if(!S.secured)										//Check if the assembly is secured
		return
	if(isigniter(S.a_left) == isigniter(S.a_right))		//Check if either part of the assembly has an igniter, but if both parts are igniters, then fuck it
		return

	if(!M.unequip_item())
		return					//Remove the assembly from your hands
	if(!M.unEquip(src))
		return					//Remove the tank from your character,in case you were holding it
	M.put_in_hands(src)			//Equips the bomb if possible, or puts it on the floor.

	proxyassembly.assembly = S	//Tell the bomb about its assembly part
	S.master = proxyassembly	//Tell the assembly about its new owner
	S.forceMove(src)			//Move the assembly

	update_icon(TRUE)

/obj/item/tank/proc/ignite()	//This happens when a bomb is told to explode
	var/obj/item/device/assembly_holder/assy = proxyassembly.assembly
	var/ign = assy.a_right
	var/obj/item/other = assy.a_left

	if (isigniter(assy.a_left))
		ign = assy.a_left
		other = assy.a_right

	if(other)
		other.dropInto(get_turf(src))
	qdel(ign)
	assy.master = null
	proxyassembly.assembly = null
	qdel(assy)
	update_icon(TRUE)

	air_contents.add_thermal_energy(15000)

/obj/item/device/tankassemblyproxy/on_update_icon()
	tank.update_icon()

/obj/item/device/tankassemblyproxy/HasProximity(atom/movable/AM as mob|obj)
	if(assembly)
		assembly.HasProximity(AM)

//Fragmentation projectiles

/obj/item/projectile/bullet/pellet/fragment/tank
	name = "metal fragment"
	damage = 9  //Big chunks flying off.
	range_step = 1 //controls damage falloff with distance. projectiles lose a "pellet" each time they travel this distance. Can be a non-integer.

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	silenced = TRUE
	fire_sound = null
	no_attack_log = TRUE
	muzzle_type = null
	pellets = 1

/obj/item/projectile/bullet/pellet/fragment/tank/small
	name = "small metal fragment"
	damage = 6

/obj/item/projectile/bullet/pellet/fragment/tank/big
	name = "large metal fragment"
	damage = 17
