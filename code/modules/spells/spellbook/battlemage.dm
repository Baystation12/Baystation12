//Battlemage is all about mixing physical with the mystical in head to head combat.
//Things like utility and mobility come second.
/datum/spellbook/battlemage
	name = "\improper Battlemage's Bible"
	desc = "Smells like blood."
	title = "The Art of Magical Combat"

	book_flags = 4
	max_uses = 5

	spell_name = list("Passage" = 								"PA",
					"Summon Dyrnwyn" = 							"SD",
					"Summon Shield" = 							"SH",
					"Fireball" = 								"FB",
					"Torment" = 								"TM",
					"Cure Light Wounds" = 						"CL",
					"Mutate" = 									"MU",
					"Mind Swap" = 								"MT",
					"Mirage" = 									"MR",
					"Remove Clothes Requirement" = 				"NC",
					"Artefact: Mastercrafted Armor Set" = 		"HS",
					"Artefact: Mental Focus" = 					"MF",
					"Artefact: Monster Manual" = 				"MA",
					"Artefact: Magical Rock" = 					"RA",
					"Contract: Apprenticeship" = 				"CP"
					)

	spell_desc = list("This spell creates a temporal projectile that you jump to when it lands.",
					"This spell summons the legendary fire sword Dyrnwyn. Does not require clothes but will deal fire damage to the user.",
					"This spell summons a shield into the wizard's off hand. Often used during wizarding riots.",
					"This spell fires a fireball in the direction you're facing and does not require wizard garb. Be careful not to fire it at people that are standing next to you.",
					"This spell causes those in its radius to feel pain like none other.",
					"A quick recharging spell that heals a minor amount of damage.",
					"This spell causes you to turn into a hulk and gain telekinesis for a short while.",
					"This spell allows the user to switch bodies with a target. Careful to not lose your memory in the process.",
					"Summon a mirage of harmless fish to strike fear and disorder into those around you.",
					"Learn the technique to casting complex spells without needing wizard garb.",
					"An artefact suit of armor that allows you to cast spells while providing more protection against attacks and the void of space.",
					"An artefact that channels the will of the user into destructive bolts of force.",
					"A tome dedicated to the cataloguing of various magical beasts. You can use it to summon a familiar using a passing soul.",
					"It is said this rock unlocks the potential of the person that uses it.",
					"A standardized Wizarding Apprenticeship contract. Lets a wizard contract a non-wizard into an apprenticeship."
					)

	spells = list(/spell/targeted/projectile/dumbfire/passage = 	1,
				/spell/targeted/equip_item/dyrnwyn = 				1,
				/spell/targeted/equip_item/shield = 				1,
				/spell/targeted/projectile/dumbfire/fireball = 		1,
				/spell/targeted/torment = 							1,
				/spell/targeted/heal_target = 						2,
				/spell/targeted/genetic/mutate = 					1,
				/spell/targeted/mind_transfer = 					2,
				/spell/aoe_turf/conjure/mirage = 					1,
				/spell/noclothes = 									1,
				/obj/structure/closet/wizard/armor = 				1,
				/obj/item/weapon/gun/energy/staff/focus = 			1,
				/obj/item/weapon/monster_manual = 					2,
				/obj/item/weapon/magic_rock = 						1,
				/obj/item/weapon/contract/apprentice = 				1
					)

