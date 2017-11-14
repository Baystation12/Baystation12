//I broke the spellbook we know and love.

/obj/item/weapon/spellbook/wizard
	spellbook_type = /datum/spellbook/wizard

/datum/spellbook/wizard
	name = "\improper Wizard's Spellbook"
	feedback = "SB"
	title = "Book of Arcane Mysteries"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_desc = "A wizard's spellbook. Mastery of magic and mystique lie within its many pages."
	book_flags = INVESTABLE
	max_uses = 6

	spells = list(/spell/targeted/projectile/magic_missile = 	        		1,
							/spell/targeted/projectile/dumbfire/fireball = 		1,
							/spell/aoe_turf/smoke = 							1,
							/spell/targeted/genetic/blind = 					1,
							/spell/targeted/subjugation = 						1,
							/spell/aoe_turf/conjure/forcewall = 				1,
							/spell/area_teleport = 								1,
							/spell/targeted/ethereal_jaunt = 					2,
							/spell/targeted/projectile/dumbfire/passage =   	1,
							/spell/targeted/swap = 							    1,
							/spell/aoe_turf/knock = 							1,
							/spell/aoe_turf/conjure/summon/bats = 			    2,
							/spell/hand/charges/entangle = 						1,
							/spell/aoe_turf/conjure/mirage = 					1,

							/obj/item/weapon/gun/energy/staff/focus = 			2,
							/obj/structure/closet/wizard/armor = 				2,
							/obj/item/weapon/gun/energy/staff/animate = 		2,
							/obj/item/weapon/contract/wizard/xray = 		    1,
							/obj/item/weapon/contract/wizard/tk = 		    	2,
							/obj/item/weapon/monster_manual = 					2,
							/obj/item/weapon/magic_rock = 						1,
							/obj/item/weapon/contract/apprentice = 				2
							)

	sacrifice_objects = list(/obj/item/stack/material/phoron, /obj/item/stack/material/uranium)