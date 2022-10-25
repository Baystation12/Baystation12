//all about the summons, nature, and a bit o' healin.

/obj/item/spellbook/druid
	spellbook_type = /datum/spellbook/druid

/datum/spellbook/druid
	name = "\improper Druid's Leaflet"
	feedback = "DL"
	desc = "It smells like an air freshener."
	book_desc = "Summons, nature, and a bit o' healin."
	title = "Druidic Guide on how to be smug about nature"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE
	max_uses = 6

	spells = list(
		/datum/spell/targeted/heal_target = 1,
		/datum/spell/targeted/heal_target/sacrifice = 1,
		/datum/spell/aoe_turf/conjure/mirage = 1,
		/datum/spell/aoe_turf/conjure/summon/bats = 1,
		/datum/spell/aoe_turf/conjure/summon/bear = 1,
		/datum/spell/targeted/equip_item/party_hardy = 1,
		/datum/spell/targeted/equip_item/seed = 1,
		/datum/spell/targeted/shapeshift/avian = 1,
		/datum/spell/aoe_turf/disable_tech = 1,
		/datum/spell/hand/charges/entangle = 1,
		/datum/spell/aoe_turf/conjure/grove/sanctuary = 1,
		/datum/spell/aoe_turf/knock = 1,
		/datum/spell/area_teleport = 2,
		/datum/spell/portal_teleport = 2,
		/datum/spell/noclothes = 1,
		/obj/structure/closet/wizard/souls = 1,
		/obj/item/magic_rock = 1,
		/obj/item/summoning_stone = 2,
		/obj/item/contract/wizard/telepathy = 1,
		/obj/item/contract/apprentice = 1
	)
	sacrifice_objects = list(
		/obj/item/seeds,
		/obj/item/wirecutters/clippers,
		/obj/item/device/scanner/plant,
		/obj/item/material/hatchet,
		/obj/item/material/minihoe
	)
