//the spellbook we know and love. Well, the one we know, at least.

/obj/item/weapon/spellbook/standard
	spellbook_type = /datum/spellbook/standard

/datum/spellbook/standard
	name = "\improper Standard Spellbook"
	feedback = "SB"
	title = "Book of Spells and Artefacts"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_desc = "A general wizard's spellbook. All its spells are easy to use but hard to master."
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE
	max_uses = 5

	spells = list(/spell/targeted/projectile/magic_missile = 			1,
							/spell/targeted/projectile/dumbfire/fireball = 		1,
							/spell/aoe_turf/disable_tech = 						1,
							/spell/aoe_turf/smoke = 							1,
							/spell/targeted/genetic/blind = 					1,
							/spell/targeted/subjugation = 						1,
							/spell/aoe_turf/conjure/forcewall = 				1,
							/spell/aoe_turf/blink = 							1,
							/spell/area_teleport = 								1,
							/spell/targeted/genetic/mutate = 					1,
							/spell/targeted/ethereal_jaunt = 					1,
							/spell/aoe_turf/knock = 							1,
							/spell/noclothes = 									2,
							/obj/item/weapon/gun/energy/staff = 				1,
							/obj/item/weapon/gun/energy/staff/focus = 			1,
							/obj/structure/closet/wizard/souls = 				1,
							/obj/structure/closet/wizard/armor = 				1,
							/obj/item/weapon/gun/energy/staff/animate = 		1,
							/obj/structure/closet/wizard/scrying = 				1,
							/obj/item/weapon/monster_manual = 					2,
							/obj/item/weapon/magic_rock = 						1,
							/obj/item/weapon/contract/apprentice = 				1
							)

	sacrifice_objects = list(/obj/item/stack/material/gold,
							/obj/item/stack/material/silver)