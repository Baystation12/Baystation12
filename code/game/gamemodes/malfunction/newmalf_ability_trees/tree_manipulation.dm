// MANIPULATION TREE
//
// Abilities in this tree allow the AI to physically manipulate systems around the station.
// T1 - Electrical Pulse - Sends out pulse that breaks some lights and sometimes even APCs. This can actually break the AI's APC so be careful!
// T2 - Hack Camera - Allows the AI to hack a camera. Deactivated areas may be reactivated, and functional cameras can be upgraded.
// T3 - Emergency Forcefield - Allows the AI to project 1 tile forcefield that blocks movement and air flow. Forcefield´dissipates over time. It is also very susceptible to energetic weaponry.
// T4 - Machine Overload - Detonates machine of choice in a minor explosion. Two of these are usually enough to kill or K/O someone.


// BEGIN RESEARCH DATUMS

/datum/malf_research_ability/manipulation/electrical_pulse
	ability = new/datum/game_mode/malfunction/verb/electrical_pulse()
	price = 50
	next = new/datum/malf_research_ability/manipulation/hack_camera()
	name = "Electrical Pulse"


/datum/malf_research_ability/manipulation/hack_camera
	ability = new/datum/game_mode/malfunction/verb/hack_camera()
	price = 1200
	next = new/datum/malf_research_ability/manipulation/emergency_forcefield()
	name = "Hack Camera"


/datum/malf_research_ability/manipulation/emergency_forcefield
	ability = new/datum/game_mode/malfunction/verb/emergency_forcefield()
	price = 3000
	next = new/datum/malf_research_ability/manipulation/machine_overload()
	name = "Emergency Forcefield"


/datum/malf_research_ability/manipulation/machine_overload
	ability = new/datum/game_mode/malfunction/verb/machine_overload()
	price = 7500
	name = "Machine Overload"

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
	user << "Sending feedback pulse..."
	for(var/obj/machinery/power/apc/AP in machines)
		if(prob(5))
			AP.overload_lighting()
		if(prob(1) && prob(1)) // Very very small chance to actually destroy the APC.
			AP.set_broken()


/datum/game_mode/malfunction/verb/hack_camera(var/obj/machinery/camera/target in cameranet.cameras)
	set name = "Hack Camera"
	set desc = "100 CPU - Hacks existing camera, allowing you to add upgrade of your choice to it. Alternatively it lets you reactivate broken camera."
	set category = "Software"
	var/price = 100
	var/mob/living/silicon/ai/user = usr

	if(target && !istype(target))
		user << "This is not a camera."
		return

	if(!target)
		return

	if(!ability_prechecks(user, price))
		return

	var/action = input("Select required action: ") in list("Reset", "Add X-Ray", "Add Motion Sensor", "Add EMP Shielding")
	if(!action || !target)
		return

	switch(action)
		if("Reset")
			if(target.wires)
				if(!ability_pay(user, price))
					return
				target.reset_wires()
				user << "Camera reactivated."
		if("Add X-Ray")
			if(target.isXRay())
				user << "Camera already has X-Ray function."
				return
			else if(ability_pay(user, price))
				target.upgradeXRay()
				target.reset_wires()
				user << "X-Ray camera module enabled."
				return
		if("Add Motion Sensor")
			if(target.isMotion())
				user << "Camera already has Motion Sensor function."
				return
			else if(ability_pay(user, price))
				target.upgradeMotion()
				target.reset_wires()
				user << "Motion Sensor camera module enabled."
				return
		if("Add EMP Shielding")
			if(target.isEmpProof())
				user << "Camera already has EMP Shielding function."
				return
			else if(ability_pay(user, price))
				target.upgradeEmpProof()
				target.reset_wires()
				user << "EMP Shielding camera module enabled."
				return


/datum/game_mode/malfunction/verb/emergency_forcefield(var/turf/T as null|turf in world)
	set name = "Emergency Forcefield"
	set desc = "275 CPU - Uses station's emergency shielding system to create temporary barrier which lasts for few minutes, but won't resist gunfire."
	set category = "Software"
	var/price = 275
	var/mob/living/silicon/ai/user = usr
	if(!T || !istype(T))
		return
	if(!ability_prechecks(user, price) || !ability_pay(user, price))
		return

	user << "Emergency forcefield projection completed."
	new/obj/machinery/shield/malfai(T)
	user.hacking = 1
	spawn(20)
		user.hacking = 0


/datum/game_mode/malfunction/verb/machine_overload(obj/machinery/M in machines)
	set name = "Machine Overload"
	set desc = "400 CPU - Causes cyclic short-circuit in machine, resulting in weak explosion after some time."
	set category = "Software"
	var/price = 400
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	if(!istype(M))
		user << "<span class='notice'>ERROR: Unable to overload - target is not a machine.</span>"
		return

	if(!M.use_power || M.inoperable())
		user << "<span class='notice'>ERROR: Unable to overload - target is not connected to active power grid.</span>"
		return

	M.use_power(1000000) // Major power spike, few of these will completely burn APC's cell - equivalent of 1GJ of power.

	// Trigger a powernet alarm. Careful engineers will probably notice something is going on.
	var/area/temp_area = get_area(M)
	if(temp_area)
		var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()
		if(temp_apc && temp_apc.terminal && temp_apc.terminal.powernet)
			temp_apc.terminal.powernet.trigger_warning()


	if(!ability_pay(user,price))
		return

	M.visible_message("<span class='notice'>BZZZZZZZT</span>")
	spawn(50)
		// machinery/power is directly connected to powernet. Resulting explosion will be a bit stronger. This should be enough to kill someone standing next to the machine.
		if(istype(M, /obj/machinery/power))
			explosion(get_turf(M), 1,2,4,4)
		else
			explosion(get_turf(M), 0,1,2,4)
		if(M)
			qdel(M)

// END ABILITY VERBS