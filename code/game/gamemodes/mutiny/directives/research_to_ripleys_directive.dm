#define MATERIALS_REQUIRED 200

datum/directive/research_to_ripleys
	var/list/ids_to_reassign = list()
	var/materials_shipped = 0

	proc/get_researchers()
		var/list/researchers[0]
		for(var/mob/living/carbon/human/H in player_list)
			if (H.mind.assigned_role in science_positions - "Research Director")
				researchers.Add(H)
		return researchers

	proc/count_researchers_reassigned()
		var/researchers_reassigned = 0
		for(var/obj/item/weapon/card/id in ids_to_reassign)
			if (ids_to_reassign[id])
				researchers_reassigned++

		return researchers_reassigned

datum/directive/research_to_ripleys/get_description()
	return {"
		<p>
			The NanoTrasen Tau Ceti Manufactory faces an ore deficit. Financial crisis imminent. [station_name()] has been reassigned as a mining platform.
			The Research Director is to assist the Head of Personnel in coordinating assets.
			Weapons department reports solid sales. Further information is classified.
		</p>
	"}

datum/directive/research_to_ripleys/meets_prerequisites()
	var/list/researchers = get_researchers()
	return researchers.len > 3

datum/directive/research_to_ripleys/initialize()
	for(var/mob/living/carbon/human/R in get_researchers())
		ids_to_reassign[R.wear_id] = 0

	special_orders = list(
		"Reassign all research personnel, excluding the Research Director, to Shaft Miner.",
		"Deliver [MATERIALS_REQUIRED] sheets of metal or minerals via the supply shuttle to CentCom.")

datum/directive/research_to_ripleys/directives_complete()
	if (materials_shipped < MATERIALS_REQUIRED) return 0
	return count_researchers_reassigned() == ids_to_reassign.len

/hook/reassign_employee/proc/research_reassignments(obj/item/weapon/card/id/id_card)
	var/datum/directive/research_to_ripleys/D = get_directive("research_to_ripleys")
	if(!D) return 1

	if(D.ids_to_reassign && D.ids_to_reassign.Find(id_card))
		D.ids_to_reassign[id_card] = id_card.assignment == "Shaft Miner" ? 1 : 0

	return 1

/hook/sell_crate/proc/deliver_materials(obj/structure/closet/crate/sold, area/shuttle)
	var/datum/directive/research_to_ripleys/D = get_directive("research_to_ripleys")
	if(!D) return 1

	for(var/atom/A in sold)
		if(istype(A, /obj/item/stack/sheet/mineral) || istype(A, /obj/item/stack/sheet/metal))
			var/obj/item/stack/S = A
			D.materials_shipped += S.amount

	return 1
