#define NOREVERT			1
#define LOCKED 				2
#define CAN_MAKE_CONTRACTS	4
#define INVESTABLE			8
#define NO_LOCKING         16

//spells/spellbooks have a variable for this but as artefacts are literal items they do not.
//so we do this instead.
var/global/list/artefact_feedback = list(/obj/structure/closet/wizard/armor = 		"HS",
								/obj/item/gun/energy/staff/focus = 	"MF",
								/obj/item/summoning_stone = 			"ST",
								/obj/item/magic_rock = 				"RA",
								/obj/item/contract/apprentice = 		"CP",
								/obj/structure/closet/wizard/souls = 		"SS",
								/obj/structure/closet/wizard/scrying = 		"SO",
								/obj/item/teleportation_scroll = 	"TS",
								/obj/item/gun/energy/staff = 		"ST",
								/obj/item/gun/energy/staff/animate =	"SA",
								/obj/item/dice/d20/cursed = 			"DW")

/obj/item/spellbook
	name = "master spell book"
	desc = "The legendary book of spells of the wizard."
	icon = 'icons/obj/library.dmi'
	icon_state = "spellbook"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	var/uses = 1
	var/temp = null
	var/datum/spellbook/spellbook
	var/spellbook_type = /datum/spellbook/ //for spawning specific spellbooks.
	var/investing_time = 0 //what time we target forr a return on our spell investment.
	var/has_sacrificed = 0 //whether we have already got our sacrifice bonus for the current investment.

/obj/item/spellbook/New()
	..()
	set_spellbook(spellbook_type)

/obj/item/spellbook/proc/set_spellbook(var/type)
	if(spellbook)
		qdel(spellbook)
	spellbook = new type()
	uses = spellbook.max_uses
	name = spellbook.name
	desc = spellbook.desc

/obj/item/spellbook/attack_self(mob/user as mob)
	if(!user.mind)
		return
	if (user.mind.special_role != ANTAG_WIZARD)
		if (user.mind.special_role != ANTAG_APPRENTICE)
			to_chat(user, "You can't make heads or tails of this book.")
			return
		if (spellbook.book_flags & LOCKED)
			to_chat(user, "<span class='warning'>Drat! This spellbook's apprentice-proof lock is on!</span>")
			return
	else if (spellbook.book_flags & LOCKED)
		to_chat(user, "You notice the apprentice-proof lock is on. Luckily you are beyond such things.")
	interact(user)

/obj/item/spellbook/proc/make_sacrifice(obj/item/I as obj, mob/user as mob, var/reagent)
	if(has_sacrificed)
		to_chat(user, SPAN_WARNING("\The [src] is already sated! Wait for a return on your investment before you sacrifice more to it."))
		return
	if(reagent)
		var/datum/reagents/R = I.reagents
		R.remove_reagent(reagent,5)
	else
		if(istype(I,/obj/item/stack))
			var/obj/item/stack/S = I
			if(S.amount < S.max_amount)
				to_chat(usr, "<span class='warning'>You must sacrifice [S.max_amount] stacks of [S]!</span>")
				return
		qdel(I)
	to_chat(user, "<span class='notice'>Your sacrifice was accepted!</span>")
	has_sacrificed = 1
	investing_time = max(investing_time - 6000,1) //subtract 10 minutes. Make sure it doesn't act funky at the beginning of the game.


/obj/item/spellbook/attackby(obj/item/I as obj, mob/user as mob)
	if(investing_time)
		var/list/objects = spellbook.sacrifice_objects
		if(objects && objects.len)
			for(var/type in objects)
				if(istype(I,type))
					make_sacrifice(I,user)
					return
		if(I.reagents)
			var/datum/reagents/R = I.reagents
			var/list/reagent_list = spellbook.sacrifice_reagents
			if(reagent_list && reagent_list.len)
				for(var/id in reagent_list)
					if(R.has_reagent(id,5))
						make_sacrifice(I,user, id)
						return 1
	..()

