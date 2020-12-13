GLOBAL_VAR_INIT(MOBILE_SPAWN_RESPAWN_TIME,8 MINUTES)

/datum/mobile_spawn
	var/is_spawn_active = 0

	var/spawn_faction = "neutral"
	var/list/species_outfits = list() // species name = newlist(outfits)
	var/list/whitelisted_species = list() //species name = whitelist name

	var/resource_pool = 100 //Arbitrary resources.
	var/access_list = list() //Our basic access list.
	var/list/acquirable_items = list() //item name = typepath, autofilled by system.
	var/list/item_costs = list() //item typepath = cost
	var/emp_toggle_time = 0
	var/emp_respawn = FALSE
	var/max_spawns = -1
	var/obj/vehicles/owner

/datum/mobile_spawn/New()
	for(var/item in item_costs)
		var/obj/temp_item = new item
		acquirable_items[temp_item.name] = item
		qdel(temp_item)
	for(var/species in species_outfits)
		var/list/holder_list = species_outfits[species]
		for(var/outfit in holder_list)
			var/outfit_ref = outfit_by_type(outfit)
			if(!outfit_ref)
				log_debug("An outfit ([outfit]) in a mobile spawn datum ([type]) failed to obtain a reference")
				continue
			holder_list -= outfit
			holder_list += outfit_ref

/datum/mobile_spawn/proc/process_resource_regen(var/amt = 0.5)

	//should we re-enable after an EMP?
	if(emp_toggle_time)
		if(world.time > emp_toggle_time)
			emp_toggle_time = 0
			if(emp_respawn)
				owner.set_mobile_spawn_deploy(TRUE)
				emp_respawn = FALSE
	else
		resource_pool = min(100,resource_pool+amt)

/datum/mobile_spawn/proc/handle_requisition(var/mob/user)
	var/item_requisition = input(user,"What item do you want to requisition? ([resource_pool]/[initial(resource_pool)] resources left)","Item Requisition","Cancel") in acquirable_items + list("Cancel")
	if(item_requisition == "Cancel")
		return
	if(item_costs[item_requisition] > resource_pool)
		to_chat(user,"<span class='warning'>Insufficient requisition points.</span>")
		return
	var/confirm = alert(user,"[item_requisition] will cost [item_costs[item_requisition]] resources to obtain. Confirm?","Confirmation","Yes","No")
	if(confirm == "No")
		return
	new item_requisition(owner.loc)
	resource_pool -= item_costs[item_requisition]

/datum/mobile_spawn/proc/handle_spawn(var/mob/user)
	if(GLOB.MOBILE_SPAWN_RESPAWN_TIME == -1)
		to_chat(user,"<span class = 'notice'>Mobile respawn is disabled.</span>")
		return
	if(world.time - user.timeofdeath < GLOB.MOBILE_SPAWN_RESPAWN_TIME)
		to_chat(user,"<span class = 'notice'>You have not been dead long enough to respawn at a mobile spawn point.</span>")
		return
	var/species_choice = input(user,"Spawn as what species?","Species Spawn Choice","Cancel") in species_outfits + list("Cancel")
	if(species_choice == "Cancel")
		return
	if(species_choice in whitelisted_species)
		var/whitelist_req = whitelisted_species[species_choice]
		if(!whitelist_lookup(whitelist_req, user.ckey))
			to_chat(user,"<span class = 'notice'>You are not whitelisted to this faction.</span>")
			return 0
	var/decl/hierarchy/outfit/outfit_choice = input(user,"Spawn with what loadout?","Loadout Choice","Cancel") in species_outfits[species_choice] + list("Cancel")
	if(outfit_choice == "Cancel")
		return

	var/mob/living/carbon/human/h = new(owner.loc,species_choice)
	h.faction = spawn_faction
	outfit_choice.equip(h)
	h.ckey = user.ckey
	var/obj/item/weapon/card/id/id = h.GetIdCard()
	var/obj/item/organ/internal/stack/lace = h.GetLace()
	if(id)
		id.access = access_list
	if(lace)
		lace.access = access_list
	qdel(user)
	var/datum/faction/ourfaction = GLOB.factions_by_name[spawn_faction]
	if(ourfaction && h.mind)
		//The following chunk of code is copied from job.dm, line 80.
		ourfaction.assigned_minds.Add(h.mind)
		ourfaction.living_minds.Add(h.mind)
		for(var/datum/objective/O in ourfaction.all_objectives)
			h.mind.objectives.Add(O)
		show_objectives(h.mind)
	max_spawns--
	if(!max_spawns)
		owner.set_mobile_spawn_deploy(FALSE)

/datum/mobile_spawn/covenant
	spawn_faction = "Covenant"
	species_outfits = list("Unggoy" = list(/decl/hierarchy/outfit/mobilespawn_unggoy/major,/decl/hierarchy/outfit/mobilespawn_unggoy/medic,/decl/hierarchy/outfit/mobilespawn_unggoy/engineer,/decl/hierarchy/outfit/mobilespawn_unggoy_grenadier))

/datum/mobile_spawn/unsc
	spawn_faction = "UNSC"
	access_list = list(access_unsc,144,192)
	species_outfits = list("Human" = list(/decl/hierarchy/outfit/job/mobilespawn_marine,/decl/hierarchy/outfit/job/mobilespawn_marine/engineer,/decl/hierarchy/outfit/job/mobilespawn_marine/medic))

/datum/mobile_spawn/innie
	spawn_faction = "Insurrection"
	access_list = list(access_innie)
	species_outfits = list("Human" = list(/decl/hierarchy/outfit/job/mobilespawn_innie,/decl/hierarchy/outfit/job/mobilespawn_innie/engineer,/decl/hierarchy/outfit/job/mobilespawn_innie/medic,/decl/hierarchy/outfit/job/mobilespawn_gladiator))
