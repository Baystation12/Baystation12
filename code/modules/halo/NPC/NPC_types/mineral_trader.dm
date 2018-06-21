
/mob/living/simple_animal/npc/colonist/mineral_trader
	name = "NPC Ore Trader"
	npc_job_title = "NPC Ore Trader"
	desc = "A human from one of Earth's diverse cultures. This NPC buys and sells ore for cash"
	trade_categories_by_name = list("ore")
	suits = list(\
		/obj/item/clothing/suit/apron/overalls\
	)
	jumpsuits = list(\
		/obj/item/clothing/under/rank/miner,\
		/obj/item/clothing/under/overalls\
		)
	hat_chance = 50
	glove_chance = 50
	wander = 0
/*
/mob/living/simple_animal/npc/colonist/mineral_trader/get_trade_value(var/obj/O)
	//use the default ss13 value procs here
	. = get_value(O)
*/