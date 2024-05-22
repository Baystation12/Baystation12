/obj/rune
	name = "rune"
	desc = "A strange collection of symbols drawn in blood."
	anchored = TRUE
	icon = 'icons/effects/uristrunes.dmi'
	icon_state = "blank"
	unacidable = TRUE
	layer = RUNE_LAYER

	var/blood
	var/bcolor
	var/strokes = 2 // IF YOU EVER SET THIS TO MORE THAN TEN, EVERYTHING WILL BREAK
	var/cultname = ""

/obj/rune/New(loc, blcolor = "#c80000", nblood = "blood")
	..()
	bcolor = blcolor
	blood = nblood
	update_icon()
	set_extension(src, /datum/extension/turf_hand, 10)

/obj/rune/on_update_icon()
	ClearOverlays()
	if(GLOB.cult.rune_strokes[type])
		var/list/f = GLOB.cult.rune_strokes[type]
		for(var/i in f)
			var/image/t = image('icons/effects/uristrunes.dmi', "rune-[i]")
			AddOverlays(t)
	else
		var/list/q = list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
		var/list/f = list()
		for(var/i = 1 to strokes)
			var/j = pick(q)
			f += j
			q -= f
			var/image/t = image('icons/effects/uristrunes.dmi', "rune-[j]")
			AddOverlays(t)
		GLOB.cult.rune_strokes[type] = f.Copy()
	color = bcolor
	desc = "A strange collection of symbols drawn in [blood]."

/obj/rune/examine(mob/user)
	. = ..()
	if(iscultist(user))
		to_chat(user, "This is \a [cultname] rune.")


/obj/rune/use_tool(obj/item/tool, mob/user, list/click_params)
	// Cultist Tome - Remove rune
	if (istype(tool, /obj/item/book/tome))
		if (!iscultist(user))
			return FALSE
		user.visible_message(
			SPAN_NOTICE("\The [user] rubs \the [src] with \a [tool], and \the [src] is absorbed by it."),
			SPAN_NOTICE("You retrace your steps, carefully undoing the lines of \the [src] with \the [tool].")
		)
		qdel(src)
		return TRUE

	// Null Rod - Remove rune
	if (istype(tool, /obj/item/nullrod))
		user.visible_message(
			SPAN_NOTICE("\The [user] hits \the [src] with \a [tool], and it disappears, fizzling."),
			SPAN_NOTICE("You disrupt \the [src]'s vile magic with the deadening field of \the [tool]."),
			SPAN_ITALIC("You hear a fizzle.")
		)
		qdel(src)
		return TRUE

	return ..()


/obj/rune/attack_hand(mob/living/user)
	if(!iscultist(user))
		to_chat(user, "You can't mouth the arcane scratchings without fumbling over them.")
		return
	if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle) || user.silent)
		to_chat(user, "You are unable to speak the words of the rune.")
		return
	if(GLOB.cult.powerless)
		to_chat(user, "You read the words, but nothing happens.")
		return fizzle(user)
	cast(user)

/obj/rune/attack_ai(mob/living/user) // Cult borgs!
	if(Adjacent(user))
		attack_hand(user)

/obj/rune/proc/cast(mob/living/user)
	fizzle(user)

/obj/rune/proc/get_cultists()
	. = list()
	for(var/mob/living/M in range(1))
		if(iscultist(M))
			. += M

/obj/rune/proc/fizzle(mob/living/user)
	visible_message(SPAN_WARNING("The markings pulse with a small burst of light, then fall dark."), "You hear a fizzle.")

//Makes the speech a proc so all verbal components can be easily manipulated as a whole, or individually easily
/obj/rune/proc/speak_incantation(mob/living/user, incantation)
	var/datum/language/L = all_languages[LANGUAGE_CULT]
	if(incantation && (L in user.languages))
		user.say(incantation, L)

/* Tier 1 runes below */

/obj/rune/convert
	cultname = "convert"
	var/spamcheck = 0

