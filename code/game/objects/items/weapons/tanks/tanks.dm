#define TANK_MAX_RELEASE_PRESSURE (3*ONE_ATMOSPHERE)
#define TANK_DEFAULT_RELEASE_PRESSURE 24
#define TANK_IDEAL_PRESSURE 1015 //Arbitrary.

var/list/global/tank_gauge_cache = list()

/obj/item/weapon/tank
	name = "tank"
	icon = 'icons/obj/tank.dmi'

	var/gauge_icon = "indicator_tank"
	var/last_gauge_pressure
	var/gauge_cap = 6

	flags = CONDUCT
	slot_flags = SLOT_BACK
	w_class = 4

	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4


	sprite_sheets = list(
		"Resomi" = 'icons/mob/species/resomi/back.dmi'
		)

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

	description_info = "These tanks are utilised to store any of the various types of gaseous substances on the station. \
	They can be attached to various portable atmospheric devices on station to be filled or emptied. <br>\
	<br>\
	Each tank is fitted with an emergency relief valve. This relief valve will open if the tank is pressurised to over ~3000kPa or heated to over 173�C. \
	The valve itself will close after expending most or all of the contents into the air.<br>\
	<br>\
	Filling a tank such that experiences ~4000kPa of pressure will cause the tank to rupture, spilling out its contents and destroying the tank. \
	Tanks filled over ~5000kPa will rupture rather violently, exploding with significant force."

	description_antag = "Each tank may be incited to burn by attaching wires and an igniter assembly, though the igniter can only be used once and the mixture only burn if the igniter pushes a flammable gas mixture above the minimum burn temperature (126�C). \
	Wired and assembled tanks may be disarmed with a set of wirecutters. Any exploding or rupturing tank will generate shrapnel, assuming their relief valves have been welded beforehand. Even if not, they can be incited to expel hot gas on ignition if pushed above 173�C. \
	Relatively easy to make, the single tank bomb requries no tank transfer valve, and is still a fairly formidable weapon that can be manufactured from any tank."

/obj/item/weapon/tank/New()
	var/obj/item/device/tankassemblyproxy/proxy = new /obj/item/device/tankassemblyproxy()
	proxy.loc = src
	src.proxyassembly = proxy
	src.proxyassembly.tank = src
	..()

	src.air_contents = new /datum/gas_mixture()
	src.air_contents.volume = volume //liters
	src.air_contents.temperature = T20C
	processing_objects.Add(src)
	update_gauge()
	return

/obj/item/weapon/tank/Destroy()
	if(air_contents)
		qdel(air_contents)

	processing_objects.Remove(src)
	qdel(src.proxyassembly)

	if(istype(loc, /obj/item/device/transfer_valve))
		var/obj/item/device/transfer_valve/TTV = loc
		TTV.remove_tank(src)
		qdel(TTV)

	..()

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
		user << "<span class='notice'>\The [src] feels [descriptive].</span>"

	if(src.proxyassembly.assembly || wired)
		user << "<span class='warning'>It seems to have [wired? "some wires ": ""][wired && src.proxyassembly.assembly? "and ":""][src.proxyassembly.assembly ? "some sort of assembly ":""]attached to it.</span>"
	if(src.valve_welded)
		user << "<span class='warning'>\The [src] emergency relief valve has been welded shut!</span>"



