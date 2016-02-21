#define DESTROY_AFTER_USE 	1
#define LOCKED 				2
#define CAN_MAKE_CONTRACTS	4


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
	var/datum/spellbook/spells
	var/spellbook_type = /datum/spellbook/ //for spawning specific spellbooks.

/obj/item/weapon/spellbook/New()
	..()
	set_spellbook(spellbook_type)

/obj/item/weapon/spellbook/proc/set_spellbook(var/type)
	if(spells)
		qdel(spells)
	spells = new type()
	uses = spells.max_uses
	name = spells.name
	desc = spells.desc

/obj/item/weapon/spellbook/attack_self(mob/user as mob)
	if(user.mind)
		if(!wizards.is_antagonist(user.mind))
			user << "You can't make heads or tails of this book."
			return
		if(spells.book_flags & LOCKED)
			if(user.mind.special_role == "apprentice")
				user << "<span class='warning'>Drat! This spellbook's apprentice proof lock is on!.</span>"
				return
			else
				user << "You notice the apprentice proof lock is on. Luckily you are beyond such things and can open it anyways."

	interact(user)

/obj/item/weapon/spellbook/interact(mob/user as mob)
	var/dat = null
	if(temp)
		dat = "[temp]<br><a href='byond://?src=\ref[src];temp=1'>Return</a>"
	else
		dat = "<center><h3>[spells.title]</h3><i>[spells.title_desc]</i><br>You have [uses] spell slot[uses > 1 ? "s" : ""] left.</center><br>"
		for(var/i=1;i<=spells.spell_name.len;i++)
			dat += "<A href='byond://?src=\ref[src];path=[spells.spells[i]]'>[spells.spell_name[i]]</a> ([spells.spells[spells.spells[i]]] spell slot[spells.spells[spells.spells[i]] > 1 ? "s" : "" ]) [spells.book_flags & CAN_MAKE_CONTRACTS ? "<A href='byond://?src=\ref[src];path=[spells.spells[i]];contract=1;name=[spells.spell_name[i]]'>Make Contract</a>" : ""]<br><i>[spells.spell_desc[i]]</i><br>"
		dat += "<center><A href='byond://?src=\ref[src];reset=1'>Re-memorize your spells.</a></center>"
		dat += "<center><A href='byond://?src=\ref[src];lock=1'>[spells.book_flags & LOCKED ? "Unlock" : "Lock"] the spellbook.</a></center>"
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
		if(spells.book_flags & LOCKED)
			spells.book_flags &= ~LOCKED
		else
			spells.book_flags |= LOCKED

	if(href_list["temp"])
		temp = null

	if(href_list["path"])
		var/path = text2path(href_list["path"])
		if(uses < spells.spells[path])
			usr << "<span class='notice'>You do not have enough spell slots to purchase this.</span>"
			return
		//add feedback
		if(spells.spell_name[path])
			feedback_add_details("wizard_spell_learned","[spells.spell_name[path]]")
		uses -= spells.spells[path]
		if(ispath(path,/datum/spellbook))
			src.set_spellbook(path)
			temp = "You have chosen a new spellbook."
		else
			if(href_list["contract"])
				if(!(spells.book_flags & CAN_MAKE_CONTRACTS))
					return //no
				spells.max_uses -= spells.spells[path] //no basksies
				var/name = href_list["name"]
				new /obj/item/weapon/contract/boon(get_turf(usr),name,path)
				temp = "You have purchased the [name] contract."
			else
				if(ispath(path,/spell))
					temp = src.add_spell(usr,path)
				else
					new path(get_turf(usr))
					temp = "You have purchased an artifact."
					spells.max_uses -= spells.spells[path]
					//finally give it a bit of an oomf
					playsound(get_turf(usr),'sound/effects/phasein.ogg',50,1)
				if(uses == 0 && spells.book_flags & DESTROY_AFTER_USE)
					usr << "<span class='warning'>\The [src] fades away!</span>"
					H << browse(null,"window=spellbook")
					H.drop_from_inventory(src)
					qdel(src)
	if(href_list["reset"])
		var/area/wizard_station/A = locate()
		if(usr in A.contents)
			uses = spells.max_uses
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

/datum/spellbook
	var/name = "\improper Book of Tomes"
	var/desc = "The legendary book of spells of the wizard."
	var/book_flags = 1
	var/max_uses = 1
	var/title = "Book of Tomes"
	var/title_desc = "This tome marks down all the available tomes for use. Choose wisely, there are no refunds."
	var/list/spell_name = list("Standard Spell Book" = 		"SB",
					"Cleric's Tome"        = 				"CR",
					"Battlemage's Bible"  = 				"BM",
					"Spatial Manual" = 						"SP",
					"Druid's Leaflet" = 					"DL",
					"Student's Spell Book" = 				"ST"
					) //spell name = spell feedback initials (Make sure the initials are consistent between spellbooks and are unique to each spell/artifact)
	var/list/spell_desc = list("This spell book was standardized by the Wizard Acadamy for use with general wizarding activities.",
					"A Cleric's spellbook. Filled with healing and self defense magical spells and artifacts.",
					"Full of knowledge on battle and magic. Often both.",
					"A book for those who don't like to walk anywhere, it provides many different mobility spells.",
					"A book all about nature and its beasts, this magic relies on the elements and the brute strength of allies.",
					"This spell book is popular with children due to its easy to use list of spells and indepth explanation of how to be a wizard."
					)
	var/list/spells = list(/datum/spellbook/standard = 1,
				/datum/spellbook/cleric = 1,
				/datum/spellbook/battlemage = 1,
				/datum/spellbook/spatial = 1,
				/datum/spellbook/druid = 1,
				/datum/spellbook/student = 1
				) //spell's path = cost of spell
