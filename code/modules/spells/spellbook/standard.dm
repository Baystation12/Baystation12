//the spellbook we know and love. Well, the one we know, at least.

/obj/item/weapon/spellbook/standard
	spellbook_type = /datum/spellbook/standard

/datum/spellbook/standard
	name = "\improper Standard Spellbook"
	feedback = "SB"
	title = "Book of Spells and Artefacts"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_desc = "A general wizard's spellbook. All its spells are easy to use but hard to master."
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE|NOREVERT|STANDARD
	max_uses = 9

	spells = list(	/spell/targeted/projectile/magic_missile = 			1,
					/spell/targeted/projectile/dumbfire/fireball = 		1,
					/spell/targeted/heal_target = 						1,
					/spell/aoe_turf/disable_tech = 						1,
					/spell/aoe_turf/smoke = 							1,
					/spell/targeted/genetic/blind = 					1,
					/spell/targeted/subjugation = 						1,
					/spell/aoe_turf/conjure/forcewall = 				1,
					/spell/aoe_turf/conjure/mirage = 					1,
					/spell/aoe_turf/conjure/summon/bats = 				1,
					/spell/aoe_turf/conjure/summon/bear = 				1,
					/spell/targeted/equip_item/party_hardy = 			1,
					/spell/targeted/shapeshift/avian = 					1,
					/spell/targeted/shapeshift/corrupt_form = 			1,
					/spell/targeted/shapeshift/baleful_polymorph = 		1,
					/spell/targeted/projectile/dumbfire/stuncuff = 		1,
					/spell/radiant_aura =								1,
					/spell/aoe_turf/blink = 							1,
					/spell/area_teleport = 								2,
					/spell/targeted/genetic/mutate = 					2,
					/spell/targeted/ethereal_jaunt = 					2,
					/spell/aoe_turf/blink = 							1,
					/spell/targeted/projectile/dumbfire/passage = 		1,
					/spell/mark_recall = 								1,
					/spell/targeted/swap = 								1,
					/spell/targeted/equip_item/knock = 					2,
					/spell/targeted/torment = 							1,
					/spell/hand/charges/entangle = 						1,
					/spell/aoe_turf/conjure/grove/sanctuary = 			1,
					/spell/noclothes = 									2,
					/spell/targeted/equip_item/dyrnwyn = 				1,
					/spell/targeted/equip_item/shield = 				1,
					/obj/structure/closet/wizard/robes = 				1,
					/obj/structure/closet/wizard/armor = 				2,
					/obj/item/weapon/gun/energy/staff/focus = 			1,
					/obj/structure/closet/wizard/souls = 				1,
					/obj/item/weapon/gun/energy/staff/animate = 		1,
					/obj/structure/closet/wizard/scrying = 				2,
					/obj/item/weapon/dice/d20/cursed = 					1,
					/obj/item/weapon/monster_manual = 					1,
					/obj/item/weapon/magic_rock = 						1,
					/obj/item/weapon/contract/wizard/tk = 				3,
					/obj/item/weapon/contract/wizard/telepathy = 		1,
					/obj/item/weapon/contract/apprentice = 				1
					)

	sacrifice_objects = list(/obj/item/stack/material/gold,
							/obj/item/stack/material/silver)