//all about moving around and mobility.
/obj/item/weapon/spellbook/spatial
	name = "Spatial Manual"
	desc = "You feel like this might disappear from out of under you."

	title = "Manual of Spatial Transportation"

	book_flags = 4
	max_uses = 10

	spell_name = list("Ethereal Jaunt" = 					"EJ",
					"Blink" = 								"BL",
					"Teleport" = 							"TP",
					"Passage" = 							"PA",
					"Mark/Recall" = 						"MK",
					"Smoke" = 								"SM",
					"Contract: Telekinesis" = 				"TK",
					"Contract: Apprenticeship" = 			"CP"
					)

	spell_desc = list("This spell creates your ethereal form, temporarily making you invisible and able to pass through walls.",
					"This spell randomly teleports you a short distance. Useful for evasion or getting into areas if you have patience.",
					"This spell teleports you to a type of area of your selection. Very useful if you are in danger, but has a decent cooldown, and is unpredictable.",
					"This spell creates a temporal projectile that you jump to when it lands.",
					"This spell creates a rune on the ground that you can jump to.",
					"This spell spawns a cloud of choking smoke at your location and does not require wizard garb.",
					"This contract grants the recipient the ability to move objects with their mind.",
					"A standardized Wizarding Apprenticeship contract. Lets a wizard contract a non-wizard into an apprenticeship."
					)
	spells = list(/spell/targeted/ethereal_jaunt = 				1,
				/spell/aoe_turf/blink = 						1,
				/spell/area_teleport = 							1,
				/spell/targeted/projectile/dumbfire/passage = 	1,
				/spell/mark_recall = 							1,
				/spell/aoe_turf/smoke = 						1,
				/obj/item/weapon/contract/wizard/tk = 			5,
				/obj/item/weapon/contract/apprentice = 			1
				)