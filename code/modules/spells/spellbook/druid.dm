//all about the summons, nature, and a bit o' healin.

/obj/item/weapon/spellbook/druid
	spellbook_type = /datum/spellbook/druid

/datum/spellbook/druid
	name = "\improper Druid's Leaflet"
	desc = "It smells like an air freshener."

	title = "Druidic Guide on how to be smug about nature"

	book_flags = 4
	max_uses = 5

	spell_name = list("Cure Light Wounds" = 				"CL",
					"Sacrifice" = 							"SF",
					"Mirage" = 								"MR",
					"Summon Bats" = 						"SB",
					"Summon Bear" = 						"BR",
					"Summon Party" = 						"PY",
					"Summon Seed" = 						"SE",
					"Entangle" = 							"ET",
					"Disable Technology" = 					"DT",
					"Grove" = 								"GO",
					"Knock" = 								"KN",
					"Artefact: Soul Shard Belt" = 			"SS",
					"Artefact: Magical Rock" = 				"RA",
					"Artefact: Monster Manual" = 			"MA",
					"Contract: Apprenticeship" = 			"CP"
					)
	spell_desc = list("A healing spell that heals everyone in an area a slight amount of damage.",
					"This spell is for when death is imminent, and only the greatest sacrifices can be made to help those in need. It deals tremendous damage to the wizard, but its heal is powerful.",
					"Summon a mirage of harmless fish to strike fear and disorder into those around you.",
					"This spell summons a flock of space bats, ready to attack your foes and eat your fruit.",
					"This spell summons a common brown bear that will follow your instructions to the letter.",
					"This spell is an ancient one passed down from generation to generation of wizards, used by all of the greatest wizards in all of the universe to get drunk on a Tuesday.",
					"This spell summons a seed into the hands of its owner.",
					"This spell disables all weapons, cameras and most other technology in range.",
					"This spell summons mystical vines to entrap poor fellows.",
					"This spell summons a sacred natural sanctuary and will grow potent healing plants.",
					"This spell opens nearby doors and does not require wizard garb.",
					"Soul Stone Shards are ancient tools capable of capturing and harnessing the spirits of the dead and dying. The spell Artificer allows you to create arcane machines for the captured souls to pilot. This also includes the spell Artificer, used to create the shells used in construct creation.",
					"It is said this rock unlocks the potential of the person that uses it.",
					"A tome dedicated to the cataloguing of various magical beasts. You can use it to summon a familiar using a passing soul.",
					"A standardized Wizarding Apprenticeship contract. Lets a wizard contract a non-wizard into an apprenticeship."
					)
	spells = list(/spell/targeted/heal_target = 					1,
				/spell/targeted/heal_target/sacrifice = 			1,
				/spell/aoe_turf/conjure/mirage = 					1,
				/spell/aoe_turf/conjure/summon/bats = 				1,
				/spell/aoe_turf/conjure/summon/bear = 				1,
				/spell/targeted/equip_item/party_hardy = 			1,
				/spell/targeted/equip_item/seed = 					1,
				/spell/aoe_turf/disable_tech = 						1,
				/spell/targeted/entangle = 							1,
				/spell/aoe_turf/conjure/grove = 					1,
				/spell/aoe_turf/knock = 							1,
				/obj/structure/closet/wizard/souls = 				1,
				/obj/item/weapon/magic_rock = 						1,
				/obj/item/weapon/monster_manual = 					1,
				/obj/item/weapon/contract/apprentice = 				1
				)

