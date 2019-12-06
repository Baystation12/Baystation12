//wizard's training wheels. Basically. Same shit as in the general one.

/obj/item/weapon/spellbook/student
	spellbook_type = /datum/spellbook/student

/datum/spellbook/student
	name = "\improper Student's Spellbook"
	feedback = "ST"
	desc = "This spell book has a sticker on it that says, 'certified for children 5 and older'."
	book_desc = "This spellbook is dedicated to teaching neophytes in the ways of magic."
	title = "Book of Spells and Education"
	title_desc = "Hello. Congratulations on becoming a wizard. You may be asking yourself: What? A wizard? Already? Of course! Anybody can become a wizard! Learning to be a good one is the hard part.<br>Without further adue, let us begin by learning the three concepts of wizardry, 'Spell slots', 'Spells', and 'Artifacts'.<br>Firstly lets try to understand the 'spell slot'. A spell slot is the measurable amount of spells and artifacts one tome can give. Most spells will only take up a singular spell slot, however more powerful spells/artifacts can take up more.<br>Spells are spells. They can have requirements, such as wizard garb, and most can be upgraded by purchasing additional spell slots for them. Most upgrades fall into two categories, 'Speed' and 'Power'. Speed upgrades decrease the time you have to spend recharging your spell. Power increases the potency of your spells. Spells are also special in that they can be refunded while inside the Wizard Acadamy, so if you want to test a spell out before moving out into the field, feel free to do that in the comfort of our home.<br>Artifacts, or 'Artefacts' as we call them, are powerful wizard tools or items made specially for wizards everywhere. Extremely potent, they cannot be refunded like spells, and some of them can be used by non-wizards, so be careful!<br>Knowing these three concepts puts you in a league above most wizards, however knowledge of spells is just as important so we've included a list of spells below made specifically for the beginning wizard. Take all of them, or mix and match, remember being creative is half of being a wizard!"
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE
	max_uses = 5

	spells = list(/spell/aoe_turf/knock = 						1,
				/spell/targeted/ethereal_jaunt = 				1,
				/spell/targeted/projectile/magic_missile = 		1,
				/obj/item/weapon/gun/energy/staff/focus = 		1,
				/obj/item/weapon/contract/wizard/xray = 		1
					)

/datum/spellbook/student/apprentice
	book_flags = CAN_MAKE_CONTRACTS|INVESTABLE|NOREVERT|NO_LOCKING

/obj/item/weapon/spellbook/apprentice
	spellbook_type = /datum/spellbook/student/apprentice