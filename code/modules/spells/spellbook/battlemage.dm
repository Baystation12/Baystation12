//Battlemage is all about mixing physical with the mystical in head to head combat.
//Things like utility and mobility come second.
/datum/spellbook/battlemage
	name = "\improper Battlemage's Bible"
	feedback = "BM"
	desc = "Smells like blood."
	book_desc = "Mix physical with the mystical in head to head combat."
	title = "The Art of Magical Combat"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE
	max_uses = 5

	spells = list(/spell/targeted/projectile/dumbfire/passage = 	1,
				/spell/targeted/equip_item/dyrnwyn = 				1,
				/spell/targeted/equip_item/shield = 				1,
				/spell/targeted/projectile/dumbfire/fireball = 		1,
				/spell/targeted/torment = 							1,
				/spell/targeted/heal_target = 						2,
				/spell/targeted/genetic/mutate = 					1,
				/spell/aoe_turf/conjure/mirage = 					1,
				/spell/targeted/shapeshift/corrupt_form = 			1,
				/spell/noclothes = 									1,
				/obj/structure/closet/wizard/armor = 				1,
				/obj/item/weapon/gun/energy/staff/focus = 			1,
				/obj/item/weapon/dice/d20/cursed = 					1,
				/obj/item/weapon/monster_manual = 					2,
				/obj/item/weapon/magic_rock = 						1,
				/obj/item/weapon/contract/apprentice = 				1
					)

	sacrifice_objects = list(/obj/item/weapon/material/sword,
							/obj/item/weapon/material/twohanded/fireaxe)