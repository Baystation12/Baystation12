/datum/antagonist/ert
	required_language = LANGUAGE_HUMAN_EURO
	leader_welcome_text = "<b>You are the <span class='notice'>leader</span> of the ERT!</b>\n \
	You're an officer of the Fifth Fleet, tasked with leading your team to restore order to the SEV Torch and/or accomplish the mission given by Fleet Command. You answer \
	directly to Fleet Command and have been granted authority over the crew of the SEV Torch where nescessary to accomplish your mission."
	welcome_text = "As an emergency responder, you're an enlisted of the Fifth Fleet, tasked with leading your team to restore order to the SEV Torch and/or \
	accomplish the mission given by Fleet Command. You answer directly to your team leader and Fleet Command, and have been granted authority \
	over the crew of the SEV Torch where nescessary to accomplish your mission."
	// Torch specific access for ERT
	// Auto-adds get_station_all_access() and relevant centcom access on Initialize()
	default_access = list(access_representative, access_liaison)

	/// Second-In-Command
	var/sic
	var/list/accessories = list(
		/obj/item/clothing/accessory/solgov/fleet_patch/fifth,
		/obj/item/clothing/accessory/wristwatch
	)

/datum/antagonist/ert/equip(mob/living/carbon/human/player)
	if(!..())
		return FALSE

	player.char_branch = GLOB.mil_branches.get_branch("Fleet")
	if(player.mind == leader)
		player.char_rank = GLOB.mil_branches.get_rank("Fleet", "Lieutenant")
		player.age = rand(29,32) // https://baystation.xyz/index.php?title=Sol_Central_Government_Fleet#Officer
	else if(!sic)
		sic = player.mind
		player.char_rank = GLOB.mil_branches.get_rank("Fleet", "Senior Chief Petty Officer")
		player.age = rand(34,37)
	else if(prob(50))
		player.char_rank = GLOB.mil_branches.get_rank("Fleet", "Petty Officer Second Class")
		player.age = rand(23,26)
	else
		player.char_rank = GLOB.mil_branches.get_rank("Fleet", "Petty Officer First Class")
		player.age = rand(25,28)

	var/singleton/hierarchy/outfit/ert_outfit = outfit_by_type((player.mind == leader) ? /singleton/hierarchy/outfit/fleet/ert/leader : /singleton/hierarchy/outfit/fleet/ert)
	ert_outfit.equip(player, equip_adjustments = OUTFIT_ADJUSTMENT_SKIP_BACKPACK|OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR)
	for(var/accessory_path in accessories)
		player.equip_to_slot_or_del(new accessory_path(src), slot_tie)

	if(player.char_rank && player.char_rank.accessory)
		for(var/accessory_path in player.char_rank.accessory)
			var/list/accessory_data = player.char_rank.accessory[accessory_path]
			if(islist(accessory_data))
				var/amt = accessory_data[1]
				var/list/accessory_args = accessory_data.Copy()
				accessory_args[1] = src
				for(var/i in 1 to amt)
					player.equip_to_slot_or_del(new accessory_path(arglist(accessory_args)), slot_tie)
			else
				for(var/i in 1 to (isnull(accessory_data)? 1 : accessory_data))
					player.equip_to_slot_or_del(new accessory_path(src), slot_tie)

	return TRUE

/** ERT ship's arrival sequence for the Torch.
*
* @param ship allows for manual reference to the desired overmap obj for admin events.
* If `null` runs `locate()` for `obj/overmap/visitable/sector/ship`.
*/
/datum/antagonist/ert/arrive(obj/overmap/visitable/sector/ert_ship/ship = locate())
	if(arrived)
		return
	arrived = TRUE

	for(var/obj/machinery/rotating_alarm/start_on/ert/alarm as anything in MACHINES_OF(/obj/machinery/rotating_alarm/start_on/ert))
		alarm.set_off()

	if(!ship || GLOB.ert.is_secret)
		return

	sleep(20 SECONDS)

	// ERT ship jump sound is heard by every non-deaf mob not in an admin zlevel to alert players
	for(var/mob/mob in GLOB.player_list)
		if(!mob.client || istype(mob,/mob/new_player) || isdeaf(mob))
			continue
		var/area/area = get_area(mob)
		if(!area || (area.type in typesof(/area/map_template/ert)) || (get_z(mob) in GLOB.using_map.admin_levels))
			continue
		sound_to(mob, sound('sound/misc/aldensaraspovajump.ogg', volume = 50))

	sleep(3 SECONDS)
	var/obj/overmap/aldensaraspova_jump/jump = new /obj/overmap/aldensaraspova_jump(get_turf(ship))
	ship.set_cloak(FALSE)
	sleep(4 SECONDS)

	var/message = "WARNING:\nAlden-Saraspova Instability detected near your sector... Unidentified contact in interception course with your vessel."
	priority_announcement.Announce(message, "[station_name()] Sensor Array", sound('sound/effects/Evacuation.ogg', volume = 30))
	qdel(jump)
