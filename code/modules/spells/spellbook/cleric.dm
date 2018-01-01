//Cleric is all about healing. Mobility and offense comes at a higher price but not impossible.
/obj/item/weapon/spellbook/cleric
	spellbook_type = /datum/spellbook/cleric

/datum/spellbook/cleric
	name = "\improper Cleric's Tome"
	feedback = "CR"
	desc = "For those who do not harm, or at least feel sorry about it."
	book_desc = "All about healing. Mobility and offense comes at a higher price but not impossible."
	title = "Cleric's Tome of Healing"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE
	max_uses = 6

	spells = list(/spell/targeted/heal_target = 					1,
				/spell/targeted/heal_target/major = 				1,
				/spell/targeted/heal_target/area = 					1,
				/spell/targeted/heal_target/sacrifice = 			1,
				/spell/targeted/genetic/blind = 					1,
				/spell/targeted/shapeshift/baleful_polymorph = 		1,
				/spell/targeted/projectile/dumbfire/stuncuff = 		1,
				/spell/targeted/ethereal_jaunt = 					2,
				/spell/aoe_turf/knock = 							1,
				/spell/radiant_aura =								1,
				/spell/targeted/equip_item/holy_relic = 			1,
				/spell/aoe_turf/conjure/grove/sanctuary = 			1,
				/spell/targeted/projectile/dumbfire/fireball = 		2,
				/spell/aoe_turf/conjure/forcewall = 				1,
				/obj/item/weapon/magic_rock = 						1,
				/obj/item/weapon/gun/energy/staff/focus = 			2,
				/obj/item/weapon/contract/apprentice = 				1
				)

	sacrifice_reagents = list(/datum/reagent/peridaxon,
							/datum/reagent/adminordrazine)
	sacrifice_objects = list(/obj/item/seeds/mtearseed)