/obj/item/spellbook/interact(mob/user as mob)
	var/dat = null
	if(temp)
		dat = "[temp]<br><a href='byond://?src=\ref[src];temp=1'>Return</a>"
	else
		dat = "<center><h3>[spellbook.title]</h3><i>[spellbook.title_desc]</i><br>You have [uses] spell slot[uses > 1 ? "s" : ""] left.</center><br>"
		dat += "<center><font color='#ff33cc'>Requires Wizard Garb</font><br><font color='#ff6600'>Selectable Target</font><br><font color='#33cc33'>Spell Charge Type: Recharge, Sacrifice, Charges</font></center><br>"
		dat += "<center><b>To use a contract, first bind it to your soul, then give it to someone to sign. This will bind their soul to you.</b></center><br>"
		for(var/i in 1 to spellbook.spells.len)
			var/name = "" //name of target
			var/desc = "" //description of target
			var/info = "" //additional information
			if(ispath(spellbook.spells[i],/datum/spellbook))
				var/datum/spellbook/S = spellbook.spells[i]
				name = initial(S.name)
				desc = initial(S.book_desc)
				info = "<font color='#ff33cc'>[initial(S.max_uses)] Spell Slots</font>"
			else if(ispath(spellbook.spells[i],/obj))
				var/obj/O = spellbook.spells[i]
				name = "Artefact: [capitalize(initial(O.name))]" //because 99.99% of objects don't have capitals in them and it makes it look weird.
				desc = initial(O.desc)
			else if(ispath(spellbook.spells[i],/spell))
				var/spell/S = spellbook.spells[i]
				name = initial(S.name)
				desc = initial(S.desc)
				var/testing = initial(S.spell_flags)
				if(testing & NEEDSCLOTHES)
					info = "<font color='#ff33cc'>W</font>"
				var/type = ""
				switch(initial(S.charge_type))
					if(Sp_RECHARGE)
						type = "R"
					if(Sp_HOLDVAR)
						type = "S"
					if(Sp_CHARGES)
						type = "C"
				info += "<font color='#33cc33'>[type]</font>"
			dat += "<A href='byond://?src=\ref[src];path=\ref[spellbook.spells[i]]'>[name]</a>"
			if(length(info))
				dat += " ([info])"
			dat += " ([spellbook.spells[spellbook.spells[i]]] spell slot[spellbook.spells[spellbook.spells[i]] > 1 ? "s" : "" ])"
			if(spellbook.book_flags & CAN_MAKE_CONTRACTS)
				dat += " <A href='byond://?src=\ref[src];path=\ref[spellbook.spells[i]];contract=1;'>Make Contract</a>"
			dat += "<br><i>[desc]</i><br><br>"
		dat += "<br>"
		dat += "<center><A href='byond://?src=\ref[src];reset=1'>Re-memorize your spellbook.</a></center>"
		if(spellbook.book_flags & INVESTABLE)
			if(investing_time)
				dat += "<center><b>Currently investing in a slot...</b></center>"
			else
				dat += "<center><A href='byond://?src=\ref[src];invest=1'>Invest a Spell Slot</a><br><i>Investing a spellpoint will return two spellpoints back in 15 minutes.<br>Some say a sacrifice could even shorten the time...</i></center>"
		if(!(spellbook.book_flags & NOREVERT))
			dat += "<center><A href='byond://?src=\ref[src];book=1'>Choose different spellbook.</a></center>"
		if(!(spellbook.book_flags & NO_LOCKING))
			dat += "<center><A href='byond://?src=\ref[src];lock=1'>[spellbook.book_flags & LOCKED ? "Unlock" : "Lock"] the spellbook.</a></center>"
	show_browser(user, dat,"window=spellbook")

/obj/item/spellbook/CanUseTopic(var/mob/living/carbon/human/H)
	if(!istype(H))
		return STATUS_CLOSE

	if(H.mind && (spellbook.book_flags & LOCKED) && H.mind.special_role == ANTAG_APPRENTICE) //make sure no scrubs get behind the lock
		return STATUS_CLOSE

	return ..()

