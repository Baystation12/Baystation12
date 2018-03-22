#define TANK_MAX_RELEASE_PRESSURE (3*ONE_ATMOSPHERE)
#define TANK_DEFAULT_RELEASE_PRESSURE 24
#define TANK_IDEAL_PRESSURE 1015 //Arbitrary.

var/list/global/tank_gauge_cache = list()

/obj/item/weapon/tank
	name = "tank"
	icon = 'icons/obj/tank.dmi'

	var/gauge_icon = "indicator_tank"
	var/gauge_cap = 6

	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_LARGE

	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4

	var/datum/gas_mixture/air_contents = null
	var/distribute_pressure = ONE_ATMOSPHERE
	var/integrity = 20
	var/maxintegrity = 20
	var/valve_welded = 0
	var/obj/item/device/tankassemblyproxy/proxyassembly

	var/volume = 70
	var/manipulated_by = null		//Used by _onclick/hud/screen_objects.dm internals to determine if someone has messed with our tank or not.
						//If they have and we haven't scanned it with the PDA or gas analyzer then we might just breath whatever they put in it.

	var/failure_temp = 173 //173 deg C Borate seal (yes it should be 153 F, but that's annoying)
	var/leaking = 0
	var/wired = 0

	var/list/starting_pressure //list in format 'xgm gas id' = 'desired pressure at start'

	description_info = "These tanks are utilised to store any of the various types of gaseous substances. \
	They can be attached to various portable atmospheric devices to be filled or emptied. <br>\
	<br>\
	Each tank is fitted with an emergency relief valve. This relief valve will open if the tank is pressurised to over ~3000kPa or heated to over 173�C. \
	The valve itself will close after expending most or all of the contents into the air.<br>\
	<br>\
	Filling a tank such that experiences ~4000kPa of pressure will cause the tank to rupture, spilling out its contents and destroying the tank. \
	Tanks filled over ~5000kPa will rupture rather violently, exploding with significant force."

	description_antag = "Each tank may be incited to burn by attaching wires and an igniter assembly, though the igniter can only be used once and the mixture only burn if the igniter pushes a flammable gas mixture above the minimum burn temperature (126�C). \
	Wired and assembled tanks may be disarmed with a set of wirecutters. Any exploding or rupturing tank will generate shrapnel, assuming their relief valves have been welded beforehand. Even if not, they can be incited to expel hot gas on ignition if pushed above 173�C. \
	Relatively easy to make, the single tank bomb requries no tank transfer valve, and is still a fairly formidable weapon that can be manufactured from any tank."


/obj/item/weapon/tank/Initialize()
	. = ..()
	proxyassembly = new /obj/item/device/tankassemblyproxy(src)
	proxyassembly.tank = src

	air_contents = new /datum/gas_mixture(volume, T20C)
	for(var/gas in starting_pressure)
		air_contents.adjust_gas(gas, starting_pressure[gas]*volume/(R_IDEAL_GAS_EQUATION*T20C), 0)
	air_contents.update_values()

	START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/weapon/tank/Destroy()
	QDEL_NULL(air_contents)

	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(proxyassembly)

	if(istype(loc, /obj/item/device/transfer_valve))
		var/obj/item/device/transfer_valve/TTV = loc
		TTV.remove_tank(src)
		qdel(TTV)

	. = ..()

/obj/item/weapon/tank/examine(mob/user)
	. = ..(user, 0)
	if(.)
		var/celsius_temperature = air_contents.temperature - T0C
		var/descriptive
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
		to_chat(user, "<span class='notice'>\The [src] feels [descriptive].</span>")

	if(proxyassembly.assembly || wired)
		to_chat(user, "<span class='warning'>It seems to have [wired? "some wires ": ""][wired && proxyassembly.assembly? "and ":""][proxyassembly.assembly ? "some sort of assembly ":""]attached to it.</span>")
	if(valve_welded)
		to_chat(user, "<span class='warning'>\The [src] emergency relief valve has been welded shut!</span>")


