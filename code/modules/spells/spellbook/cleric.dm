//Cleric is all about healing. Mobility and offense comes at a higher price but not impossible.
/obj/item/weapon/spellbook/cleric
	spellbook_type = /datum/spellbook/cleric

/datum/spellbook/cleric
	name = "Cleric's Tome"
	desc = "For those who do not harm, or at least feel sorry about it."
	title = "Cleric's Tome of Healing"

	book_flags = 4
	max_uses = 6

	spell_name = list("Cure Light Wounds" = 				"CL",
					"Cure Major Wounds" = 					"CM",
					"Heal Area" =							"HA",
					"Sacrifice" = 							"SF",
					"Blind" = 								"BL",
					"Stun-cuff" = 							"SC",
					"Ethereal Jaunt" = 						"EJ",
					"Knock" = 								"KN",
					"Summon Holy Relic" = 					"SR",
					"Grove" = 								"GO",
					"Fireball" = 							"FB",
					"Forcewall" = 							"FW",
					"Artefact: Magical Rock" = 				"RA",
					"Artefact: Mental Focus" = 				"MF",
					"Contract: Apprenticeship" = 			"CP"
					)
	spell_desc = list("A quick recharging spell that heals a minor amount of damage.",
					"A complex and powerful healing spell that can bring most people back from the brink of death. Requires wizard garb.",
					"A healing spell that heals everyone in an area a slight amount of damage.",
					"This spell is for when death is imminent, and only the greatest sacrifices can be made to help those in need. It deals tremendous damage to the wizard, but its heal is powerful.",
					"A self defense spell used by clerics everywhere to deal with rowdy patients.",
					"This spell shoots a bolt of energy that handcuffs and stuns a target.",
					"This spell creates your ethereal form, temporarily making you invisible and able to pass through walls.",
					"This spell opens nearby doors and does not require wizard garb.",
					"This spell summons a purifying relic into your hand. Requires wizard garb.",
					"This spell summons a sacred natural sanctuary and will grow potent healing plants.",
					"This spell fires a fireball in the direction you're facing and does not require wizard garb. Be careful not to fire it at people that are standing next to you.",
					"This spell creates an unbreakable wall that lasts for 30 seconds and does not need wizard garb.",
					"It is said this rock unlocks the potential of the person that uses it.",
					"An artefact that channels the will of the user into destructive bolts of force.",
					"A standardized Wizarding Apprenticeship contract. Lets a wizard contract a non-wizard into an apprenticeship."
					)
	spells = list(/spell/targeted/heal_target = 					1,
				/spell/targeted/heal_target/major = 				1,
				/spell/targeted/heal_target/area = 					1,
				/spell/targeted/heal_target/sacrifice = 			1,
				/spell/targeted/genetic/blind = 					1,
				/spell/targeted/projectile/dumbfire/stuncuff = 		1,
				/spell/targeted/ethereal_jaunt = 					2,
				/spell/aoe_turf/knock = 							1,
				/spell/targeted/equip_item/holy_relic = 			1,
				/spell/aoe_turf/conjure/grove = 					1,
				/spell/targeted/projectile/dumbfire/fireball = 		2,
				/spell/aoe_turf/conjure/forcewall = 				1,
				/obj/item/weapon/magic_rock = 						1,
				/obj/item/weapon/gun/energy/staff/focus = 			2,
				/obj/item/weapon/contract/apprentice = 				1
				)