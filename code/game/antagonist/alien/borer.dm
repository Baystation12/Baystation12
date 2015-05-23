var/datum/antagonist/xenos/borer/borers

/datum/antagonist/xenos/borer
	id = MODE_BORER
	role_text = "Cortical Borer"
	role_text_plural = "Cortical Borers"
	mob_path = /mob/living/simple_animal/borer
	bantype = "Borer"
	welcome_text = "Use your Infest power to crawl into the ear of a host and fuse with their brain. You can only take control temporarily, and at risk of hurting your host, so be clever and careful; your host is encouraged to help you however they can. Talk to your fellow borers with :x."
	var/list/hosts = list()

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

/datum/antagonist/xenos/borer/proc/place_in_host(var/mob/living/simple_animal/borer/borer, var/mob/living/carbon/human/host)
	borer.host = host
	borer.host_brain.name = host.name
	borer.host_brain.real_name = host.real_name
	var/obj/item/organ/external/head = host.get_organ("head")
	if(head) head.implants += borer

/datum/antagonist/xenos/borer/proc/get_hosts()
	var/list/possible_hosts = list()
	for(var/mob/living/carbon/human/H in mob_list)
		var/obj/item/organ/external/head/head = H.get_organ("head")
		if(head.status & ORGAN_ROBOT)
			continue
		if(H.stat != 2 && !H.has_brain_worms())
			possible_hosts |= H
	return possible_hosts

/datum/antagonist/xenos/borer/place_all_mobs()
	var/list/possible_hosts = get_hosts()
	for(var/datum/mind/player in current_antagonists)
		if(!possible_hosts.len)
			return
		var/mob/host = pick(possible_hosts)
		possible_hosts -= host
		place_in_host(player, host)

/datum/antagonist/xenos/borer/place_mob(var/mob/living/mob)
	var/list/possible_hosts = get_hosts()
	if(possible_hosts.len) place_in_host(mob, pick(possible_hosts))