/obj/item/weapon/tank/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(loc, /obj/item/assembly))
		icon = loc

	if (istype(W, /obj/item/device/analyzer))
		return
	
	if (istype(W,/obj/item/latexballon))
		var/obj/item/latexballon/LB = W
		LB.blow(src)
		add_fingerprint(user)

	if(isCoil(W))
		var/obj/item/stack/cable_coil/C = W
		if(C.use(1))
			wired = 1
			to_chat(user, "<span class='notice'>You attach the wires to the tank.</span>")
			update_icon()

	if(isWirecutter(W))
		if(wired && proxyassembly.assembly)

			to_chat(user, "<span class='notice'>You carefully begin clipping the wires that attach to the tank.</span>")
			if(do_after(user, 100,src))
				wired = 0
				to_chat(user, "<span class='notice'>You cut the wire and remove the device.</span>")

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
				update_icon()

			else
				to_chat(user, "<span class='danger'>You slip and bump the igniter!</span>")
				if(prob(85))
					proxyassembly.receive_signal()

		else if(wired)
			if(do_after(user, 10, src))
				to_chat(user, "<span class='notice'>You quickly clip the wire from the tank.</span>")
				wired = 0
				update_icon()

		else
			to_chat(user, "<span class='notice'>There are no wires to cut!</span>")

	if(istype(W, /obj/item/device/assembly_holder))
		if(wired)
			to_chat(user, "<span class='notice'>You begin attaching the assembly to \the [src].</span>")
			if(do_after(user, 50, src))
				to_chat(user, "<span class='notice'>You finish attaching the assembly to \the [src].</span>")
				GLOB.bombers += "[key_name(user)] attached an assembly to a wired [src]. Temp: [air_contents.temperature-T0C]"
				message_admins("[key_name_admin(user)] attached an assembly to a wired [src]. Temp: [air_contents.temperature-T0C]")
				assemble_bomb(W,user)
			else
				to_chat(user, "<span class='notice'>You stop attaching the assembly.</span>")
		else
			to_chat(user, "<span class='notice'>You need to wire the device up first.</span>")

	if(isWelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(1,user))
			if(!valve_welded)
				to_chat(user, "<span class='notice'>You begin welding the \the [src] emergency pressure relief valve.</span>")
				if(do_after(user, 40,src))
					to_chat(user, "<span class='notice'>You carefully weld \the [src] emergency pressure relief valve shut.</span><span class='warning'> \The [src] may now rupture under pressure!</span>")
					valve_welded = 1
					leaking = 0
				else
					GLOB.bombers += "[key_name(user)] attempted to weld a [src]. [air_contents.temperature-T0C]"
					message_admins("[key_name_admin(user)] attempted to weld a [src]. [air_contents.temperature-T0C]")
					if(WT.welding)
						to_chat(user, "<span class='danger'>You accidentally rake \the [W] across \the [src]!</span>")
						maxintegrity -= rand(2,6)
						integrity = min(integrity,maxintegrity)
						air_contents.add_thermal_energy(rand(2000,50000))
				WT.eyecheck(user)
			else
				to_chat(user, "<span class='notice'>The emergency pressure relief valve has already been welded.</span>")
		add_fingerprint(user)



/obj/item/weapon/tank/attack_self(mob/user as mob)
	add_fingerprint(user)
	if (!air_contents)
		return
	ui_interact(user)

// There's GOT to be a better way to do this
	if (proxyassembly.assembly)
		proxyassembly.assembly.attack_self(user)


