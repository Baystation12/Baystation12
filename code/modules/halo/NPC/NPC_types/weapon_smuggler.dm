
/mob/living/simple_animal/npc/colonist/weapon_smuggler
	name = "NPC Weapon Trader"
	npc_job_title = "NPC Weapon Trader"
	trade_categories_by_name =  list("innie","weapon","weapon_unsc")
	interact_screen = 2
	suits = list(\
		/obj/item/clothing/suit/leathercoat,\
		/obj/item/clothing/suit/wizrobe/gentlecoat,\
		/obj/item/clothing/suit/chaplain_hoodie\
	)
	suit_chance = 100
	hat_chance = 66
	wander = 0

/mob/living/simple_animal/npc/colonist/weapon_smuggler/New()
	speech_triggers.Add(new /datum/npc_speech_trigger/smuggler_response())
	. = ..()
