//all about the summons, nature, and a bit o' healin.
/obj/item/weapon/spellbook/druid
	name = "druid's leaflet"
	desc = "It smells like an air freshener."

	title = "Druidic Guide on how to be smug about nature"

	book_flags = 4
	max_uses = 5

	spell_name = list("Cure Light Wounds" = 				"CL",
					"Sacrifice" = 							"SF",
					"Summon Party" = 						"PY",
					"Contract: Apprenticeship" = 			"CP"
					)
	spell_desc = list("A healing spell that heals everyone in an area a slight amount of damage.",
					"This spell is for when death is imminent, and only the greatest sacrifices can be made to help those in need. It deals tremendous damage to the wizard, but its heal is powerful.",
					"This spell is an ancient one passed down from generation to generation of wizards, used by all of the greatest wizards in all of the universe to get drunk on a Tuesday.",
					"A standardized Wizarding Apprenticeship contract. Lets a wizard contract a non-wizard into an apprenticeship."
					)
	spells = list(/spell/targeted/heal_target = 					1,
				/spell/targeted/heal_target/sacrifice = 			1,
				/spell/targeted/equip_item/party_hardy = 			1,
				/obj/item/weapon/contract/apprentice = 				1
				)

