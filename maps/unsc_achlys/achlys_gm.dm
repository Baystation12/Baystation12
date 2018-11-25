

#define ITEM_SCANFOR_TYPEPATH_1 //These need to be destroyed.
#define ITEM_SCANFOR_TYPEPATH_2 //These need to be destroyed.
#define ITEM_RETRIEVE_TYPEPATH_1 //This is the item that needs to be returned to a person/rank.

/datum/game_mode/achlys
	name = "ONI Investigation: Achlys"
	round_description = ""
	extended_round_description = ""
	config_tag = "achlys"
	votable = 1
	probability = 0
	var/item_destroy_tag = "destroythis" //Map-set tags for items that need to be destroyed.
	var/list/items_to_destroy = list()
	var/item_retrieve_tag = "retrievethis" //Map-set tags for items that need to be retrieved.
	var/list/items_to_retrieve = list()
	var/list/rank_retrieve_names = list("Commanding Officer")//The name of the job that needs to be holding the items-to-retrieve

/datum/game_mode/achlys/proc/populate_items_destroy()
	for(var/atom/destroy in world)
		if(destroy.tag == item_destroy_tag)
			items_to_destroy += destroy

/datum/game_mode/achlys/proc/populate_items_retrieve()
	for(var/atom/retrieve in world)
		if(retrieve.tag == item_retrieve_tag)
			items_to_retrieve += retrieve

/datum/game_mode/achlys/pre_setup()
	..()
	populate_items_destroy()
	populate_items_retrieve()

/datum/game_mode/achlys/check_finished()
	. = check_item_destroy_status()
	. = check_item_retrieve_status()

/datum/game_mode/achlys/proc/check_item_destroy_status()
	. = 1 //This ensures that if the list is emptied due to the objects being deleted, it will still allow the gamemode to end.
	for(var/atom/item in items_to_destroy)
		if(istype(item,/obj/machinery))
			var/obj/machinery/item_machine = item
			if(!(item_machine.stat & BROKEN))
				. = 0

/datum/game_mode/achlys/proc/check_item_retrieve_status()
	. = 1
	for(var/atom/item in items_to_retrieve)
		if(istype(item.loc,/mob/living/carbon/human))
			var/mob/living/carbon/human/holder = item.loc
			if(!(holder.mind) || !(holder.mind.assigned_role in rank_retrieve_names))
				. = 0

/datum/game_mode/achlys/process()
	..()

/datum/game_mode/achlys/declare_completion()
	..()

/datum/game_mode/achlys/handle_mob_death(var/mob/victim, var/list/args = list())
	..()