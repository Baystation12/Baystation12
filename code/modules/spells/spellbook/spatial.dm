//all about moving around and mobility and being an annoying shit.

/obj/item/weapon/spellbook/spatial
	spellbook_type = /datum/spellbook/spatial

/datum/spellbook/spatial
	name = "\improper Spatial Manual"
	desc = "You feel like this might disappear from out of under you."

	title = "Manual of Spatial Transportation"

	book_flags = 4
	max_uses = 10

	spell_name = list("Ethereal Jaunt" = 					"EJ",
					"Blink" = 								"BL",
					"Teleport" = 							"TP",
					"Passage" = 							"PA",
					"Mark/Recall" = 						"MK",
					"Swap" = 								"SW",
					"Avian Form" = 							"AV",
					"Magic Missile" = 						"MM",
					"Forcewall" = 							"FW",
					"Smoke" = 								"SM",
					"Summon Bats" = 						"SB",
					"Contract: Telekinesis" = 				"TK",
					"Artefact: Scrying Orb" = 				"SO",
					"Artefact: Teleportation Scroll" = 		"TS",
					"Artefact: Magical Rock" = 				"RA",
					"Contract: Apprenticeship" = 			"CP"
					)

	spell_desc = list("This spell creates your ethereal form, temporarily making you invisible and able to pass through walls.",
					"This spell randomly teleports you a short distance. Useful for evasion or getting into areas if you have patience.",
					"This spell teleports you to a type of area of your selection. Very useful if you are in danger, but has a decent cooldown, and is unpredictable.",
					"This spell creates a temporal projectile that you jump to when it lands.",
					"This spell creates a rune on the ground that you can jump to.",
					"This spell switches the brains between the wizard and the target, and then switches the bodies as well. Naturally, it will cause some damage.",
					"This spell transforms the wizard into a beautiful tropical bird.",
					"This spell fires several, slow moving, magic projectiles at nearby targets. If they hit a target, it is paralyzed and takes minor damage.",
					"This spell creates an unbreakable wall that lasts for 30 seconds and does not need wizard garb.",
					"This spell spawns a cloud of choking smoke at your location and does not require wizard garb.",
					"This spell summons a flock of space bats, ready to attack your foes and eat your fruit.",
					"This contract grants the recipient the ability to move objects with their mind.",
					"An incandescent orb of crackling energy, using it will allow you to ghost while alive, allowing you to spy upon the station with ease. In addition, buying it will permanently grant you x-ray vision.",
					"The legendary teleportation scroll, used by most wizards to move around the mortal realm as well as find the nearest bathroom.",
					"It is said this rock unlocks the potential of the person that uses it.",
					"A standardized Wizarding Apprenticeship contract. Lets a wizard contract a non-wizard into an apprenticeship."
					)
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
				/obj/structure/closet/wizard/scrying = 			2,
				/obj/item/weapon/teleportation_scroll = 		1,
				/obj/item/weapon/magic_rock = 					1,
				/obj/item/weapon/contract/apprentice = 			1
				)