//all about moving around and mobility and being an annoying shit.

/obj/item/spellbook/spatial
	spellbook_type = /datum/spellbook/spatial

/datum/spellbook/spatial
	name = "\improper Spatial Manual"
	feedback = "SP"
	desc = "You feel like this might disappear from out of under you."
	book_desc = "Movement and teleportation. Run from your problems!"
	title = "Manual of Spatial Transportation"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE
	max_uses = 11

	spells = list(
		/datum/spell/targeted/ethereal_jaunt = 1,
		/datum/spell/aoe_turf/blink = 1,
		/datum/spell/area_teleport = 1,
		/datum/spell/portal_teleport = 1,
		/datum/spell/targeted/projectile/dumbfire/passage = 1,
		/datum/spell/mark_recall = 1,
		/datum/spell/targeted/swap = 1,
		/datum/spell/targeted/shapeshift/avian = 1,
		/datum/spell/targeted/projectile/magic_missile = 1,
		/datum/spell/targeted/heal_target = 1,
		/datum/spell/aoe_turf/conjure/forcewall = 1,
		/datum/spell/aoe_turf/smoke = 1,
		/datum/spell/aoe_turf/conjure/summon/bats = 3,
		/datum/spell/noclothes = 1,
		/obj/item/dice/d20/cursed = 1,
		/obj/structure/closet/wizard/scrying = 2,
		/obj/item/teleportation_scroll = 1,
		/obj/item/magic_rock = 1,
		/obj/item/summoning_stone = 3,
		/obj/item/contract/wizard/telepathy = 1,
		/obj/item/contract/apprentice = 1
	)

	sacrifice_reagents = list(/datum/reagent/hyperzine)
	sacrifice_objects = list(
		/obj/item/stack/telecrystal,
		/obj/item/stack/material/diamond
	)
