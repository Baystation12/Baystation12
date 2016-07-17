//all about the summons, nature, and a bit o' healin.

/obj/item/weapon/spellbook/druid
	spellbook_type = /datum/spellbook/druid

/datum/spellbook/druid
	name = "\improper Druid's Leaflet"
	feedback = "DL"
	desc = "It smells like an air freshener."
	book_desc = "Summons, nature, and a bit o' healin."
	title = "Druidic Guide on how to be smug about nature"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE
	max_uses = 5

	spells = list(/spell/targeted/heal_target = 					1,
				/spell/targeted/heal_target/sacrifice = 			1,
				/spell/aoe_turf/conjure/mirage = 					1,
				/spell/aoe_turf/conjure/summon/bats = 				1,
				/spell/aoe_turf/conjure/summon/bear = 				1,
				/spell/targeted/equip_item/party_hardy = 			1,
				/spell/targeted/equip_item/seed = 					1,
				/spell/aoe_turf/disable_tech = 						1,
				/spell/hand/charges/entangle = 						1,
				/spell/aoe_turf/conjure/grove/sanctuary = 			1,
				/spell/aoe_turf/knock = 							1,
				/obj/structure/closet/wizard/souls = 				1,
				/obj/item/weapon/magic_rock = 						1,
				/obj/item/weapon/monster_manual = 					1,
				/obj/item/weapon/contract/apprentice = 				1
				)
	sacrifice_objects = list(/obj/item/seeds/ambrosiavulgarisseed,
							/obj/item/seeds/ambrosiadeusseed)