/obj/item/spellbook/OnTopic(var/mob/living/carbon/human/user, href_list)
	if(href_list["lock"] && !(spellbook.book_flags & NO_LOCKING))
		if(spellbook.book_flags & LOCKED)
			spellbook.book_flags &= ~LOCKED
		else
			spellbook.book_flags |= LOCKED
		. = TOPIC_REFRESH

	else if(href_list["temp"])
		temp = null
		. = TOPIC_REFRESH

	else if(href_list["book"])
		if(initial(spellbook.max_uses) != spellbook.max_uses || uses != spellbook.max_uses)
			temp = "You've already purchased things using this spellbook!"
		else
			src.set_spellbook(/datum/spellbook)
			temp = "You have reverted back to the Book of Tomes."
		. = TOPIC_REFRESH

	else if(href_list["invest"])
		temp = invest()
		. = TOPIC_REFRESH

	else if(href_list["path"])
		var/path = locate(href_list["path"]) in spellbook.spells
		if(!path)
			return TOPIC_HANDLED
		if(uses < spellbook.spells[path])
			to_chat(user, "<span class='notice'>You do not have enough spell slots to purchase this.</span>")
			return TOPIC_HANDLED
		if(ispath(path,/datum/spellbook))
			src.set_spellbook(path)
			temp = "You have chosen a new spellbook."
		else
			if(href_list["contract"])
				if(!(spellbook.book_flags & CAN_MAKE_CONTRACTS))
					return //no
				uses -= spellbook.spells[path]
				spellbook.max_uses -= spellbook.spells[path] //no basksies
				var/obj/O = new /obj/item/contract/boon(get_turf(user),path)
				temp = "You have purchased \the [O]."
			else
				if(ispath(path,/spell))
					temp = src.add_spell(user,path)
					if(temp)
						uses -= spellbook.spells[path]
				else
					var/obj/O = new path(get_turf(user))
					temp = "You have purchased \a [O]."
					uses -= spellbook.spells[path]
					spellbook.max_uses -= spellbook.spells[path]
					//finally give it a bit of an oomf
					playsound(get_turf(user),'sound/effects/phasein.ogg',50,1)
		. = TOPIC_REFRESH

	else if(href_list["reset"] && !(spellbook.book_flags & NOREVERT))
		var/area/map_template/wizard_station/A = get_area(user)
		if(istype(A))
			uses = spellbook.max_uses
			investing_time = 0
			has_sacrificed = 0
			user.spellremove()
			temp = "All spells and investments have been removed. You may now memorize a new set of spells."
		else
			to_chat(user, "<span class='warning'>You must be in the wizard academy to re-memorize your spells.</span>")
		. = TOPIC_REFRESH

	src.interact(user)

/obj/item/spellbook/proc/invest()
	if(uses < 1)
		return "You don't have enough slots to invest!"
	if(investing_time)
		return "You can only invest one spell slot at a time."
	uses--
	START_PROCESSING(SSobj, src)
	investing_time = world.time + (15 MINUTES)
	return "You invest a spellslot and will receive two in return in 15 minutes."

/obj/item/spellbook/Process()
	if(investing_time && investing_time <= world.time)
		src.visible_message("<b>\The [src]</b> emits a soft chime.")
		uses += 2
		if(uses > spellbook.max_uses)
			spellbook.max_uses = uses
		investing_time = 0
		has_sacrificed = 0
		STOP_PROCESSING(SSobj, src)
	return 1

/obj/item/spellbook/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()


/obj/item/spellbook/proc/add_spell(var/mob/user, var/spell_path)
	for(var/spell/S in user.mind.learned_spells)
		if(istype(S,spell_path))
			if(!S.can_improve())
				return
			if(S.can_improve(Sp_SPEED) && S.can_improve(Sp_POWER))
				switch(alert(user, "Do you want to upgrade this spell's speed or power?", "Spell upgrade", "Speed", "Power", "Cancel"))
					if("Speed")
						return S.quicken_spell()
					if("Power")
						return S.empower_spell()
					else
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
	var/book_desc = "Holds information on the various tomes available to a wizard"
	var/feedback = "" //doesn't need one.
	var/book_flags = NOREVERT
	var/max_uses = 1
	var/title = "Book of Tomes"
	var/title_desc = "This tome marks down all the available tomes for use. Choose wisely, there are no refunds."
	var/list/spells = list(/datum/spellbook/standard = 1,
				/datum/spellbook/cleric = 1,
				/datum/spellbook/battlemage = 1,
				/datum/spellbook/spatial = 1,
				/datum/spellbook/druid = 1
				) //spell's path = cost of spell

	var/list/sacrifice_reagents
	var/list/sacrifice_objects