/obj/item/weapon/tank/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(src.loc, /obj/item/assembly))
		icon = src.loc

	if ((istype(W, /obj/item/device/analyzer)) && get_dist(user, src) <= 1)
		var/obj/item/device/analyzer/A = W
		A.analyze_gases(src, user)
	else if (istype(W,/obj/item/latexballon))
		var/obj/item/latexballon/LB = W
		LB.blow(src)
		src.add_fingerprint(user)

	if(istype(W, /obj/item/stack/cable_coil))
		if(W:use(1))
			wired = 1
			user << "<span class='notice'>You attach the wires to the tank.</span>"
			src.add_bomb_overlay()

	if(istype(W, /obj/item/weapon/wirecutters))
		if(wired && src.proxyassembly.assembly)

			user << "<span class='notice'>You carefully begin clipping the wires that attach to the tank</span>"
			if(do_after(user, 100,src))
				wired = 0
				src.overlays -= "bomb_assembly"
				user << "<span class='notice'>You cut the wire and remove the device.</span>"

				var/obj/item/device/assembly_holder/assy = src.proxyassembly.assembly
				if(assy.a_left && assy.a_right)
					assy.loc = user.loc
					assy.master = null
					src.proxyassembly.assembly = null
				else
					if(!src.proxyassembly.assembly.a_left)
						assy.a_right.loc = usr.loc
						assy.a_right.holder = null
						assy.a_right = null
						src.proxyassembly.assembly = null
						qdel(assy)
				src.overlays.Cut()
				last_gauge_pressure = 0
				update_gauge()

			else
				user << "<span class='warning'>You slip and bump the igniter!</span>"
				if(prob(85))
					src.proxyassembly.receive_signal()

		else if(wired)
			if(do_after(user, 10, src))
				user << "<span class='notice'>You quickly clip the wire from the tank.</span>"
				wired = 0
				src.overlays -= "bomb_assembly"

		else
			user << "<span class='notice'>There are no wires to cut!</span>"



	if(istype(W, /obj/item/device/assembly_holder))
		if(wired)
			user << "<span class='notice'>You begin attaching the assembly to \the [src].</span>"
			if(do_after(user, 50, src))
				user << "<span class='notice'>You finish attaching the assembly to \the [src].</span>"
				bombers += "[key_name(user)] attached an assembly to a wired [src]. Temp: [src.air_contents.temperature-T0C]"
				message_admins("[key_name_admin(user)] attached an assembly to a wired [src]. Temp: [src.air_contents.temperature-T0C]")
				assemble_bomb(W,user)
			else
				user << "<span class='notice'>You stop attaching the assembly.</span>"
		else
			user << "<span class='notice'>You need to wire the device up first.</span>"


	if((istype(W, /obj/item/weapon/weldingtool) && W:remove_fuel(1,user)))
		if(!valve_welded)
			user << "<span class='notice'>You begin welding the \the [src] emergency pressure relief valve.</span>"
			if(do_after(user, 40,src))
				user << "<span class='notice'>You carefully weld \the [src] emergency pressure relief valve shut.</span><span class='warning'> \The [src] may now rupture under pressure!</span>"
				src.valve_welded = 1
			else
				bombers += "[key_name(user)] attempted to weld a [src]. [src.air_contents.temperature-T0C]"
				message_admins("[key_name_admin(user)] attempted to weld a [src]. [src.air_contents.temperature-T0C]")
				if(W:welding)
					user << "<span class='danger'>You accidentally rake \the [W] across \the [src]!</span>"
					maxintegrity -= rand(2,6)
					integrity = min(integrity,maxintegrity)
					src.air_contents.add_thermal_energy(rand(2000,50000))
			W:eyecheck(user)
		else
			user << "<span class='notice'>The emergency pressure relief valve has already been welded.</span>"
	add_fingerprint(user)



/obj/item/weapon/tank/attack_self(mob/user as mob)
	if (!(src.air_contents))
		return
	ui_interact(user)