/obj/item/weapon/tank/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/mob/living/carbon/location = null

	if(istype(loc, /obj/item/weapon/rig))		// check for tanks in rigs
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
	data["tankPressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["releasePressure"] = round(distribute_pressure ? distribute_pressure : 0)
	data["defaultReleasePressure"] = round(TANK_DEFAULT_RELEASE_PRESSURE)
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
		else if(istype(loc, /obj/item/weapon/rig) && loc in location)	// or the rig is in the mobs possession
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
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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

/obj/item/weapon/tank/Topic(user, href_list, state = GLOB.inventory_state)
	..()

/obj/item/weapon/tank/OnTopic(user, href_list)
	if (href_list["dist_p"])
		if (href_list["dist_p"] == "reset")
			distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
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

/obj/item/weapon/tank/proc/toggle_valve(var/mob/user)
	if(istype(loc,/mob/living/carbon))
		var/mob/living/carbon/location = loc
		if(location.internal == src)
			location.internal = null
			location.internals.icon_state = "internal0"
			to_chat(user, "<span class='notice'>You close the tank release valve.</span>")
			if (location.internals)
				location.internals.icon_state = "internal0"
		else
			var/can_open_valve
			if(location.wear_mask && (location.wear_mask.item_flags & ITEM_FLAG_AIRTIGHT))
				can_open_valve = 1
			else if(istype(location,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = location
				if(H.head && (H.head.item_flags & ITEM_FLAG_AIRTIGHT))
					can_open_valve = 1

			if(can_open_valve)
				location.internal = src
				to_chat(user, "<span class='notice'>You open \the [src] valve.</span>")
				if (location.internals)
					location.internals.icon_state = "internal1"
			else
				to_chat(user, "<span class='warning'>You need something to connect to \the [src].</span>")

/obj/item/weapon/tank/remove_air(amount)
	return air_contents.remove(amount)

/obj/item/weapon/tank/return_air()
	return air_contents

/obj/item/weapon/tank/assume_air(datum/gas_mixture/giver)
	air_contents.merge(giver)

	check_status()
	return 1

/obj/item/weapon/tank/proc/remove_air_volume(volume_to_return)
	if(!air_contents)
		return null

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < distribute_pressure)
		distribute_pressure = tank_pressure

	var/moles_needed = distribute_pressure*volume_to_return/(R_IDEAL_GAS_EQUATION*air_contents.temperature)

	return remove_air(moles_needed)

/obj/item/weapon/tank/Process()
	//Allow for reactions
	air_contents.react() //cooking up air tanks - add phoron and oxygen, then heat above PHORON_MINIMUM_BURN_TEMPERATURE
	update_icon()
	check_status()

/obj/item/weapon/tank/update_icon()
	overlays.Cut()
	if(proxyassembly.assembly || wired)
		overlays += image(icon,"bomb_assembly")
		if(proxyassembly.assembly)
			var/image/bombthing = image(proxyassembly.assembly.icon, proxyassembly.assembly.icon_state)
			bombthing.overlays |= proxyassembly.assembly.overlays
			bombthing.pixel_y = -1
			bombthing.pixel_x = -3
			overlays += bombthing

	if(!gauge_icon)
		return

	var/gauge_pressure = 0
	if(air_contents)
		gauge_pressure = air_contents.return_pressure()
		if(gauge_pressure > TANK_IDEAL_PRESSURE)
			gauge_pressure = -1
		else
			gauge_pressure = round((gauge_pressure/TANK_IDEAL_PRESSURE)*gauge_cap)
	
	var/indicator = "[gauge_icon][(gauge_pressure == -1) ? "overload" : gauge_pressure]"
	if(!tank_gauge_cache[indicator])
		tank_gauge_cache[indicator] = image(icon, indicator)
	overlays += tank_gauge_cache[indicator]

//Handle exploding, leaking, and rupturing of the tank
/obj/item/weapon/tank/proc/check_status()
	if(!air_contents)
		return 0

	var/pressure = air_contents.return_pressure()

	if(pressure > TANK_FRAGMENT_PRESSURE)
		if(integrity <= 7)
			if(!istype(loc,/obj/item/device/transfer_valve))
				message_admins("Explosive tank rupture! last key to touch the tank was [fingerprintslast].")
				log_game("Explosive tank rupture! last key to touch the tank was [fingerprintslast].")

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
			explosion(
				get_turf(loc),
				round(min(BOMBCAP_DVSTN_RADIUS, ((mult)*strength)*0.15)),
				round(min(BOMBCAP_HEAVY_RADIUS, ((mult)*strength)*0.35)),
				round(min(BOMBCAP_LIGHT_RADIUS, ((mult)*strength)*0.80)),
				round(min(BOMBCAP_FLASH_RADIUS, ((mult)*strength)*1.20)),
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
		log_debug("<span class='warning'>[x],[y] tank is rupturing: [pressure] kPa, integrity [integrity]</span>")
		#endif

		if(integrity <= 0)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			T.assume_air(air_contents)
			playsound(get_turf(src), 'sound/weapons/gunshot/shotgun.ogg', 20, 1)
			visible_message("\icon[src] <span class='danger'>\The [src] flies apart!</span>", "<span class='warning'>You hear a bang!</span>")
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
	else if(pressure > TANK_LEAK_PRESSURE || air_contents.temperature - T0C > failure_temp)
		if((integrity <= 19 || leaking) && !valve_welded)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			var/datum/gas_mixture/environment = loc.return_air()
			var/env_pressure = environment.return_pressure()
			var/tank_pressure = air_contents.return_pressure()

			var/release_ratio = Clamp(0.002, sqrt(max(tank_pressure-env_pressure,0)/tank_pressure),1)
			var/datum/gas_mixture/leaked_gas = air_contents.remove_ratio(release_ratio)
			//dynamic air release based on ambient pressure

			T.assume_air(leaked_gas)
			if(!leaking)
				visible_message("\icon[src] <span class='warning'>\The [src] relief valve flips open with a hiss!</span>", "You hear hissing.")
				playsound(loc, 'sound/effects/spray.ogg', 10, 1, -3)
				leaking = 1
				#ifdef FIREDBG
				log_debug("<span class='warning'>[x],[y] tank is leaking: [pressure] kPa, integrity [integrity]</span>")
				#endif
		else
			integrity-= 2
	else
		if(integrity < maxintegrity)
			integrity++
			if(leaking)
				integrity++
			if(integrity == maxintegrity)
				leaking = 0

/////////////////////////////////
///Prewelded tanks
/////////////////////////////////

/obj/item/weapon/tank/phoron/welded
	valve_welded = 1
/obj/item/weapon/tank/oxygen/welded
	valve_welded = 1

/////////////////////////////////
///Onetankbombs (added as actual items)
/////////////////////////////////

/obj/item/weapon/tank/proc/onetankbomb()
	var/phoron_amt = 4 + rand(4)
	var/oxygen_amt = 6 + rand(8)

	air_contents.gas["phoron"] = phoron_amt
	air_contents.gas["oxygen"] = oxygen_amt
	air_contents.update_values()
	valve_welded = 1
	air_contents.temperature = PHORON_MINIMUM_BURN_TEMPERATURE-1

	wired = 1

	var/obj/item/device/assembly_holder/H = new(src)
	proxyassembly.assembly = H
	H.master = proxyassembly

	H.update_icon()
	update_icon()

/obj/item/weapon/tank/phoron/onetankbomb/Initialize()
	. = ..()
	onetankbomb()

/obj/item/weapon/tank/oxygen/onetankbomb/Initialize()
	. = ..()
	onetankbomb()

/////////////////////////////////
///Pulled from rewritten bomb.dm
/////////////////////////////////

/obj/item/device/tankassemblyproxy
	name = "Tank assembly proxy"
	desc = "Used as a stand in to trigger single tank assemblies... but you shouldn't see this."
	var/obj/item/weapon/tank/tank = null
	var/obj/item/device/assembly_holder/assembly = null

/obj/item/device/tankassemblyproxy/receive_signal()	//This is mainly called by the sensor through sense() to the holder, and from the holder to here.
	tank.ignite()	//boom (or not boom if you made shijwtty mix)

/obj/item/weapon/tank/proc/assemble_bomb(W,user)	//Bomb assembly proc. This turns assembly+tank into a bomb
	var/obj/item/device/assembly_holder/S = W
	var/mob/M = user
	if(!S.secured)										//Check if the assembly is secured
		return
	if(isigniter(S.a_left) == isigniter(S.a_right))		//Check if either part of the assembly has an igniter, but if both parts are igniters, then fuck it
		return

	M.drop_item()			//Remove the assembly from your hands
	M.remove_from_mob(src)	//Remove the tank from your character,in case you were holding it
	M.put_in_hands(src)		//Equips the bomb if possible, or puts it on the floor.

	proxyassembly.assembly = S	//Tell the bomb about its assembly part
	S.master = proxyassembly	//Tell the assembly about its new owner
	S.forceMove(src)			//Move the assembly

	update_icon()

/obj/item/weapon/tank/proc/ignite()	//This happens when a bomb is told to explode
	var/obj/item/device/assembly_holder/assy = proxyassembly.assembly
	var/ign = assy.a_right
	var/obj/item/other = assy.a_left

	if (isigniter(assy.a_left))
		ign = assy.a_left
		other = assy.a_right

	other.dropInto(get_turf(src))
	qdel(ign)
	assy.master = null
	proxyassembly.assembly = null
	qdel(assy)
	update_icon()

	air_contents.add_thermal_energy(15000)

/obj/item/device/tankassemblyproxy/update_icon()
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

	silenced = 1
	fire_sound = null
	no_attack_log = 1
	muzzle_type = null
	pellets = 1

/obj/item/projectile/bullet/pellet/fragment/tank/small
	name = "small metal fragment"
	damage = 6

/obj/item/projectile/bullet/pellet/fragment/tank/big
	name = "large metal fragment"
	damage = 17

