//all about the summons, nature, and a bit o' healin.

/obj/item/weapon/spellbook/druid
	spellbook_type = /datum/spellbook/druid

/datum/spellbook/druid
	name = "\improper Artificer's Catalog"
	feedback = "DL"
	desc = "It smells like a hardware store."
	book_desc = "Summoning and artefacts galore."
	title = "The Compendium of Artefacts"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = INVESTABLE
	max_uses = 6

	spells = list(/spell/targeted/equip_item/dyrnwyn = 				1,
				/spell/targeted/equip_item/shield = 				1,
				/spell/targeted/ethereal_jaunt =              		2,
				/spell/aoe_turf/conjure/forcewall = 				1,
				/spell/targeted/shapeshift/baleful_polymorph = 		1,
				/spell/targeted/projectile/dumbfire/stuncuff = 		1,
				/spell/targeted/projectile/magic_missile = 	        2,
				/spell/aoe_turf/conjure/summon/bats = 				2,
				/spell/aoe_turf/conjure/summon/bear = 				3,
				/spell/targeted/equip_item/party_hardy = 			1,
				/spell/aoe_turf/smoke = 							1,
				/spell/targeted/equip_item/holy_relic = 			1,
				/spell/targeted/equip_item/seed = 					1,
				/spell/aoe_turf/conjure/grove/sanctuary = 			1,
				/spell/aoe_turf/knock = 							1,

				/obj/structure/closet/wizard/souls = 				2,
				/obj/item/weapon/gun/energy/staff/focus = 			1,
				/obj/structure/closet/wizard/armor = 				1,
				/obj/item/weapon/gun/energy/staff/animate = 		2,
				/obj/structure/closet/wizard/scrying = 				3,
				/obj/item/weapon/contract/wizard/tk = 		    	2,
				/obj/item/weapon/monster_manual = 					1,
				/obj/item/weapon/magic_rock = 						1,
				/obj/item/weapon/contract/apprentice = 				2
				)
	sacrifice_objects = list(obj/item/weapon/material/sword/)
