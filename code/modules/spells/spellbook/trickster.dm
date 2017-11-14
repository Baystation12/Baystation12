//Trickster is about making deals and being sneeki
/obj/item/weapon/spellbook/trickster
	spellbook_type = /datum/spellbook/trickster

/datum/spellbook/trickster
	name = "\improper Arcane Trickster's Ledger"
	feedback = "AT"
	desc = "Smells untrustworthy."
	book_desc = "Mix deception and trickery with contracts."
	title = "The Ledger"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE
	max_uses = 6

	spells = list(/spell/targeted/ethereal_jaunt =              	2,
				/spell/targeted/projectile/dumbfire/passage =   	1,
				/spell/mark_recall = 				     			1,
				/spell/targeted/shapeshift/avian = 				    1,
				/spell/targeted/swap = 							    1,
				/spell/targeted/projectile/magic_missile = 	        2,
				/spell/targeted/blink =                             1,
				/spell/aoe_turf/smoke = 							1,
				/spell/targeted/genetic/blind = 					1,
				/spell/aoe_turf/conjure/summon/bats = 			    2,
				/spell/hand/charges/entangle = 						1,
				/spell/targeted/subjugation = 						1,
				/spell/aoe_turf/conjure/forcewall = 				1,
				/spell/targeted/torment = 							1,
				/spell/aoe_turf/disable_tech = 						2,
				/spell/targeted/heal_target = 						1,
				/spell/targeted/heal_target/major = 				1,
				/spell/targeted/heal_target/area = 					1,
				/spell/targeted/heal_target/sacrifice = 			1,
				/spell/targeted/genetic/mutate = 					1,
				/spell/aoe_turf/conjure/mirage = 					1,
				/spell/targeted/shapeshift/corrupt_form = 			1,

				/obj/structure/closet/wizard/souls = 				1,
				/obj/item/weapon/gun/energy/staff/focus = 			3,
				/obj/item/weapon/dice/d20/cursed = 					1,
				/obj/item/weapon/teleportation_scroll = 		    1,
				/obj/item/weapon/monster_manual = 					2,
				/obj/structure/closet/wizard/scrying = 				2,
				/obj/item/weapon/magic_rock = 						1,
				/obj/item/weapon/contract/apprentice = 				1,
				/obj/item/weapon/spellbook/apprentice =             6,
				/obj/item/weapon/pen =                              0,
				/obj/item/weapon/paper =                            0,
				)

	sacrifice_objects = list(/obj/item/stack/telecrystal, /obj/item/stack/material/gold, /obj/item/stack/material/silver)

/obj/item/weapon/spellbook/apprentice
	spellbook_type = /datum/spellbook/apprentice

/datum/spellbook/apprentice
	name = "\improper Apprentice's Tome"
	feedback = "AA"
	desc = "Looks fancy."
	book_desc = "Become that which you were always meant to be."
	title = "The Arcane Lexicon"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = INVESTABLE
	max_uses = 4

	spells = list(/spell/targeted/projectile/dumbfire/passage =   	1,
				/spell/mark_recall = 				     			2,
				/spell/targeted/swap = 							    1,
				/spell/targeted/projectile/magic_missile = 	        2,
				/spell/targeted/blink =                             1,
				/spell/aoe_turf/smoke = 							1,
				/spell/aoe_turf/conjure/forcewall = 				2,
				/spell/targeted/torment = 							2,
				/spell/targeted/heal_target = 						1,
				/spell/aoe_turf/conjure/mirage = 					1,

				/obj/item/weapon/magic_rock = 						1,
				/obj/item/weapon/dice/d20/cursed = 					1
				)