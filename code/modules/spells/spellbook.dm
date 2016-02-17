/obj/item/weapon/spellbook
	name = "master spell book"
	desc = "The legendary book of spells of the wizard."
	icon = 'icons/obj/library.dmi'
	icon_state = "spellbook"
	throw_speed = 1
	throw_range = 5
	w_class = 2
	var/uses = 1
	var/temp = null
	var/max_uses = 1
	var/locked = 0
	var/destroy_after_use = 1


	var/title = "Book of Tomes"
	var/title_desc = "This tome marks down all the available tomes for use. Choose wisely, there are no refunds."
	var/list/spell_name = list("Standard Spell Book" = "SB",
					"Cleric's Tome"        = "CR",
					"Battlemage's Bible"  = "BM",
					"Student's Spell Book" = "ST",
					)
	var/list/spell_desc = list("This spell book was standardized by the Wizard Acadamy for use with general wizarding activities.",
					"A Cleric's spellbook. Filled with healing and self defense magical spells and artifacts.",
					"Full of knowledge on battle and magic. Often both.",
					"This spell book is popular with children due to its easy to use list of spells and indepth explanation of how to be a wizard."
					)
	var/list/spells = list(/obj/item/weapon/spellbook = 1,
				/obj/item/weapon/spellbook/cleric = 1,
				/obj/item/weapon/spellbook/battlemage = 1,
				/obj/item/weapon/spellbook/student = 1
				)


/obj/item/weapon/spellbook/attack_self(mob/user as mob)
	if(user.mind)
		if(!wizards.is_antagonist(user.mind))
			user << "You can't make heads or tails of this book."
			return
		if(locked)
			if(user.mind.special_role == "apprentice")
				user << "Drat! This spellbook's apprentice proof lock is on!."
				return
			else
				user << "You notice the apprentice proof lock is on. Luckily you are beyond such things and can open it anyways."

	interact(user)

/obj/item/weapon/spellbook/interact(mob/user as mob)
	var/dat = null
	if(temp)
		dat = "[temp]<br><a href='byond://?src=\ref[src];temp=1'>Return</a>"
	else
		dat = "<center><h3>[title]</h3><i>[title_desc]</i><br>You have [uses] spell slots left.</center><br>"
		for(var/i=1;i<=spell_name.len;i++)
			dat += "<A href='byond://?src=\ref[src];path=[spells[i]]'>[spell_name[i]]</a> ([spells[spells[i]]] spell slots)<br><i>[spell_desc[i]]</i><br>"
		dat += "<center><A href='byond://?src=\ref[src];reset=1'>Re-memorize your spells.</a></center>"
		dat += "<center><A href='byond://?src=\ref[src];lock=1'>[locked ? "Unlock" : "Lock"] the spellbook.</a></center>"
	user << browse(dat,"window=spellbook")

/obj/item/weapon/spellbook/Topic(href,href_list)
	..()

	var/mob/living/carbon/human/H = usr

	if(H.stat || H.restrained())
		return

	if(!istype(H))
		return

	if(!H.contents.Find(src))
		H << browse(null,"window=spellbook")
		return

	if(href_list["lock"])
		locked = !locked

	if(href_list["temp"])
		temp = null

	if(href_list["path"])
		var/path = text2path(href_list["path"])
		if(uses < spells[path])
			usr << "<span class='notice'>You do not have enough spell slots to purchase this.</span>"
			return
		//add feedback
		if(spell_name[path])
			feedback_add_details("wizard_spell_learned","[spell_name[path]]")
		uses -= spells[path]
		if(ispath(path,/spell))
			temp = src.add_spell(usr,path)
		else
			new path(get_turf(usr))
			temp = "You have purchased an artifact."
			max_uses -= spells[path]
			//finally give it a bit of an oomf
			usr.audible_message("<h3>POOF</h3>")
			var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
			S.set_up(3,0,get_turf(usr))
			S.start()

			S = new()
			S.set_up(3,0,get_turf(usr))
			S.start()
		if(uses == 0 && destroy_after_use)
			usr << "<span class='warning'>\The [src] fades away!</span>"
			usr << browse(null,"window=spellbook")
			H.drop_from_inventory(src)
			qdel(src)
	if(href_list["reset"])
		var/area/wizard_station/A = locate()
		if(usr in A.contents)
			uses = max_uses
			H.spellremove()
			temp = "All spells have been removed. You may now memorize a new set of spells."
			feedback_add_details("wizard_spell_learned","UM") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
		else
			usr << "<span class='warning'>You must be in the wizard academy to re-memorize your spells.</span>"

	src.interact(usr)

/obj/item/weapon/spellbook/proc/add_spell(var/mob/user, var/spell_path)
	for(var/spell/S in user.spell_list)
		if(istype(S,spell_path))
			if(!S.can_improve())
				uses += spells[spell_path]
				return "You cannot improve the spell [S] further."
			user << "[S.can_improve(Sp_SPEED)] [S.can_improve(Sp_POWER)]" //this returns 1 1 how
			if(S.can_improve(Sp_SPEED) && S.can_improve(Sp_POWER))
				switch(alert(user, "Do you want to upgrade this spell's speed or power?", "Spell upgrade", "Speed", "Power", "Cancel"))
					if("Speed")
						return S.quicken_spell()
					if("Power")
						return S.empower_spell()
					else
						uses += spells[spell_path]
						return
			else if(S.can_improve(Sp_POWER))
				return S.empower_spell()
			else if(S.can_improve(Sp_SPEED))
				return S.quicken_spell()

	var/spell/S = new spell_path()
	user.add_spell(S)
	return "You learn the spell [S]"


