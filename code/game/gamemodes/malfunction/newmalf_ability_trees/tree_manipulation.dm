// MANIPULATION TREE
//
// Abilities in this tree allow the AI to physically manipulate systems around the station.
// T1 - Electrical Pulse - Sends out pulse that breaks some lights and sometimes even APCs. This can actually break the AI's APC so be careful!
// T2 - Reboot camera - Allows the AI to reactivate a camera.
// T3 - Emergency Forcefield - Allows the AI to project 1 tile forcefield that blocks movement and air flow. Forcefield´dissipates over time. It is also very susceptible to energetic weaponry.
// T4 - Machine Overload - Detonates machine of choice in a minor explosion. Two of these are usually enough to kill or K/O someone.
// T5 - Machine Upgrade - Upgrades a machine of choice. Upgrade behavior can be defined for each machine independently.


// BEGIN RESEARCH DATUMS

/datum/malf_research_ability/manipulation/electrical_pulse
	ability = new/datum/game_mode/malfunction/verb/electrical_pulse()
	price = 250
	next = new/datum/malf_research_ability/manipulation/reboot_camera()
	name = "T1 - Electrical Pulse"


/datum/malf_research_ability/manipulation/reboot_camera
	ability = new/datum/game_mode/malfunction/verb/reboot_camera()
	price = 1000
	next = new/datum/malf_research_ability/manipulation/emergency_forcefield()
	name = "T2 - Reboot Camera"


/datum/malf_research_ability/manipulation/emergency_forcefield
	ability = new/datum/game_mode/malfunction/verb/emergency_forcefield()
	price = 2000
	next = new/datum/malf_research_ability/manipulation/machine_overload()
	name = "T3 - Emergency Forcefield"


/datum/malf_research_ability/manipulation/machine_overload
	ability = new/datum/game_mode/malfunction/verb/machine_overload()
	price = 4000
	next = new/datum/malf_research_ability/manipulation/machine_upgrade()
	name = "T4 - Machine Overload"

/datum/malf_research_ability/manipulation/machine_upgrade
	ability = new/datum/game_mode/malfunction/verb/machine_upgrade()
	price = 4000
	name = "T5 - Machine Upgrade"

// END RESEARCH DATUMS
// BEGIN ABILITY VERBS

/datum/game_mode/malfunction/verb/electrical_pulse()
	set name = "Electrical Pulse"
	set desc = "15 CPU - Sends feedback pulse through station's power grid, overloading some sensitive systems, such as lights."
	set category = "Software"
	var/price = 15
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price) || !ability_pay(user,price))
		return
	to_chat(user, "Sending feedback pulse...")
	for(var/obj/machinery/power/apc/AP in machines)
		if(prob(5))
			AP.overload_lighting()
		if(prob(2.5) && (get_area(AP) != get_area(user))) // Very very small chance to actually destroy the APC, but not if the APC is powering the AI.
			AP.set_broken()
	user.hacking = 1
	log_ability_use(user, "electrical pulse")
	spawn(15 SECONDS)
		user.hacking = 0

/datum/game_mode/malfunction/verb/reboot_camera(var/obj/machinery/camera/target in cameranet.cameras)
	set name = "Reboot Camera"
	set desc = "100 CPU - Reboots a damaged but not completely destroyed camera."
	set category = "Software"
	var/price = 100
	var/mob/living/silicon/ai/user = usr

	if(target && !istype(target))
		to_chat(user, "This is not a camera.")
		return

	if(!target)
		return

	if(!ability_prechecks(user, price) || !ability_pay(user, price))
		return

	target.stat = initial(target.stat)
	target.reset_wires()
	target.update_icon()
	target.update_coverage()
	to_chat(user, "Camera reactivated.")
	log_ability_use(user, "reset camera", target)


/datum/game_mode/malfunction/verb/emergency_forcefield(var/turf/T as turf in world)
	set name = "Emergency Forcefield"
	set desc = "275 CPU - Uses station's emergency shielding system to create temporary barrier which lasts for few minutes, but won't resist gunfire."
	set category = "Software"
	var/price = 275
	var/mob/living/silicon/ai/user = usr
	if(!T || !istype(T))
		return
	if(!ability_prechecks(user, price) || !ability_pay(user, price))
		return

	to_chat(user, "Emergency forcefield projection completed.")
	new/obj/machinery/shield/malfai(T)
	user.hacking = 1
	log_ability_use(user, "emergency forcefield", T)
	spawn(2 SECONDS)
		user.hacking = 0


