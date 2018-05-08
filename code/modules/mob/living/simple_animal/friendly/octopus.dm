/mob/living/simple_animal/octopus
	name = "cephalopod"
	real_name = "space octopus"
	desc = "It's a small spaceborne octopus."
	icon_state = "octo"
	item_state = "octo"
	icon_living = "octo"
	icon_dead = "octo_dead"
	speak = list("Blug!","Glubber!","Blab?")
	speak_emote = list("babbles","blorps","blarps")
	emote_hear = list("babbles","blorps","blarps")
	emote_see = list("wriggles its tentacles", "pulsates", "schlepps")
	pass_flags = PASS_FLAG_TABLE
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 50
	health = 50
	//placeholder until I add more exotic meats with varying degrees of toxicity
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/fish/poison
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps on"
	density = 0

	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	universal_speak = 0
	universal_understand = 1

	mob_size = MOB_SMALL
	possession_candidate = 1
	can_escape = 1

	can_pull_size = ITEM_SIZE_TINY
	can_pull_mobs = MOB_PULL_NONE

/mob/living/simple_animal/octopus/Initialize()
	. = ..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/mob/living/simple_animal/octopus/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			to_chat(M, "<span class='warning'>\icon[src] Squonk!</span>")
			sound_to(M, 'sound/items/bikehorn.ogg')
	..()

/mob/observer/ghost/verb/become_octopus()
	set name = "Become octopus"
	set category = "Ghost"

	if(!MayRespawn(1, ANIMAL_SPAWN_DELAY))
		return

	var/turf/T = get_turf(src)
	if(!T || (T.z in GLOB.using_map.admin_levels))
		to_chat(src, "<span class='warning'>You may not spawn as an octopus on this Z-level.</span>")
		return

	var/response = alert(src, "Are you -sure- you want to become an octopus?","Are you sure you want to blabbl?","Squelk!","Nope!")
	if(response != "Squelk!") return  //Hit the wrong key...again.

	var/mob/living/simple_animal/octopus/host
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	var/list/found_vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in SSmachines.machinery)
		if(!v.welded && v.z == T.z)
			found_vents.Add(v)
	if(found_vents.len)
		vent_found = pick(found_vents)
		host = new /mob/living/simple_animal/octopus(vent_found.loc)
	else
		to_chat(src, "<span class='warning'>Unable to find any unwelded vents to spawn octopus at.</span>")
	if(host)

		announce_ghost_joinleave(src, 0, "They are now an octopus.")
		host.ckey = src.ckey
		host.status_flags |= NO_ANTAG
		to_chat(host, "<span class='info'>You are now an octopus. Try to avoid interaction with players, and do not give hints away that you are more than a simple cephalopod.</span>")

//octopus quirks: in the wild they feed on ionizing radiation, on a star ship they just wrap around the nearest outlet.
//A pity then I can't code for shit.

	toggleable = 1
	activates_on_touch = 1
	disruptive = 0

	activate_string = "Enable Power Sink"
	deactivate_string = "Disable Power Sink"

	var/atom/interfaced_with
	var/total_power_drained = 0
	var/drain_loc
	var/max_draining_rate = 120 KILOWATTS

/mob/living/simple_animal/octopus/deactivate()

	if(interfaced_with)
		if(holder && holder.wearer)
		drain_complete()
	interfaced_with = null
	total_power_drained = 0
	return ..()