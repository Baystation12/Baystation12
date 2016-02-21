//wizard's training wheels. Basically. Same shit as in the general one.

/obj/item/weapon/spellbook/student
	spellbook_type = /datum/spellbook/student

/datum/spellbook/student
	name = "student's spell book"
	desc = "This spell book has a sticker on it that says, 'certified for children 5 and older'."

	title = "Book of Spells and Education"
	title_desc = "Hello. Congratulations on becoming a wizard. You may be asking yourself: What? A wizard? Already? Of course! Anybody can become a wizard! Learning to be a good one is the hard part.<br>Without further adue, let us begin by learning the three concepts of wizardry, 'Spell slots', 'Spells', and 'Artifacts'.<br>Firstly lets try to understand the 'spell slot'. A spell slot is the measurable amount of spells and artifacts one tome can give. Most spells will only take up a singular spell slot, however more powerful spells/artifacts can take up more.<br>Spells are spells. They can have requirements, such as wizard garb, and most can be upgraded by purchasing additional spell slots for them. Most upgrades fall into two categories, 'Speed' and 'Power'. Speed upgrades decrease the time you have to spend recharging your spell. Power increases the potency of your spells. Spells are also special in that they can be refunded while inside the Wizard Acadamy, so if you want to test a spell out before moving out into the field, feel free to do that in the comfort of our home.<br>Artifacts, or 'Artefacts' as we call them, are powerful wizard tools or items made specially for wizards everywhere. Extremely potent, they cannot be refunded like spells, and some of them can be used by non-wizards, so be careful!<br>Knowing these three concepts puts you in a league above most wizards, however knowledge of spells is just as important so we've included a list of spells below made specifically for the beginning wizard. Make sure to read the instructional text we've included with them!"

	book_flags = 4
	max_uses = 5

	spell_name = list("Knock" = 				"KN",
					"Ethereal Jaunt" = 			"EJ",
					"Magic Missile" = 			"MM",
					"Artefact: Mental Focus" = 	"MF",
					"Contract: Xray" = 			"CX"
					)
	spell_desc = list("The Knock spell is one of the most important of the wizard's arsenal! It can be used to open all the doors around you, even the locked ones! No wizard worth their salt ignores this spell, especially since it doesn't require wizard garb.",
					"This spell disolves you into a ghostly liquid, allowing you to move past walls and hazards for a short duration before rematerializing. A good spell for escaping or getting into trouble. It does require wizard garb, however, so it will not help naked or misclothed wizards!",
					"This spell creates small, firey orbs that track down nearby people and knock them over. A good self defense spell, using this spell and then Ethereal Jaunt will get you out of most dangerous situations.",
					"An artifact that hones your mind's power to deal a destructive bolt of energy. It can also be used to move doors, so be careful around airlocks! It naturally recharges on its own, albeit slowly. It fits snugly on your back.",
					"This artifact is a soul contract, a specially designed legal document that makes the owner of the contract the recipient of your soul when you die. Contract holders have great power over the signed folks, so be careful signing these things! However if you're looking at this tome in the college right now, we already own your soul, so feel free to take this one on us!"
					)
	spells = list(/spell/aoe_turf/knock = 						1,
				/spell/targeted/ethereal_jaunt = 				1,
				/spell/targeted/projectile/magic_missile = 		1,
				/obj/item/weapon/gun/energy/staff/focus = 		1,
				/obj/item/weapon/contract/wizard/xray = 		1
					)