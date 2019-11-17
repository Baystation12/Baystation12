
/mob/living/simple_animal/npc
	name = "NPC"
	desc = "Surprisingly, this one is neither wearing a red shirt nor called Bob."
	icon = 'code/modules/halo/NPC/npc.dmi'
	icon_state = "Human_m"
	var/npc_job_title
	speak_chance = 0
	turns_per_move = 5
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	can_ignite = 1
	ignite_overlay = "Standing"
	var/list/jumpsuits = list()
	var/list/shoes = list()
	var/list/hats = list()
	var/hat_chance = 33
	var/list/masks = list()
	var/mask_chance = 50
	var/list/gloves = list()
	var/glove_chance = 10
	var/list/suits = list()
	var/suit_chance = 25
	var/list/glasses = list()
	var/glasses_chance = 25

	var/species_type = /datum/species/human
	var/datum/species/my_species

	unsuitable_atmos_damage = 15
	var/corpse = /obj/effect/landmark/mobcorpse/pirate
	var/weapon1 = /obj/item/weapon/melee/energy/sword/pirate

	var/list/speech_triggers = list()

	var/icon/interact_icon
	var/mob/interacting_mob
	var/in_use = 0

	var/list/trade_items = list()
	var/list/trade_items_by_type = list()
	var/list/trade_items_inventory = list()
	var/list/trade_items_inventory_by_type = list()
	var/list/trade_items_inventory_by_name = list()
	var/list/trade_categories_by_name = list()
	var/total_trade_weight = 0
	var/starting_trade_items = 6
	//
	var/list/interact_inventory = list()
	var/accepted_currency = "credits"
	//
	var/interact_screen = 1
	var/list/greetings = list(\
		"Hello.",\
		"How are you going?",\
		"How can I help?",\
		"Good day.",\
		"What can I do for you?")
	var/list/goodbyes = list(\
		"See you.",\
		"See you later.",\
		"Have a good one.",\
		"Take it easy.",\
		"Later.",\
		"Bye.",\
		"Goodbye.",\
		"Bye for now.")
	var/current_greeting_index = 1
	var/list/confused_responses = list(\
		"I don't know anything about that.",\
		"Not sure.",\
		"No idea.",\
		"Can't help.",\
		"Never heard of it.")
	var/list/afraid_responses = list(\
		"Ahhh!",\
		"Oh no!",\
		"Save me!",\
		"I'm a cowardly foe!",\
		"Help!")
	var/say_time = 0
	var/say_next = 0

	var/last_afraid = 0
	var/duration_afraid = 30 SECONDS

	var/datum/controller/process/trade_controller/trade_controller_debug

/mob/living/simple_animal/npc/proc/can_use(var/mob/M)
	if(M.stat || M.restrained() || M.lying || !istype(M, /mob/living) || get_dist(M, src) > 1)
		return 0
	return 1

/mob/living/simple_animal/npc/Life()
	. = ..()

	if(stat == CONSCIOUS)
		if(last_afraid)
			say_time = 0
			speak_chance = 0

			var/turf/target_turf = pick(view(7, src))
			for(var/i=0,i<5,i++)
				dir = get_dir(src,target_turf)
				Move(get_step_towards(src,target_turf))
				sleep(1)

			if(prob(25))
				if(prob(33))
					say(afraid_responses)
				else if(prob(50))
					audible_emote("screams in [pick("pain","fear")]!")
					do_pain_scream()
				else
					visible_emote("cowers to the ground.")

			if(world.time > last_afraid + duration_afraid)
				last_afraid = 0
				speak_chance = initial(speak_chance)

		else if(say_time && world.time >= say_time)
			say_time = 0
			say(say_next)