/obj/rune/convert/cast(mob/living/user)
	if(spamcheck)
		return

	var/mob/living/carbon/target = null
	for(var/mob/living/carbon/M in get_turf(src))
		if(!iscultist(M) && M.stat != DEAD)
			target = M
			break

	if(!target)
		return fizzle(user)

	speak_incantation(user, "Mah[pick("'","`")]weyh pleggh at e'ntrath!")
	target.visible_message(SPAN_WARNING("The markings below [target] glow a bloody red."))

	to_chat(target, SPAN_OCCULT("Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root."))
	if(!GLOB.cult.can_become_antag(target.mind, 1))
		to_chat(target, SPAN_DANGER("Are you going insane?"))
	else
		to_chat(target, SPAN_OCCULT("Do you want to join the cult of Nar'Sie? You can choose to ignore offer... <a href='?src=\ref[src];join=1'>Join the cult</a>."))

	spamcheck = 1
	spawn(40)
		spamcheck = 0
		if(!iscultist(target) && target.loc == get_turf(src)) // They hesitated, resisted, or can't join, and they are still on the rune - burn them
			if(target.stat == CONSCIOUS)
				target.take_overall_damage(0, 10)
				switch(target.getFireLoss())
					if(0 to 25)
						to_chat(target, SPAN_DANGER("Your blood boils as you force yourself to resist the corruption invading every corner of your mind."))
					if(25 to 45)
						to_chat(target, SPAN_DANGER("Your blood boils and your body burns as the corruption further forces itself into your body and mind."))
						target.take_overall_damage(0, 3)
					if(45 to 75)
						to_chat(target, SPAN_DANGER("You begin to hallucinate images of a dark and incomprehensible being and your entire body feels like its engulfed in flame as your mental defenses crumble."))
						target.take_overall_damage(0, 5)
					if(75 to 100)
						to_chat(target, SPAN_OCCULT("Your mind turns to ash as the burning flames engulf your very soul and images of an unspeakable horror begin to bombard the last remnants of mental resistance."))
						target.take_overall_damage(0, 10)

/obj/rune/convert/Topic(href, href_list)
	if(href_list["join"])
		if(usr.loc == loc && !iscultist(usr))
			GLOB.cult.add_antagonist(usr.mind, ignore_role = 1, do_not_equip = 1)

/obj/rune/teleport
	cultname = "teleport"
	var/destination

/obj/rune/teleport/New()
	..()
	var/area/A = get_area(src)
	destination = A.name
	GLOB.cult.teleport_runes += src

/obj/rune/teleport/Destroy()
	GLOB.cult.teleport_runes -= src
	var/turf/T = get_turf(src)
	for(var/atom/movable/A in contents)
		A.forceMove(T)
	return ..()

/obj/rune/teleport/examine(mob/user)
	. = ..()
	if(iscultist(user))
		to_chat(user, "Its name is [destination].")

/obj/rune/teleport/cast(mob/living/user)
	if(user.loc == src)
		showOptions(user)
	else if(user.loc == get_turf(src))
		speak_incantation(user, "Sas[pick("'","`")]so c'arta forbici!")
		if(do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			user.visible_message(SPAN_WARNING("\The [user] disappears in a flash of red light!"), SPAN_WARNING("You feel as your body gets dragged into the dimension of Nar-Sie!"), "You hear a sickening crunch.")
			user.forceMove(src)
			showOptions(user)
			var/warning = 0
			while(user.loc == src)
				user.take_organ_damage(0, 2)
				if(user.getFireLoss() > 50)
					to_chat(user, SPAN_DANGER("Your body can't handle the heat anymore!"))
					leaveRune(user)
					return
				if(warning == 0)
					to_chat(user, SPAN_WARNING("You feel the immerse heat of the realm of Nar-Sie..."))
					++warning
				if(warning == 1 && user.getFireLoss() > 15)
					to_chat(user, SPAN_WARNING("Your burns are getting worse. You should return to your realm soon..."))
					++warning
				if(warning == 2 && user.getFireLoss() > 35)
					to_chat(user, SPAN_WARNING("The heat! It burns!"))
					++warning
				sleep(10)
	else
		var/input = input(user, "Choose a new rune name.", "Destination", "") as text|null
		if(!input)
			return
		destination = sanitize(input)

/obj/rune/teleport/Topic(href, href_list)
	if(usr.loc != src)
		return
	if(href_list["target"])
		var/obj/rune/teleport/targ = locate(href_list["target"])
		if(istype(targ)) // Checks for null, too
			usr.forceMove(targ)
			targ.showOptions(usr)
	else if(href_list["leave"])
		leaveRune(usr)

/obj/rune/teleport/proc/showOptions(mob/living/user)
	var/list/t = list()
	for(var/obj/rune/teleport/T in GLOB.cult.teleport_runes)
		if(T == src)
			continue
		t += "<a href='?src=\ref[src];target=\ref[T]'>[T.destination]</a>"
	to_chat(user, "Teleport runes: [english_list(t, nothing_text = "no other runes exist")]... or <a href='?src=\ref[src];leave=1'>return from this rune</a>.")

/obj/rune/teleport/proc/leaveRune(mob/living/user)
	if(user.loc != src)
		return
	user.dropInto(loc)
	user.visible_message(SPAN_WARNING("\The [user] appears in a flash of red light!"), SPAN_WARNING("You feel as your body gets thrown out of the dimension of Nar-Sie!"), "You hear a pop.")

/obj/rune/tome
	cultname = "summon tome"

/obj/rune/tome/cast(mob/living/user)
	new /obj/item/book/tome(get_turf(src))
	speak_incantation(user, "N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
	visible_message(SPAN_NOTICE("\The [src] disappears with a flash of red light, and in its place now a book lies."), "You hear a pop.")
	qdel(src)

/obj/rune/wall
	cultname = "wall"

	var/obj/cultwall/wall = null

/obj/rune/wall/Destroy()
	QDEL_NULL(wall)
	return ..()

/obj/rune/wall/cast(mob/living/user)
	var/t
	if(wall)
		if(!wall.health_damaged())
			to_chat(user, SPAN_NOTICE("The wall doesn't need mending."))
			return
		t = wall.get_damage_value()
		wall.restore_health()
	else
		wall = new /obj/cultwall(get_turf(src), bcolor)
		wall.rune = src
		t = wall.get_current_health()
	user.remove_blood_simple(t / 50)
	speak_incantation(user, "Khari[pick("'","`")]d! Eske'te tannin!")
	to_chat(user, SPAN_WARNING("Your blood flows into the rune, and you feel that the very space over the rune thickens."))

/obj/cultwall
	name = "red mist"
	desc = "A strange red mist emanating from a rune below it."
	icon = 'icons/effects/effects.dmi'//TODO: better icon
	icon_state = "smoke"
	color = "#ff0000"
	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	var/obj/rune/wall/rune
	health_max = 200

/obj/cultwall/New(loc, bcolor)
	..()
	if(bcolor)
		color = bcolor

/obj/cultwall/Destroy()
	if(rune)
		rune.wall = null
		rune = null
	return ..()

/obj/cultwall/examine_damage_state(mob/user)
	if (!iscultist(user))
		return
	..()

/obj/cultwall/attack_hand(mob/living/user)
	if(iscultist(user))
		user.visible_message(SPAN_NOTICE("\The [user] touches \the [src], and it fades."), SPAN_NOTICE("You touch \the [src], whispering the old ritual, making it disappear."))
		qdel(src)
	else
		to_chat(user, SPAN_NOTICE("You touch \the [src]. It feels wet and becomes harder the further you push your arm."))


/obj/cultwall/use_tool(obj/item/tool, mob/user, list/click_params)
	// Null rod - Remove wall
	if (istype(tool, /obj/item/nullrod))
		user.visible_message(
			SPAN_NOTICE("\The [user] touches \the [src] with \a [tool], and it disappears."),
			SPAN_NOTICE("You disrupt \the [src]'s vile magic with the deadening field of \the [tool].")
		)
		qdel(src)
		return TRUE

	return ..()


/obj/cultwall/on_death()
	visible_message(SPAN_WARNING("\The [src] dissipates."))
	qdel (src)

/obj/rune/ajorney
	cultname = "astral journey"

/obj/rune/ajorney/cast(mob/living/user)
	var/tmpkey = user.key
	var/datum/pronouns/pronouns = user.choose_from_pronouns()
	if(user.loc != get_turf(src))
		return
	speak_incantation(user, "Fwe[pick("'","`")]sh mah erl nyag r'ya!")
	user.visible_message(SPAN_WARNING("\The [user]'s eyes glow blue as [pronouns.he] freezes in place, absolutely motionless."), SPAN_WARNING("The shadow that is your spirit separates itself from your body. You are now in the realm beyond. While this is a great sight, being here strains your mind and body. Hurry..."), "You hear only complete silence for a moment.")
	announce_ghost_joinleave(user.ghostize(1), 1, "You feel that they had to use some [pick("dark", "black", "blood", "forgotten", "forbidden")] magic to [pick("invade", "disturb", "disrupt", "infest", "taint", "spoil", "blight")] this place!")
	var/mob/observer/ghost/soul
	for(var/mob/observer/ghost/O in GLOB.ghost_mobs)
		if(O.key == tmpkey)
			soul = O
			break
	while(user)
		if(user.stat == DEAD)
			return
		if(user.key)
			return
		else if(user.loc != get_turf(src) && soul)
			soul.reenter_corpse()
		else
			user.take_organ_damage(0, 1)
		sleep(20)
	fizzle(user)

/obj/rune/defile
	cultname = "defile"

/obj/rune/defile/cast(mob/living/user)
	speak_incantation(user, "Ia! Ia! Zasan therium viortia!")
	for(var/turf/T in range(1, src))
		if(T.holy)
			T.holy = 0
		else
			T.cultify()
	visible_message(SPAN_WARNING("\The [src] embeds into the floor and walls around it, changing them!"), "You hear liquid flow.")
	qdel(src)

/obj/rune/obscure
	cultname = "obscure"

/obj/rune/obscure/cast(mob/living/user)
	var/runecheck = 0
	for(var/obj/rune/R in orange(1, src))
		if(R != src)
			R.set_invisibility(INVISIBILITY_OBSERVER)
		runecheck = 1
	if(runecheck)
		speak_incantation(user, "Kla[pick("'","`")]atu barada nikt'o!")
		visible_message(SPAN_WARNING("\ The rune turns into gray dust that conceals the surrounding runes."))
		qdel(src)

/obj/rune/reveal
	cultname = "reveal"

/obj/rune/reveal/cast(mob/living/user)
	var/irunecheck = 0
	for(var/obj/rune/R in orange(1, src))
		if(R != src)
			R.set_invisibility(SEE_INVISIBLE_NOLIGHTING)
		irunecheck = 1
	if(irunecheck)
		speak_incantation(user, "Nikt[pick("'","`")]o barada kla'atu!")
		visible_message(SPAN_WARNING("\ The rune turns into red dust that reveals the surrounding runes."))
		qdel(src)

/* Tier 2 runes */


/obj/rune/armor
	cultname = "summon robes"
	strokes = 3

/obj/rune/armor/cast(mob/living/user)
	speak_incantation(user, "N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	visible_message(SPAN_WARNING("\The [src] disappears with a flash of red light, and a set of armor appears on \the [user]."), SPAN_WARNING("You are blinded by the flash of red light. After you're able to see again, you see that you are now wearing a set of armor."))

	var/obj/O = user.get_equipped_item(slot_head) // This will most likely kill you if you are wearing a spacesuit, and it's 100% intended
	if(O && !istype(O, /obj/item/clothing/head/culthood) && user.unEquip(O))
		user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), slot_head)
	O = user.get_equipped_item(slot_wear_suit)
	if(O && !istype(O, /obj/item/clothing/suit/cultrobes) && user.unEquip(O))
		user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit)
	O = user.get_equipped_item(slot_shoes)
	if(O && !istype(O, /obj/item/clothing/shoes/cult) && user.unEquip(O))
		user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), slot_shoes)

	O = user.get_equipped_item(slot_back)
	if(istype(O, /obj/item/storage) && !istype(O, /obj/item/storage/backpack/cultpack) && user.unEquip(O)) // We don't want to make the vox drop their nitrogen tank, though
		var/obj/item/storage/backpack/cultpack/C = new /obj/item/storage/backpack/cultpack(user)
		user.equip_to_slot_or_del(C, slot_back)
		if(C)
			for(var/obj/item/I in O)
				I.forceMove(C)
	else if(!O)
		var/obj/item/storage/backpack/cultpack/C = new /obj/item/storage/backpack/cultpack(user)
		user.equip_to_slot_or_del(C, slot_back)

	user.update_icons()

	qdel(src)

/obj/rune/offering
	cultname = "offering"
	strokes = 3
	var/mob/living/victim

/obj/rune/offering/cast(mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(victim)
		to_chat(user, SPAN_WARNING("You are already sarcificing \the [victim] on this rune."))
		return
	if(length(cultists) < 3)
		to_chat(user, SPAN_WARNING("You need three cultists around this rune to make it work."))
		return fizzle(user)
	var/turf/T = get_turf(src)
	for(var/mob/living/M in T)
		if(M.stat != DEAD && !iscultist(M))
			victim = M
			break
	if(!victim)
		return fizzle(user)

	for(var/mob/living/M in cultists)
		M.say("Barhah hra zar[pick("'","`")]garis!")

	while(victim && victim.loc == T && victim.stat != DEAD)
		var/list/mob/living/casters = get_cultists()
		if(length(casters) < 3)
			break
		//T.turf_animation('icons/effects/effects.dmi', "rune_sac")
		victim.fire_stacks = max(2, victim.fire_stacks)
		victim.IgniteMob()
		victim.take_organ_damage(2 + length(casters), 2 + length(casters)) // This is to speed up the process and also damage mobs that don't take damage from being on fire, e.g. borgs
		if(ishuman(victim))
			var/mob/living/carbon/human/H = victim
			if(H.is_asystole())
				H.adjustBrainLoss(2 + length(casters))
		sleep(40)
	if(victim && victim.loc == T && victim.stat == DEAD)
		GLOB.cult.add_cultiness(CULTINESS_PER_SACRIFICE)
		var/obj/item/device/soulstone/full/F = new(get_turf(src))
		for(var/mob/M in cultists | get_cultists())
			to_chat(M, SPAN_WARNING("The Geometer of Blood accepts this offering."))
		visible_message(SPAN_NOTICE("\The [F] appears over \the [src]."))
		GLOB.cult.sacrificed += victim.mind
		if(victim.mind == GLOB.cult.sacrifice_target)
			for(var/datum/mind/H in GLOB.cult.current_antagonists)
				if(H.current)
					to_chat(H.current, SPAN_OCCULT("Your objective is now complete."))
		//TODO: other rewards?
		/* old sac code - left there in case someone wants to salvage it
		var/worth = 0
		if(istype(H,/mob/living/carbon/human))
			var/mob/living/carbon/human/lamb = H
			if(lamb.species.rarity_value > 3)
				worth = 1

		if(H.mind == cult.sacrifice_target)

		to_chat(usr, SPAN_WARNING("The Geometer of Blood accepts this sacrifice, your objective is now complete."))

		to_chat(usr, SPAN_WARNING("The Geometer of Blood accepts this [worth ? "exotic " : ""]sacrifice."))

		to_chat(usr, SPAN_WARNING("The Geometer of blood accepts this sacrifice."))
		to_chat(usr, SPAN_WARNING("However, this soul was not enough to gain His favor."))

		to_chat(usr, SPAN_WARNING("The Geometer of blood accepts this sacrifice."))
		to_chat(usr, SPAN_WARNING("However, a mere dead body is not enough to satisfy Him."))
		*/
		to_chat(victim, SPAN_OCCULT("The Geometer of Blood claims your body."))
		victim.dust()
	if(victim)
		victim.ExtinguishMob() // Technically allows them to put the fire out by sacrificing them and stopping immediately, but I don't think it'd have much effect
		victim = null


/obj/rune/drain
	cultname = "blood drain"
	strokes = 3

/obj/rune/drain/cast(mob/living/user)
	var/mob/living/carbon/human/victim
	for(var/mob/living/carbon/human/M in get_turf(src))
		if(iscultist(M))
			continue
		victim = M
	if(!victim)
		return fizzle(user)
	if(!victim.vessel.has_reagent(/datum/reagent/blood, 20))
		to_chat(user, SPAN_WARNING("This body has no blood in it."))
		return fizzle(user)
	victim.vessel.remove_reagent(/datum/reagent/blood, 20)
	admin_attack_log(user, victim, "Used a blood drain rune.", "Was victim of a blood drain rune.", "used a blood drain rune on")
	speak_incantation(user, "Yu[pick("'","`")]gular faras desdae. Havas mithum javara. Umathar uf'kal thenar!")
	user.visible_message(
		SPAN_WARNING("Blood flows from \the [src] into \the [user]!"),
		SPAN_OCCULT("The blood starts flowing from \the [src] into your frail mortal body. [capitalize(english_list(heal_user(user), nothing_text = "you feel no different"))]."),
		"You hear liquid flow."
	)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/rune/drain/proc/heal_user(mob/living/carbon/human/user)
	if(!istype(user))
		return list("you feel no different")
	var/list/statuses = list()
	var/charges = 20
	var/use
	use = min(charges, user.species.blood_volume - user.vessel.total_volume)
	if(use > 0)
		user.vessel.add_reagent(/datum/reagent/blood, use)
		charges -= use
		statuses += "you regain lost blood"
		if(!charges)
			return statuses
	if(user.getBruteLoss() || user.getFireLoss())
		var/healbrute = user.getBruteLoss()
		var/healburn = user.getFireLoss()
		if(healbrute < healburn)
			healbrute = min(healbrute, charges / 2)
			charges -= healbrute
			healburn = min(healburn, charges)
			charges -= healburn
		else
			healburn = min(healburn, charges / 2)
			charges -= healburn
			healbrute = min(healbrute, charges)
			charges -= healbrute
		user.heal_organ_damage(healbrute, healburn, 1)
		statuses += "your wounds mend"
		if(!charges)
			return statuses
	if(user.getToxLoss())
		use = min(user.getToxLoss(), charges)
		user.adjustToxLoss(-use)
		charges -= use
		statuses += "your body stings less"
		if(!charges)
			return statuses
	if(charges >= 15)
		for(var/obj/item/organ/external/e in user.organs)
			if(e && e.status & ORGAN_BROKEN)
				e.status &= ~ORGAN_BROKEN
				statuses += "bones in your [e.name] snap into place"
				charges -= 15
				if(charges < 15)
					break
	if(!charges)
		return statuses
	var/list/obj/item/organ/damaged = list()
	for(var/obj/item/organ/I in user.internal_organs)
		if(I.damage)
			damaged += I
	if(length(damaged))
		statuses += "you feel pain inside for a moment that passes quickly"
		while(charges && length(damaged))
			var/obj/item/organ/fix = pick(damaged)
			fix.damage = max(0, fix.damage - min(charges, 1))
			charges = max(charges - 1, 0)
			if(fix.damage == 0)
				damaged -= fix
	/* this is going to need rebalancing
	if(charges)
		user.ingested.add_reagent(/datum/reagent/hell_water, charges)
		statuses += "you feel empowered"
	*/
	return statuses

/datum/reagent/hell_water
	name = "Hell water"
	reagent_state = LIQUID
	color = "#0050a1"
	metabolism = REM * 0.1

/datum/reagent/hell_water/affect_ingest(mob/living/carbon/M, removed)
	if(iscultist(M))
		M.AdjustParalysis(-1)
		M.AdjustStunned(-1)
		M.AdjustWeakened(-1)
		M.add_chemical_effect(CE_PAINKILLER, 40)
		M.add_chemical_effect(CE_SPEEDBOOST, 1)
		M.adjustOxyLoss(-10 * removed)
		M.heal_organ_damage(5 * removed, 5 * removed, 1)
		M.adjustToxLoss(-5 * removed)
	else
		M.fire_stacks = max(2, M.fire_stacks)
		M.IgniteMob()

/obj/rune/emp
	cultname = "emp"
	strokes = 4

/obj/rune/emp/cast(mob/living/user)
	empulse(get_turf(src), 4, 2, 1)
	speak_incantation(user, "Ta'gh fara[pick("'","`")]qha fel d'amar det!")
	qdel(src)

/obj/rune/massdefile //Defile but with a huge range. Bring a buddy for this, you're hitting the floor.
	cultname = "mass defile"

/obj/rune/massdefile/cast(mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(length(cultists) < 3)
		to_chat(user, SPAN_WARNING("You need three cultists around this rune to make it work."))
		return fizzle(user)
	else
		for(var/mob/living/M in cultists)
			M.say("Ia! Ia! Zasan therium viortia! Razan gilamrua kioha!")
		for(var/turf/T in range(5, src))
			if(T.holy)
				T.holy = 0
			else
				T.cultify()
	visible_message(SPAN_WARNING("\The [src] embeds into the floor and walls around it, changing them!"), "You hear liquid flow.")
	qdel(src)

/* Tier 3 runes */

/obj/rune/weapon
	cultname = "summon weapon"
	strokes = 4

/obj/rune/weapon/cast(mob/living/user)
	if(!istype(user.get_equipped_item(slot_head), /obj/item/clothing/head/culthood) || !istype(user.get_equipped_item(slot_wear_suit), /obj/item/clothing/suit/cultrobes) || !istype(user.get_equipped_item(slot_shoes), /obj/item/clothing/shoes/cult))
		to_chat(user, SPAN_WARNING("You need to be wearing your robes to use this rune."))
		return fizzle(user)
	var/turf/T = get_turf(src)
	if(T.icon_state != "cult" && T.icon_state != "cult-narsie")
		to_chat(user, SPAN_WARNING("This rune needs to be placed on the defiled ground."))
		return fizzle(user)
	speak_incantation(user, "N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	user.put_in_hands(new /obj/item/melee/cultblade(user))
	qdel(src)

/obj/rune/shell
	cultname = "summon shell"
	strokes = 4

/obj/rune/shell/cast(mob/living/user)
	var/turf/T = get_turf(src)
	if(T.icon_state != "cult" && T.icon_state != "cult-narsie")
		to_chat(user, SPAN_WARNING("This rune needs to be placed on the defiled ground."))
		return fizzle(user)

	var/obj/item/stack/material/steel/target
	for(var/obj/item/stack/material/steel/S in get_turf(src))
		if(S.get_amount() >= 10)
			target = S
			break

	if(!target)
		to_chat(user, SPAN_WARNING("You need ten sheets of metal to fold them into a construct shell."))
		return fizzle(user)

	speak_incantation(user, "Da A[pick("'","`")]ig Osk!")
	target.use(10)
	var/obj/O = new /obj/structure/constructshell/cult(get_turf(src))
	visible_message(SPAN_WARNING("The metal bends into \the [O], and \the [src] imbues into it."), "You hear a metallic sound.")
	qdel(src)

/obj/rune/confuse
	cultname = "confuse"
	strokes = 4

/obj/rune/confuse/cast(mob/living/user)
	speak_incantation(user, "Fuu ma[pick("'","`")]jin!")
	visible_message(SPAN_DANGER("\The [src] explodes in a bright flash."))
	var/list/mob/affected = list()
	for(var/mob/living/M in viewers(src))
		if(iscultist(M))
			continue
		var/obj/item/nullrod/N = locate() in M
		if(N)
			continue
		affected |= M
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			C.eye_blurry += 50
			C.Weaken(3)
			C.Stun(5)
		else if(issilicon(M))
			M.Weaken(10)

	admin_attacker_log_many_victims(user, affected, "Used a confuse rune.", "Was victim of a confuse rune.", "used a confuse rune on")
	qdel(src)

/obj/rune/revive
	cultname = "revive"
	strokes = 4

/obj/rune/revive/cast(mob/living/user)
	var/mob/living/carbon/human/target
	var/obj/item/device/soulstone/source
	var/datum/pronouns/pronouns = user.choose_from_pronouns()
	for(var/mob/living/carbon/human/M in get_turf(src))
		if(M.stat == DEAD)
			if(iscultist(M))
				if(M.key)
					target = M
					break
	if(!target)
		return fizzle(user)
	for(var/obj/item/device/soulstone/S in get_turf(src))
		if(S.full && !S.shade.key)
			source = S
			break
	if(!source)
		return fizzle(user)
	target.rejuvenate()
	source.set_full(0)
	speak_incantation(user, "Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!")
	target.visible_message(SPAN_WARNING("\The [target]'s eyes glow with a faint red as [pronouns.he] stands up, slowly starting to breathe again."), SPAN_WARNING("Life... I'm alive again..."), "You hear liquid flow.")

/obj/rune/blood_boil
	cultname = "blood boil"
	strokes = 4

/obj/rune/blood_boil/cast(mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(length(cultists) < 3)
		return fizzle()

	for(var/mob/living/M in cultists)
		M.say("Dedo ol[pick("'","`")]btoh!")

	var/list/mob/living/previous = list()
	var/list/mob/living/current = list()
	while(length(cultists) >= 3)
		cultists = get_cultists()
		for(var/mob/living/carbon/M in viewers(src))
			if(iscultist(M))
				continue
			current |= M
			var/obj/item/nullrod/N = locate() in M
			if(N)
				continue
			M.take_overall_damage(5, 5)
			if(!(M in previous))
				if(M.should_have_organ(BP_HEART))
					to_chat(M, SPAN_DANGER("Your blood boils!"))
				else
					to_chat(M, SPAN_DANGER("You feel searing heat inside!"))
		previous = current.Copy()
		current.Cut()
		sleep(10)

/* Tier NarNar runes */

/obj/rune/tearreality
	cultname = "tear reality"
	var/the_end_comes = 0
	var/the_time_has_come = 300
	var/obj/singularity/narsie/large/HECOMES = null
	strokes = 9

/obj/rune/tearreality/cast(mob/living/user)
	if(!GLOB.cult.allow_narsie)
		return
	if (GLOB.cult.station_summon_only && !(get_z(user) in GLOB.using_map.station_levels))
		to_chat(user, SPAN_OCCULT("Nar-Sie cannot be summoned here."))
		return
	if (GLOB.cult.no_shuttle_summon && istype(get_area(user), /area/shuttle))
		to_chat(user, SPAN_OCCULT("Nar-Sie cannot be summoned on a shuttle."))
		return
	if(the_end_comes)
		to_chat(user, SPAN_OCCULT("You are already summoning! Be patient!"))
		return
	var/list/mob/living/cultists = get_cultists()
	if(length(cultists) < 5)
		return fizzle()
	for(var/mob/living/M in cultists)
		M.say("Tok-lyr rqa'nap g[pick("'","`")]lt-ulotf!")
		to_chat(M, SPAN_OCCULT("You are staring to tear the reality to bring Him back... stay around the rune!"))
	log_and_message_admins_many(cultists, "started summoning Nar-sie.")

	var/area/A = get_area(src)
	command_announcement.Announce("High levels of bluespace interference detected at \the [A]. Suspected wormhole forming. Investigate it immediately.")
	while(length(cultists) > 4 || the_end_comes)
		cultists = get_cultists()
		if(length(cultists) > 8)
			++the_end_comes
		if(length(cultists) > 4)
			++the_end_comes
		else
			--the_end_comes
		if(the_end_comes >= the_time_has_come)
			break
		for(var/mob/living/M in cultists)
			if(prob(5))
				M.say(pick("Hakkrutju gopoenjim.", "Nherasai pivroiashan.", "Firjji prhiv mazenhor.", "Tanah eh wakantahe.", "Obliyae na oraie.", "Miyf hon vnor'c.", "Wakabai hij fen juswix."))

		for(var/turf/T in range(min(the_end_comes, 15)))
			if(prob(the_end_comes / 3))
				T.cultify()
		sleep(10)

	if(the_end_comes >= the_time_has_come)
		HECOMES = new /obj/singularity/narsie/large(get_turf(src))
	else
		command_announcement.Announce("Bluespace anomaly has ceased.")
		qdel(src)

/obj/rune/tearreality/attack_hand(mob/living/user)
	..()
	if(HECOMES && !iscultist(user))
		var/input = input(user, "Are you SURE you want to sacrifice yourself?", "DO NOT DO THIS") in list("Yes", "No")
		if(input != "Yes")
			return
		speak_incantation(user, "Uhrast ka'hfa heldsagen ver[pick("'","`")]lot!")
		to_chat(user, SPAN_WARNING("In the last moment of your humble life, you feel an immense pain as fabric of reality mends... with your blood."))
		for(var/mob/M in GLOB.alive_mobs)
			if (!iscultist(M))
				to_chat(M, SPAN_OCCULT("You see a vision of \the [user] keeling over dead, their blood glowing blue as it escapes their body and dissipates into thin air; you hear an otherwordly scream and feel that a great disaster has just been averted."))
			else
				to_chat(M, SPAN_OCCULT("You see a vision of [name] keeling over dead, their blood glowing blue as it escapes their body and dissipates into thin air; you hear an otherwordly scream and feel very weak for a moment."))
		log_and_message_admins("mended reality with the greatest sacrifice", user)
		user.dust()
		GLOB.cult.powerless = 1
		qdel(HECOMES)
		qdel(src)

		if (GLOB.universe.type == /datum/universal_state/hell)
			SetUniversalState(/datum/universal_state)


/obj/rune/tearreality/can_use_item(obj/item/tool, mob/user, click_params)
	if (the_end_comes)
		USE_FEEDBACK_FAILURE("It's far too late to try doing anything with \the [src].")
		return FALSE
	return ..()


/* Imbue runes */

/obj/rune/imbue
	cultname = "otherwordly abomination that shouldn't exist and that you should report to your local god as soon as you see it, along with the instructions for making this"
	var/papertype

/obj/rune/imbue/cast(mob/living/user)
	var/obj/item/paper/target
	var/tainted = 0
	for(var/obj/item/paper/P in get_turf(src))
		if(!P.info)
			target = P
			break
		else
			tainted = 1
	if(!target)
		if(tainted)
			to_chat(user, SPAN_WARNING("The blank is tainted. It is unsuitable."))
		return fizzle(user)
	speak_incantation(user, "H'drak v[pick("'","`")]loso, mir'kanas verbot!")
	visible_message(SPAN_WARNING("The rune forms into an arcane image on the paper."))
	new papertype(get_turf(src))
	qdel(target)
	qdel(src)

/obj/rune/imbue/stun
	cultname = "stun imbue"
	papertype = /obj/item/paper/talisman/stun

/obj/rune/imbue/emp
	cultname = "destroy technology imbue"
	papertype = /obj/item/paper/talisman/emp