/////////////////ALTERNATE SPELL BOOKS/////////////

//This book lets you spawn a tome of your choosing.
//BASICALLY TOMES ARE LIKE ARCHTYPES YEAH?
/obj/item/weapon/spellbook/standard
	name = "spellbook"

	title = "Book of Spells and Artefacts"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."

	destroy_after_use = 0
	uses = 5
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
							 "Curse of the Horseman" = 					"HH",
							 "Remove Clothes Requirement" = 			"NC",
							 "Artefact: Staff of Change" = 				"ST",
							 "Artefact: Mental Focus" = 				"MF",
							 "Artefact: Soul Shard Belt" = 				"SS",
							 "Artefact: Mastercrafted Armor Set" = 		"HS",
							 "Artefact: Staff of Animation" = 			"SA",
							 "Artefact: Scrying Orb" = 					"SO",
							 "Artefact: Monster Manual" = 				"MA"
							 ) //spell name = spell feedback initials (Make sure the initials are consistent between spellbooks and are unique to each spell/artifact)
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
							"This spell will curse a person to wear an unremovable horse mask (it has glue on the inside) and speak like a horse. It does not require wizard garb.",
							"Learn the technique to casting complex spells without needing wizard garb.",
							"An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself.",
							"An artefact that channels the will of the user into destructive bolts of force.",
							"Soul Stone Shards are ancient tools capable of capturing and harnessing the spirits of the dead and dying. The spell Artificer allows you to create arcane machines for the captured souls to pilot. This also includes the spell Artificer, used to create the shells used in construct creation.",
							"An artefact suit of armor that allows you to cast spells while providing more protection against attacks and the void of space.",
							"An arcane staff capable of shooting bolts of eldritch energy which cause inanimate objects to come to life. This magic doesn't affect machines.",
							"An incandescent orb of crackling energy, using it will allow you to ghost while alive, allowing you to spy upon the station with ease. In addition, buying it will permanently grant you x-ray vision.",
							"A tome dedicated to the cataloguing of various magical beasts. You can use it to summon a familiar using a passing soul."
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
							/spell/targeted/equip_item/horsemask = 				1,
							/spell/noclothes = 									2,
							/obj/item/weapon/gun/energy/staff = 				1,
							/obj/item/weapon/gun/energy/staff/focus = 			1,
							/obj/structure/closet/wizard/souls = 				1,
							/obj/structure/closet/wizard/armor = 				1,
							/obj/item/weapon/gun/energy/staff/animate = 		1,
							/obj/structure/closet/wizard/scrying = 				1,
							/obj/item/weapon/monster_manual = 					2
							) //spell's path = cost of spell


//Battlemage is all about mixing physical with the mystical in head to head combat.
//Things like utility and mobility come second.
/obj/item/weapon/spellbook/battlemage
	name = "Battlemage's Bible"
	title = "The Art of Magical Combat"

	destroy_after_use = 0
	uses = 5
	max_uses = 5

	spell_name = list("Passage" = 								"PA",
					"Fireball" = 								"FB",
					"Torment" = 								"TM",
					"Cure Light Wounds" = 						"CL",
					"Mutate" = 									"MU",
					"Remove Clothes Requirement" = 				"NC",
					"Artefact: Mastercrafted Armor Set" = 		"HS"
					)

	spell_desc = list("This spell creates a temporal projectile that you jump to when it lands.",
					"This spell fires a fireball in the direction you're facing and does not require wizard garb. Be careful not to fire it at people that are standing next to you.",
					"This spell causes those in its radius to feel pain like none other.",
					"A quickly recharging spell that heals minor amounts of damage.",
					"This spell causes you to turn into a hulk and gain telekinesis for a short while.",
					"Learn the technique to casting complex spells without needing wizard garb.",
					"An artefact suit of armor that allows you to cast spells while providing more protection against attacks and the void of space."
					)

	spells = list(/spell/targeted/projectile/dumbfire/passage = 	1,
				/spell/targeted/projectile/dumbfire/fireball = 		1,
				/spell/targeted/torment = 							1,
				/spell/targeted/heal_target = 						2,
				/spell/targeted/genetic/mutate = 					1,
				/spell/noclothes = 									1,
				/obj/structure/closet/wizard/armor = 				1
					)


