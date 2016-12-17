var/datum/antagonist/technomancer/technomancers

/datum/antagonist/technomancer
	id = MODE_TECHNOMANCER
	role_text = "Technomancer"
	role_text_plural = "Technomancers"
	landmark_id = "ninjastart"
	welcome_text = "You will need to purchase <b>functions</b> and perhaps some <b>equipment</b> from the various machines around your \
	base. Choose your technological arsenal carefully.  Remember that without the <b>core</b> on your back, your functions are \
	powerless, and therefore you will be as well.<br>\
	In your pockets you will find a one-time use teleport device. Use it to leave the base and go to the colony, when you are ready."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE | ANTAG_VOTABLE
	antaghud_indicator = "hudwizard"

	hard_cap = 1
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 1

	id_type = /obj/item/weapon/card/id/syndicate

/datum/antagonist/technomancer/New()
	..()
	technomancers = src

/datum/antagonist/technomancer/update_antag_mob(var/datum/mind/technomancer)
	..()
	technomancer.store_memory("<B>Remember:</B> Do not forget to purchase the functions and equipment you need.")
	technomancer.current.real_name = "[pick(wizard_first)] [pick(wizard_second)]"
	technomancer.current.name = technomancer.current.real_name

/datum/antagonist/technomancer/equip(var/mob/living/carbon/human/technomancer_mob)

	if(!..())
		return 0

	var/decl/hierarchy/outfit/technomancer = outfit_by_type(/decl/hierarchy/outfit/technomancer/master)
	technomancer.equip(technomancer_mob)

	var/obj/item/weapon/technomancer_core/core = new /obj/item/weapon/technomancer_core(technomancer_mob)
	technomancer_mob.equip_to_slot_or_del(core, slot_back)
	technomancer_belongings.Add(core) // So it can be Tracked.
	technomancer_mob.update_icons()
	return 1

/datum/antagonist/technomancer/proc/equip_apprentice(var/mob/living/carbon/human/technomancer_mob)

	var/decl/hierarchy/outfit/technomancer = outfit_by_type(/decl/hierarchy/outfit/technomancer/apprentice)
	technomancer.equip(technomancer_mob)

	var/obj/item/weapon/technomancer_core/core = new /obj/item/weapon/technomancer_core(technomancer_mob)
	technomancer_mob.equip_to_slot_or_del(core, slot_back)
	technomancer_belongings.Add(core) // So it can be Tracked.
	technomancer_mob.update_icons()
	return 1

/datum/antagonist/technomancer/check_victory()
	var/survivor
	for(var/datum/mind/player in current_antagonists)
		if(!player.current || player.current.stat == DEAD)
			continue
		survivor = 1
		break
	if(!survivor)
		feedback_set_details("round_end_result","loss - technomancer killed")
		to_world("<span class='danger'><font size = 3>The [(current_antagonists.len>1)?"[role_text_plural] have":"[role_text] has"] been \
		killed!</font></span>")