// There's GOT to be a better way to do this
	if (src.proxyassembly.assembly)
		src.proxyassembly.assembly:attack_self(user)


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
		else if(istype(src.loc, /obj/item/weapon/rig) && src.loc in location)	// or the rig is in the mobs possession
			if(!location.internal)		// and they do not have any active internals
				mask_check = 1

		if(mask_check)
			if(location.wear_mask && (location.wear_mask.item_flags & AIRTIGHT))
				data["maskConnected"] = 1
			else if(istype(location, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = location
				if(H.head && (H.head.item_flags & AIRTIGHT))
					data["maskConnected"] = 1

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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

/obj/item/weapon/tank/Topic(href, href_list)
	..()
	if (usr.stat|| usr.restrained())
		return 0
	if (src.loc != usr)
		return 0

	if (href_list["dist_p"])
		if (href_list["dist_p"] == "reset")
			src.distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
		else if (href_list["dist_p"] == "max")
			src.distribute_pressure = TANK_MAX_RELEASE_PRESSURE
		else
			var/cp = text2num(href_list["dist_p"])
			src.distribute_pressure += cp
		src.distribute_pressure = min(max(round(src.distribute_pressure), 0), TANK_MAX_RELEASE_PRESSURE)
	if (href_list["stat"])
		if(istype(loc,/mob/living/carbon))
			var/mob/living/carbon/location = loc
			if(location.internal == src)
				location.internal = null
				location.internals.icon_state = "internal0"
				usr << "<span class='notice'>You close the tank release valve.</span>"
				if (location.internals)
					location.internals.icon_state = "internal0"
			else

				var/can_open_valve
				if(location.wear_mask && (location.wear_mask.item_flags & AIRTIGHT))
					can_open_valve = 1
				else if(istype(location,/mob/living/carbon/human))
					var/mob/living/carbon/human/H = location
					if(H.head && (H.head.item_flags & AIRTIGHT))
						can_open_valve = 1

				if(can_open_valve)
					location.internal = src
					usr << "<span class='notice'>You open \the [src] valve.</span>"
					if (location.internals)
						location.internals.icon_state = "internal1"
				else
					usr << "<span class='warning'>You need something to connect to \the [src].</span>"

	src.add_fingerprint(usr)
	return 1


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

/obj/item/weapon/tank/process()
	//Allow for reactions
	air_contents.react() //cooking up air tanks - add phoron and oxygen, then heat above PHORON_MINIMUM_BURN_TEMPERATURE
	if(gauge_icon)
		update_gauge()
	check_status()


/obj/item/weapon/tank/proc/add_bomb_overlay()
	if(src.wired)
		src.overlays += "bomb_assembly"
		if(src.proxyassembly.assembly)
			var/icon/test = getFlatIcon(src.proxyassembly.assembly)
			test.Shift(SOUTH,1)
			test.Shift(WEST,3)
			overlays += test


/obj/item/weapon/tank/proc/update_gauge()
	var/gauge_pressure = 0
	if(air_contents)
		gauge_pressure = air_contents.return_pressure()
		if(gauge_pressure > TANK_IDEAL_PRESSURE)
			gauge_pressure = -1
		else
			gauge_pressure = round((gauge_pressure/TANK_IDEAL_PRESSURE)*gauge_cap)

	if(gauge_pressure == last_gauge_pressure)
		return

	last_gauge_pressure = gauge_pressure
	overlays.Cut()
	add_bomb_overlay()
	var/indicator = "[gauge_icon][(gauge_pressure == -1) ? "overload" : gauge_pressure]"
	if(!tank_gauge_cache[indicator])
		tank_gauge_cache[indicator] = image(icon, indicator)
	overlays += tank_gauge_cache[indicator]






/obj/item/weapon/tank/proc/check_status()
	//Handle exploding, leaking, and rupturing of the tank

	if(!air_contents)
		return 0

	var/pressure = air_contents.return_pressure()


	if(pressure > TANK_LEAK_PRESSURE || air_contents.temperature - T0C > failure_temp)

		if(integrity <= 19 && !valve_welded)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			var/datum/gas_mixture/environment = loc.return_air()
			var/env_pressure = environment.return_pressure()
			var/tank_pressure = src.air_contents.return_pressure()

			var/release_ratio = Clamp(0.02, sqrt((tank_pressure-env_pressure)/tank_pressure),1)
			var/datum/gas_mixture/leaked_gas = air_contents.remove_ratio(release_ratio)
			//dynamic air release based on ambient pressure

			T.assume_air(leaked_gas)
			if(!leaking)
				visible_message("\icon[src] <span class='warning'>\The [src] relief valve flips open with a hiss!</span>", "You hear hissing.")
				playsound(src.loc, 'sound/effects/spray.ogg', 10, 1, -3)
				leaking = 1
				#ifdef FIREDBG
				log_debug("<span class='warning'>[x],[y] tank is leaking: [pressure] kPa, integrity [integrity]</span>")
				#endif


		else
			integrity-= 2


	if(pressure > TANK_FRAGMENT_PRESSURE)
		if(integrity <= 7)
			if(!istype(src.loc,/obj/item/device/transfer_valve))
				message_admins("Explosive tank rupture! last key to touch the tank was [src.fingerprintslast].")
				log_game("Explosive tank rupture! last key to touch the tank was [src.fingerprintslast].")

			//Give the gas a chance to build up more pressure through reacting
			air_contents.react()
			air_contents.react()
			air_contents.react()

			pressure = air_contents.return_pressure()
			var/strength = ((pressure-TANK_FRAGMENT_PRESSURE)/TANK_FRAGMENT_SCALE)
			var/mult = max(0.2,1 + log(2.6, (air_contents.total_moles/29)) ) //1 + log base 2 of standard sized full (room temperature) tanks
			var/fragments = round(rand(12,25)* sqrt(strength * mult)/8)

			var/turf/simulated/T = get_turf(src)
			T.hotspot_expose(src.air_contents.temperature, 70, 1)
			if(!T)
				return
			T.assume_air(air_contents)



			explosion(
				get_turf(loc),
				round(min(BOMBCAP_DVSTN_RADIUS, ((mult)*strength)*0.20)),
				round(min(BOMBCAP_HEAVY_RADIUS, ((mult)*strength)*0.40)),
				round(min(BOMBCAP_LIGHT_RADIUS, ((mult)*strength)*0.85)),
				round(min(BOMBCAP_FLASH_RADIUS, ((mult)*strength)*1.20)),
				)


			///frag code

			var/list/target_turfs = getcircle(T, 7)
			var/fragments_per_projectile = round(fragments/target_turfs.len)

			for(var/turf/O in target_turfs)
				sleep(0)
				var/fragtype = pick(/obj/item/projectile/bullet/pellet/fragment,/obj/item/projectile/bullet/pellet/fragment,/obj/item/projectile/bullet/pellet/fragment/strong)
				var/obj/item/projectile/bullet/pellet/fragment/P = new fragtype(T)

				P.pellets = fragments_per_projectile
				P.shot_from = src.name

				P.launch(O)

				//Make sure to hit any mobs in the source turf
				for(var/mob/living/M in T)

					//check if it's being held, if so, they're in a heap of trouble.
					if(P in M.contents && !M.lying)
						P.attack_mob(M, 0, 40)
					//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
					//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
					else if(M.lying && (isturf(src.loc) || P in M.contents) )
						P.attack_mob(M, 0, 0)
					else
						P.attack_mob(M, 0, 90) //otherwise, allow a decent amount of fragments to pass

			///////////////////////

			if(istype(loc, /obj/item/device/transfer_valve))
				var/obj/item/device/transfer_valve/TTV = loc
				TTV.remove_tank(src)
				qdel(TTV)


			if(src)
				qdel(src)

		else
			integrity -=7


	if(pressure > TANK_RUPTURE_PRESSURE)
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


			///Non-explosive Frag code

			var/strength = log(2,(pressure-TANK_RUPTURE_PRESSURE)/TANK_FRAGMENT_SCALE)+1
			var/mult = max(0.1,log(air_contents.total_moles/25)+1)
			var/fragments = round(rand(2,8)* strength * mult/20)


			var/list/target_turfs = getcircle(T, 7)
			var/fragments_per_projectile = round(fragments/target_turfs.len)

			for(var/turf/O in target_turfs)
				sleep(0)
				var/obj/item/projectile/bullet/pellet/fragment/P = new /obj/item/projectile/bullet/pellet/fragment(T)

				P.pellets = fragments_per_projectile
				P.shot_from = src.name

				P.launch(O)

				//Make sure to hit any mobs in the source turf
				for(var/mob/living/M in T)

					//check if it's being held, if so, they're in a heap of trouble.
					if(P in M.contents && !M.lying)
						P.attack_mob(M, 0, 40)
					//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
					//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
					else if(M.lying && (isturf(src.loc) || P in M.contents) )
						P.attack_mob(M, 0, 0)
					else
						P.attack_mob(M, 0, 90) //otherwise, allow a decent amount of fragments to pass


			//////////////////////////////////////////


			if(istype(loc, /obj/item/device/transfer_valve))
				var/obj/item/device/transfer_valve/TTV = loc
				TTV.remove_tank(src)



			qdel(src)


		else
			integrity-= 4

	if(integrity < maxintegrity)
		integrity++
		if(leaking)
			integrity++
		if(integrity == maxintegrity)
			leaking = 0










/////////////////////////////////
///Pulled from rewritten bomb.dm
/////////////////////////////////


/obj/item/device/tankassemblyproxy
	name = "Tank assembly proxy"
	desc = "Uused as a stand in to trigger single tank assemblies... but you shouldn't see this."
	var/obj/item/weapon/tank/tank = null
	var/obj/item/device/assembly_holder/assembly = null

/obj/item/device/tankassemblyproxy/New()
	..()


/obj/item/device/tankassemblyproxy/receive_signal()	//This is mainly called by the sensor through sense() to the holder, and from the holder to here.
	visible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
	sleep(15)
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

	src.proxyassembly.assembly = S	//Tell the bomb about its assembly part
	S.master = src.proxyassembly		//Tell the assembly about its new owner
	S.loc = src			//Move the assembly

	src.update_icon()


	src.add_bomb_overlay()

	return


/obj/item/weapon/tank/proc/ignite()	//This happens when a bomb is told to explode

	var/obj/item/device/assembly_holder/assy = src.proxyassembly.assembly
	var/ign = assy.a_right
	var/obj/item/other = assy.a_left

	if (isigniter(assy.a_left))
		ign = assy.a_left
		other = assy.a_right

	other.loc = get_turf(src)
	qdel(ign)
	assy.master = null
	src.proxyassembly.assembly = null
	qdel(assy)
	src.update_icon()
	src.update_gauge()

	air_contents.add_thermal_energy(9000)


/obj/item/device/tankassemblyproxy/update_icon()
	if(assembly)
		tank.update_icon()
		tank.overlays += "bomb_assembly"
	else
		tank.update_icon()
		tank.overlays -= "bomb_assembly"

////////Not sure what do with this or not.
/*
/obj/item/device/tank/attack_self(mob/user as mob) //pressing the bomb accesses its assembly
	bombassembly.attack_self(user, 1)
	add_fingerprint(user)
	return
*/

/obj/item/device/tankassemblyproxy/HasProximity(atom/movable/AM as mob|obj)
	if(src.assembly)
		src.assembly.HasProximity(AM)
