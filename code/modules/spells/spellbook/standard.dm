//the spellbook we know and love. Well, the one we know, at least.

/obj/item/weapon/spellbook/standard
	name = "spellbook"

	title = "Book of Spells and Artefacts"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."

	book_flags = 4
	max_uses = 5

	spell_name = list("Magic Missile" = 						"MM",
							 "Fireball" = 								"FB",
							 "Disable Technology" = 					"DT",
							 "Smoke" = 									"SM",
							 "Blind" = 									"BD",
							 "Subjugate" = 								"SJ",
							 "Mind Swap" = 								"MT",
							 "Cure Light Wounds" = 						"CL",
							 "Blink" = 									"BL",
							 "Teleport" = 								"TP",
							 "Mutate" = 								"MU",
							 "Ethereal Jaunt" = 						"EJ",
							 "Knock" = 									"KN",
							 "Remove Clothes Requirement" = 			"NC",
							 "Artefact: Staff of Change" = 				"ST",
							 "Artefact: Mental Focus" = 				"MF",
							 "Artefact: Soul Shard Belt" = 				"SS",
							 "Artefact: Mastercrafted Armor Set" = 		"HS",
							 "Artefact: Staff of Animation" = 			"SA",
							 "Artefact: Scrying Orb" = 					"SO",
							 "Artefact: Monster Manual" = 				"MA",
							 "Contract: Apprenticeship" = 				"CP"
							 )
	spell_desc = list("This spell fires several, slow moving, magic projectiles at nearby targets. If they hit a target, it is paralyzed and takes minor damage.",
							"This spell fires a fireball in the direction you're facing and does not require wizard garb. Be careful not to fire it at people that are standing next to you.",
							"This spell disables all weapons, cameras and most other technology in range.",
							"This spell spawns a cloud of choking smoke at your location and does not require wizard garb.",
							"This spell temporarly blinds a single person and does not require wizard garb.",
							"This spell temporarily subjugates a target's mind and does not require wizard garb.",
							"This spell allows the user to switch bodies with a target. Careful to not lose your memory in the process.",
							"This spell heals minor amounts of damage.",
							"This spell randomly teleports you a short distance. Useful for evasion or getting into areas if you have patience.",
							"This spell teleports you to a type of area of your selection. Very useful if you are in danger, but has a decent cooldown, and is unpredictable.",
							"This spell causes you to turn into a hulk and gain telekinesis for a short while.",
							"This spell creates your ethereal form, temporarily making you invisible and able to pass through walls.",
							"This spell opens nearby doors and does not require wizard garb.",
							"Learn the technique to casting complex spells without needing wizard garb.",
							"An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself.",
							"An artefact that channels the will of the user into destructive bolts of force.",
							"Soul Stone Shards are ancient tools capable of capturing and harnessing the spirits of the dead and dying. The spell Artificer allows you to create arcane machines for the captured souls to pilot. This also includes the spell Artificer, used to create the shells used in construct creation.",
							"An artefact suit of armor that allows you to cast spells while providing more protection against attacks and the void of space.",
							"An arcane staff capable of shooting bolts of eldritch energy which cause inanimate objects to come to life. This magic doesn't affect machines.",
							"An incandescent orb of crackling energy, using it will allow you to ghost while alive, allowing you to spy upon the station with ease. In addition, buying it will permanently grant you x-ray vision.",
							"A tome dedicated to the cataloguing of various magical beasts. You can use it to summon a familiar using a passing soul.",
							"A standardized Wizarding Apprenticeship contract. Lets a wizard contract a non-wizard into an apprenticeship."
							)
	spells = list(/spell/targeted/projectile/magic_missile = 			1,
							/spell/targeted/projectile/dumbfire/fireball = 		1,
							/spell/aoe_turf/disable_tech = 						1,
							/spell/aoe_turf/smoke = 							1,
							/spell/targeted/genetic/blind = 					1,
							/spell/targeted/subjugation = 						1,
							/spell/targeted/mind_transfer = 					1,
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
							/obj/item/weapon/contract/apprentice = 				1
							)