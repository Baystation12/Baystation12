
/mob/living/simple_animal/npc
	name = "NPC"
	desc = "Does what he wants cause a pirate is free."
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
	var/list/jumpsuits = list()
	var/list/shoes = list()
	var/list/hats = list()
	var/hat_chance = 33
	var/list/gloves = list()
	var/glove_chance = 10
	var/list/suits = list()
	var/suit_chance = 25

	unsuitable_atoms_damage = 15
	var/corpse = /obj/effect/landmark/mobcorpse/pirate
	var/weapon1 = /obj/item/weapon/melee/energy/sword/pirate

	var/list/speech_triggers = list()

	var/icon/interact_icon
	var/mob/interacting_mob

	var/list/trade_items = list()
	var/list/trade_items_by_type = list()
	var/list/trade_items_inventory = list()
	var/list/trade_items_inventory_by_type = list()
	var/list/trade_items_inventory_by_name = list()
	var/list/trade_categories_by_name = list()
	var/total_trade_weight = 0
	//
	var/list/interact_inventory = list()

	var/datum/controller/process/trade_controller/trade_controller_debug

/mob/living/simple_animal/npc/proc/can_use(var/mob/M)
	if(M.stat || M.restrained() || M.lying || !istype(M, /mob/living) || get_dist(M, src) > 1)
		return 0
	return 1