/datum/game_mode/malfunction/verb/machine_overload(obj/machinery/M in machines)
	set name = "Machine Overload"
	set desc = "400 CPU - Causes cyclic short-circuit in machine, resulting in weak explosion after some time."
	set category = "Software"
	var/price = 400
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	var/obj/machinery/power/N = M

	var/explosion_intensity = 2

	// Verify if we can overload the target, if yes, calculate explosion strength. Some things have higher explosion strength than others, depending on charge(APCs, SMESs)
	if(N && istype(N)) // /obj/machinery/power first, these create bigger explosions due to direct powernet connection
		if(!istype(N, /obj/machinery/power/apc) && !istype(N, /obj/machinery/power/smes/buildable) && (!N.powernet || !N.powernet.avail)) // Directly connected machine which is not an APC or SMES. Either it has no powernet connection or it's powernet does not have enough power to overload
			to_chat(user, "<span class='notice'>ERROR: Low network voltage. Unable to overload. Increase network power level and try again.</span>")
			return
		else if (istype(N, /obj/machinery/power/apc)) // APC. Explosion is increased by available cell power.
			var/obj/machinery/power/apc/A = N
			if(A.cell && A.cell.charge)
				explosion_intensity = 4 + round((A.cell.charge / CELLRATE) / 100000)
			else
				to_chat(user, "<span class='notice'>ERROR: APC Malfunction - Cell depleted or removed. Unable to overload.</span>")
				return
		else if (istype(N, /obj/machinery/power/smes/buildable)) // SMES. These explode in a very very very big boom. Similar to magnetic containment failure when messing with coils.
			var/obj/machinery/power/smes/buildable/S = N
			if(S.charge && S.RCon)
				explosion_intensity = 4 + round((S.charge / CELLRATE) / 100000)
			else
				// Different error texts
				if(!S.charge)
					to_chat(user, "<span class='notice'>ERROR: SMES Depleted. Unable to overload. Please charge SMES unit and try again.</span>")
				else
					to_chat(user, "<span class='notice'>ERROR: SMES RCon error - Unable to reach destination. Please verify wire connection.</span>")
				return
	else if(M && istype(M)) // Not power machinery, so it's a regular machine instead. These have weak explosions.
		if(!M.use_power) // Not using power at all
			to_chat(user, "<span class='notice'>ERROR: No power grid connection. Unable to overload.</span>")
			return
		if(M.inoperable()) // Not functional
			to_chat(user, "<span class='notice'>ERROR: Unknown error. Machine is probably damaged or power supply is nonfunctional.</span>")
			return
	else // Not a machine at all (what the hell is this doing in Machines list anyway??)
		to_chat(user, "<span class='notice'>ERROR: Unable to overload - target is not a machine.</span>")
		return

	explosion_intensity = min(explosion_intensity, 12) // 3, 6, 12 explosion cap

	if(!ability_pay(user,price))
		return

	M.use_power(250 KILOWATTS)

	// Trigger a powernet alarm. Careful engineers will probably notice something is going on.
	var/area/temp_area = get_area(M)
	if(temp_area)
		var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()
		if(temp_apc && temp_apc.terminal && temp_apc.terminal.powernet)
			temp_apc.terminal.powernet.trigger_warning(50) // Long alarm
			 // Such power surges are not good for APC electronics/cell in general.
			if(prob(explosion_intensity))
				temp_apc.emp_act(1)


	log_ability_use(user, "machine overload", M)
	M.visible_message("<span class='notice'>BZZZZZZZT</span>")
	spawn(5 SECONDS)
		explosion(get_turf(M), round(explosion_intensity/4),round(explosion_intensity/2),round(explosion_intensity),round(explosion_intensity * 2))
		if(M)
			qdel(M)


/datum/game_mode/malfunction/verb/machine_upgrade(obj/machinery/M in machines)
	set name = "Machine Upgrade"
	set desc = "800 CPU - Pushes existing hardware to it's technological limits by rapidly upgrading it's software."
	set category = "Software"
	var/price = 800
	var/mob/living/silicon/ai/user = usr

	if(!M)
		return

	if(!ability_prechecks(user, price))
		return

	if(M.malf_upgraded)
		to_chat(user, "\The [M] has already been upgraded.")
		return

	if(!M.malf_upgrade(user))
		to_chat(user, "\The [M] cannot be upgraded.")
		return

	ability_pay(user,price)

// END ABILITY VERBS