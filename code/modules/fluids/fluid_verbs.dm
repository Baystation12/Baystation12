/datum/admins/proc/spawn_fluid()
	set category = "Debug"
	set desc = "Spawn a fluid tile."
	set name = "Spawn Fluid"

	if(!check_rights(R_SPAWN)) return
	var/fluid_amt = input("Enter volume:") as num|null
	if(fluid_amt && isnum(fluid_amt))
		var/turf/simulated/T = get_turf(usr)
		if(!istype(T))
			usr << "<span class='danger'>Fluid can only be spawned on simulated turfs.</span>"
			return
		var/obj/effect/fluid/F = locate() in T
		if(!F) F = PoolOrNew(/obj/effect/fluid, T)
		F.set_depth(fluid_amt)
		log_admin("[key_name(usr)] spawned [fluid_amt] units of fluid at ([usr.x],[usr.y],[usr.z])")
	return

/datum/admins/proc/nuke_fluid()
	set category = "Debug"
	set desc = "Destroy all fluid tiles."
	set name = "Nuke Fluid"

	if(alert(usr, "Delete all fluids?","Fluid deletion","No","Yes") == "Yes")
		log_admin("[key_name(usr)] nuked all fluids.")
		for(var/obj/effect/fluid/F in world)
			F.evaporate()
			qdel(F)
		return

/datum/admins/proc/debug_fluid()
	set category = "Debug"
	set desc = "Check status of fluids (laggy)"
	set name = "Check Fluids"

	var/total_fluids = 0
	var/sleeping_fluids = 0
	var/average_depth = 0

	for(var/obj/effect/fluid/F in world)
		total_fluids++
		if(!(F in processing_fluids))
			sleeping_fluids++
		average_depth += F.depth

	usr << "[total_fluids] fluid\s, [sleeping_fluids] sleeping, average depth of [round(average_depth / max(1,total_fluids))]"
