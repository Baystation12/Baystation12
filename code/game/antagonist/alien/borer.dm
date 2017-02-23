var/datum/antagonist/xenos/borer/borers

/datum/antagonist/xenos/borer
	id = MODE_BORER
	role_text = "Cortical Borer"
	role_text_plural = "Cortical Borers"
	mob_path = /mob/living/simple_animal/borer
	welcome_text = "Use your Infest power to crawl into the ear of a host and fuse with their brain. You can only take control temporarily, and at risk of hurting your host, so be clever and careful; your host is encouraged to help you however they can. Talk to your fellow borers with :x."
	antag_indicator = "hudborer"
	antaghud_indicator = "hudborer"

	faction_role_text = "Borer Thrall"
	faction_descriptor = "Unity"
	faction_welcome = "You are now a thrall to a cortical borer. Please listen to what they have to say; they're in your head."
	faction = "borer"

	initial_spawn_req = 3
	initial_spawn_target = 5

/datum/antagonist/xenos/borer/New()
	..(1)
	borers = src

/datum/antagonist/xenos/borer/get_extra_panel_options(var/datum/mind/player)
	return "<a href='?src=\ref[src];move_to_spawn=\ref[player.current]'>\[put in host\]</a>"

/datum/antagonist/xenos/borer/create_objectives(var/datum/mind/player)
	if(!..())
		return
	player.objectives += new /datum/objective/borer_survive()
	player.objectives += new /datum/objective/borer_reproduce()
	player.objectives += new /datum/objective/escape()

/datum/antagonist/xenos/borer/place_mob(var/mob/living/mob)
	var/mob/living/simple_animal/borer/borer = mob
	if(istype(borer))
		var/mob/living/carbon/human/host
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.stat != DEAD && !H.has_brain_worms())
				var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
				if(head && !(head.robotic >= ORGAN_ROBOT))
					host = H
					break
		if(istype(host))
			var/obj/item/organ/external/head = host.get_organ(BP_HEAD)
			if(head)
				borer.host = host
				head.implants += borer
				borer.forceMove(head)
				if(!borer.host_brain)
					borer.host_brain = new(borer)
				borer.host_brain.name = host.name
				borer.host_brain.real_name = host.real_name
				return
	..() // Place them at a vent if they can't get a host.
