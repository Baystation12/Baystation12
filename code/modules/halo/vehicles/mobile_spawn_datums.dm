
#define MOBILE_SPAWN_RESPAWN_TIME 5 MINUTES

/datum/mobile_spawn
	var/is_spawn_active = 0

	var/spawn_faction = "neutral"
	var/list/species_outfits = list() // species name = newlist(outfits)
	var/list/whitelisted_species = list() //species name = whitelist name

	var/resource_pool = 100 //Arbitrary resources.
	var/list/acquirable_items = list() //item name = typepath, autofilled by system.
	var/list/item_costs = list() //item typepath = cost

/datum/mobile_spawn/New()
	for(var/item in item_costs)
		var/obj/temp_item = new item
		acquirable_items[temp_item.name] = item
		qdel(temp_item)

/datum/mobile_spawn/proc/process_resource_regen(var/amt = 0.5)
	resource_pool = min(100,resource_pool+amt)

/datum/mobile_spawn/proc/handle_requisition(var/mob/user,var/obj/vehicle_spawnfrom)
	var/item_requisition = input(user,"What item do you want to requisition? ([resource_pool]/[initial(resource_pool)] resources left)","Item Requisition","Cancel") in acquirable_items + list("Cancel")
	if(item_requisition == "Cancel")
		return
	var/confirm = alert(user,"[item_requisition] will cost [item_costs[item_requisition]] resources to obtain. Confirm?","Confirmation","Yes","No")
	if(confirm == "No")
		return
	new item_requisition (vehicle_spawnfrom.loc)
	resource_pool -= item_costs[item_requisition]

/datum/mobile_spawn/proc/handle_spawn(var/mob/user,var/obj/vehicle_spawnfrom)
	if(world.time - user.timeofdeath < MOBILE_SPAWN_RESPAWN_TIME)
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

	var/mob/living/carbon/human/h = new(vehicle_spawnfrom.loc,species_choice)
	h.faction = spawn_faction
	outfit_choice.equip(h)
	h.ckey = user.ckey
	qdel(user)

/datum/mobile_spawn/covenant
	spawn_faction = "Covenant"
	species_outfits = list("Unggoy" = newlist(/decl/hierarchy/outfit/mobilespawn_unggoy/major,/decl/hierarchy/outfit/mobilespawn_unggoy/medic,/decl/hierarchy/outfit/mobilespawn_unggoy/engineer,/decl/hierarchy/outfit/mobilespawn_unggoy_grenadier))

/datum/mobile_spawn/unsc
	spawn_faction = "UNSC"
	species_outfits = list("Human" = newlist(/decl/hierarchy/outfit/job/mobilespawn_marine,/decl/hierarchy/outfit/job/mobilespawn_marine/engineer,/decl/hierarchy/outfit/job/mobilespawn_marine/medic,/decl/hierarchy/outfit/job/mobilespawn_janitor))