//Cleric is all about healing. Mobility and offense comes at a higher price but not impossible.
/obj/item/weapon/spellbook/cleric
	name = "Cleric's Tome"
	title = "Cleric's Tome of Healing"

	destroy_after_use = 0
	uses = 6
	max_uses = 6

	spell_name = list("Cure Light Wounds" = 				"CL",
					"Cure Major Wounds" = 					"CM",
					"Heal Area" =							"HA",
					"Blind" = 								"BL",
					"Stun-cuff" = 							"SC",
					"Ethereal Jaunt" = 						"EJ",
					"Knock" = 								"KN",
					"Fireball" = 							"FB",
					"Forcewall" = 							"FW",
					"Artefact: Mental Focus" = 				"MF",
					)
	spell_desc = list("A quickly recharging spell that heals minor amounts of damage.",
					"A complex and powerful healing spell that can bring most people back from the brink of death. Requires wizard garb.",
					"A healing spell that heals everyone in an area a slight amount of damage.",
					"A self defense spell used by clerics everywhere to deal with rowdy patients.",
					"This spell shoots a bolt of energy that handcuffs and stuns a target.",
					"This spell creates your ethereal form, temporarily making you invisible and able to pass through walls.",
					"This spell opens nearby doors and does not require wizard garb.",
					"This spell fires a fireball in the direction you're facing and does not require wizard garb. Be careful not to fire it at people that are standing next to you.",
					"This spell creates an unbreakable wall that lasts for 30 seconds and does not need wizard garb.",
					"An artefact that channels the will of the user into destructive bolts of force."
					)
	spells = list(/spell/targeted/heal_target = 					1,
				/spell/targeted/heal_target/major = 				1,
				/spell/targeted/heal_target/area = 					1,
				/spell/targeted/genetic/blind = 					1,
				/spell/targeted/projectile/dumbfire/stuncuff = 		1,
				/spell/targeted/ethereal_jaunt = 					2,
				/spell/aoe_turf/knock = 							1,
				/spell/targeted/projectile/dumbfire/fireball = 		2,
				/spell/aoe_turf/conjure/forcewall = 				1,
				/obj/item/weapon/gun/energy/staff/focus = 			2
				)


//wizard's training wheels. Basically. Same shit as in the general one.

/obj/item/weapon/spellbook/student
	name = "student's spell book"
	desc = "This spell book has a sticker on it that says, 'certified for children 5 and older'."

	title = "Book of Spells and Education"
	title_desc = "Hello. Congratulations on becoming a wizard. You may be asking yourself: What? A wizard? Already? Of course! Anybody can become a wizard! Learning to be a good one is the hard part.<br>Without further adue, let us begin by learning the three concepts of wizardry, 'Spell slots', 'Spells', and 'Artifacts'.<br>Firstly lets try to understand the 'spell slot'. A spell slot is the measurable amount of spells and artifacts one tome can give. Most spells will only take up a singular spell slot, however more powerful spells/artifacts can take up more.<br>Spells are spells. They can have requirements, such as wizard garb, and most can be upgraded by purchasing additional spell slots for them. Most upgrades fall into two categories, 'Speed' and 'Power'. Speed upgrades decrease the time you have to spend recharging your spell. Power increases the potency of your spells. Spells are also special in that they can be refunded while inside the Wizard Acadamy, so if you want to test a spell out before moving out into the field, feel free to do that in the comfort of our home.<br>Artifacts, or 'Artefacts' as we call them, are powerful wizard tools or items made specially for wizards everywhere. Extremely potent, they cannot be refunded like spells, and some of them can be used by non-wizards, so be careful!<br>Knowing these three concepts puts you in a league above most wizards, however knowledge of spells is just as important so we've included a list of spells below made specifically for the beginning wizard. Make sure to read the instructional text we've included with them!"

	destroy_after_use = 0
	uses = 5
	max_uses = 5

	spell_name = list("Knock" = 				"KN",
					"Ethereal Jaunt" = 			"EJ",
					"Magic Missile" = 			"MM",
					"Artefact: Mental Focus" = 	"MF",
					"Artefact: Xray Contract" = "CX"
					)
	spell_desc = list("The Knock spell is one of the most important of the wizard's arsenal! It can be used to open all the doors around you, even the locked ones! No wizard worth their salt ignores this spell, especially since it doesn't require wizard garb.",
					"This spell disolves you into a ghostly liquid, allowing you to move past walls and hazards for a short duration before rematerializing. A good spell for escaping or getting into trouble. It does require wizard garb, however, so it will not help naked or misclothed wizards!",
					"This spell creates small, firey orbs that track down nearby people and knock them over. A good self defense spell, using this spell and then Ethereal Jaunt will get you out of most dangerous situations.",
					"An artifact that hones your mind's power to deal a destructive bolt of energy. It can also be used to move doors, so be careful around airlocks! It naturally recharges on its own, albeit slowly. It fits snugly on your back.",
					"This artifact is a soul contract, a specially designed legal document that makes the owner of the contract the recipient of your soul when you die. Contract holders have great power over the signed folks, so be careful signing these things! However if you're looking at this tome in the college right now, we already own your soul, so feel free to take this one on us!"
					)
	spells = list(/spell/aoe_turf/knock = 1,
				/spell/targeted/ethereal_jaunt = 1,
				/spell/targeted/projectile/magic_missile = 1,
				/obj/item/weapon/gun/energy/staff/focus = 1,
				/obj/item/weapon/contract/wizard/xray = 1
					)