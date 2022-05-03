//the spellbook we know and love. Well, the one we know, at least.

/obj/item/spellbook/standard
	spellbook_type = /datum/spellbook/standard

/datum/spellbook/standard
	name = "\improper Standard Spellbook"
	feedback = "SB"
	title = "Book of Spells and Artefacts"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_desc = "A general wizard's spellbook. All its spells are easy to use but hard to master."
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE
	max_uses = 6

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
							/spell/targeted/heal_target = 						1,
							/spell/aoe_turf/knock = 							1,
							/spell/noclothes = 									2,
							/obj/item/gun/energy/staff/focus = 			1,
							/obj/structure/closet/wizard/souls = 				1,
							/obj/item/gun/energy/staff/animate = 		1,
							/obj/structure/closet/wizard/scrying = 				1,
							/obj/item/summoning_stone = 					2,
							/obj/item/magic_rock = 						1,
							/obj/item/contract/wizard/telepathy = 		1,
							/obj/item/contract/apprentice = 				1
							)

	sacrifice_objects = list(/obj/item/storage/toolbox,
							/obj/item/cane,
							/obj/item/flamethrower,
							/obj/item/plastique,
							/obj/item/dice,
							/obj/item/soap,
							/obj/item/flame/candle,
							/obj/item/flame/candle/scented/incense,
							/obj/item/caution,
							/obj/item/towel,
							/obj/item/tank/jetpack,
							/obj/item/clothing/mask/plunger,
							/obj/item/device/megaphone,
							/obj/item/deck/cards)