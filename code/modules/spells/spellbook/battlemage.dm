//Battlemage is all about mixing physical with the mystical in head to head combat.
//Things like utility and mobility come second.
/obj/item/weapon/spellbook/battlemage
	name = "Battlemage's Bible"
	desc = "Smells like blood."
	title = "The Art of Magical Combat"

	book_flags = 4
	max_uses = 5

	spell_name = list("Passage" = 								"PA",
					"Fireball" = 								"FB",
					"Torment" = 								"TM",
					"Cure Light Wounds" = 						"CL",
					"Mutate" = 									"MU",
					"Mirage" = 									"MR",
					"Remove Clothes Requirement" = 				"NC",
					"Artefact: Mastercrafted Armor Set" = 		"HS",
					"Artefact: Monster Manual" = 				"MA",
					"Contract: Apprenticeship" = 				"CP"
					)

	spell_desc = list("This spell creates a temporal projectile that you jump to when it lands.",
					"This spell fires a fireball in the direction you're facing and does not require wizard garb. Be careful not to fire it at people that are standing next to you.",
					"This spell causes those in its radius to feel pain like none other.",
					"A quick recharging spell that heals a minor amount of damage.",
					"This spell causes you to turn into a hulk and gain telekinesis for a short while.",
					"Summon a mirage of harmless fish to strike fear and disorder into those around you.",
					"Learn the technique to casting complex spells without needing wizard garb.",
					"An artefact suit of armor that allows you to cast spells while providing more protection against attacks and the void of space.",
					"A tome dedicated to the cataloguing of various magical beasts. You can use it to summon a familiar using a passing soul.",
					"A standardized Wizarding Apprenticeship contract. Lets a wizard contract a non-wizard into an apprenticeship."
					)

	spells = list(/spell/targeted/projectile/dumbfire/passage = 	1,
				/spell/targeted/projectile/dumbfire/fireball = 		1,
				/spell/targeted/torment = 							1,
				/spell/targeted/heal_target = 						2,
				/spell/targeted/genetic/mutate = 					1,
				/spell/aoe_turf/conjure/mirage = 					1,
				/spell/noclothes = 									1,
				/obj/structure/closet/wizard/armor = 				1,
				/obj/item/weapon/monster_manual = 					2,
				/obj/item/weapon/contract/apprentice = 				1
					)

