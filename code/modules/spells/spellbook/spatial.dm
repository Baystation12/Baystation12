//all about moving around and mobility and being an annoying shit.

/obj/item/weapon/spellbook/spatial
	spellbook_type = /datum/spellbook/spatial

/datum/spellbook/spatial
	name = "\improper Spatial Manual"
	feedback = "SP"
	desc = "You feel like this might disappear from out of under you."
	book_desc = "Movement and teleportation. Run from your problems!"
	title = "Manual of Spatial Transportation"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE
	max_uses = 10

	spells = list(/spell/targeted/ethereal_jaunt = 				1,
				/spell/aoe_turf/blink = 						1,
				/spell/area_teleport = 							1,
				/spell/targeted/projectile/dumbfire/passage = 	1,
				/spell/mark_recall = 							1,
				/spell/targeted/swap = 							1,
				/spell/targeted/shapeshift/avian = 				1,
				/spell/targeted/projectile/magic_missile = 		2,
				/spell/aoe_turf/conjure/forcewall = 			1,
				/spell/aoe_turf/smoke = 						1,
				/spell/aoe_turf/conjure/summon/bats = 			3,
				/obj/item/weapon/contract/wizard/tk = 			5,
				/obj/item/weapon/dice/d20/cursed = 				1,
				/obj/structure/closet/wizard/scrying = 			2,
				/obj/item/weapon/teleportation_scroll = 		1,
				/obj/item/weapon/magic_rock = 					1,
				/obj/item/weapon/contract/apprentice = 			1,
				/spell/noclothes = 								3
				)

	sacrifice_reagents = list("hyperzine")
	sacrifice_objects = list(/obj/item/stack/telecrystal)