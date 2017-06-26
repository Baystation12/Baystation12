/obj/effect/rune
	name = "rune"
	desc = "A strange collection of symbols drawn in blood."
	anchored = 1
	icon = 'icons/effects/uristrunes.dmi'
	icon_state = "blank"
	unacidable = 1
	plane = ABOVE_TURF_PLANE
	layer = RUNE_LAYER

	var/blood
	var/bcolor
	var/strokes = 2 // IF YOU EVER SET THIS TO MORE THAN TEN, EVERYTHING WILL BREAK
	var/cultname = ""

/obj/effect/rune/New(var/loc, var/blcolor = "#c80000", var/nblood = "blood")
	..()
	bcolor = blcolor
	blood = nblood
	update_icon()

/obj/effect/rune/update_icon()
	overlays.Cut()
	if(cult.rune_strokes[type])
		var/list/f = cult.rune_strokes[type]
		for(var/i in f)
			var/image/t = image('icons/effects/uristrunes.dmi', "rune-[i]")
			overlays += t
	else
		var/list/q = list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
		var/list/f = list()
		for(var/i = 1 to strokes)
			var/j = pick(q)
			f += j
			q -= f
			var/image/t = image('icons/effects/uristrunes.dmi', "rune-[j]")
			overlays += t
		cult.rune_strokes[type] = f.Copy()
	color = bcolor
	desc = "A strange collection of symbols drawn in [blood]."

/obj/effect/rune/examine(var/mob/user)
	. = ..()
	if(iscultist(user))
		to_chat(user, "This is \a [cultname] rune.")

/obj/effect/rune/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/book/tome) && iscultist(user))
		user.visible_message("<span class='notice'>[user] rubs \the [src] with \the [I], and \the [src] is absorbed by it.</span>", "You retrace your steps, carefully undoing the lines of \the [src].")
		qdel(src)
		return
	else if(istype(I, /obj/item/weapon/nullrod))
		user.visible_message("<span class='notice'>[user] hits \the [src] with \the [I], and it disappears, fizzling.</span>", "<span class='notice'>You disrupt the vile magic with the deadening field of \the [I].</span>", "You hear a fizzle.")
		qdel(src)
		return

/obj/effect/rune/attack_hand(var/mob/living/user)
	if(!iscultist(user))
		to_chat(user, "You can't mouth the arcane scratchings without fumbling over them.")
		return
	if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle) || user.silent)
		to_chat(user, "You are unable to speak the words of the rune.")
		return
	if(cult.powerless)
		to_chat(user, "You read the words, but nothing happens.")
		return fizzle(user)
	cast(user)

/obj/effect/rune/attack_ai(var/mob/living/user) // Cult borgs!
	if(Adjacent(user))
		attack_hand(user)

/obj/effect/rune/attack_generic(var/mob/living/user) // Cult constructs/slimes/whatnot!
	attack_hand(user)

/obj/effect/rune/proc/cast(var/mob/living/user)
	fizzle(user)

/obj/effect/rune/proc/get_cultists()
	. = list()
	for(var/mob/living/M in range(1))
		if(iscultist(M))
			. += M

/obj/effect/rune/proc/fizzle(var/mob/living/user)
	visible_message("<span class='warning'>The markings pulse with a small burst of light, then fall dark.</span>", "You hear a fizzle.")

//Makes the speech a proc so all verbal components can be easily manipulated as a whole, or individually easily
/obj/effect/rune/proc/speak_incantation(var/mob/living/user, var/incantation)
	var/datum/language/L = all_languages[LANGUAGE_CULT]
	if(incantation && (L in user.languages))
		user.say(incantation, L)

/* Tier 1 runes below */

/obj/effect/rune/convert
	cultname = "convert"
	var/spamcheck = 0

/obj/effect/rune/convert/cast(var/mob/living/user)
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
	target.visible_message("<span class='warning'>The markings below [target] glow a bloody red.</span>")

	to_chat(target, "<span class='cult'>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</span>")
	if(!cult.can_become_antag(target.mind, 1))
		to_chat(target, "<span class='danger'>Are you going insane?</span>")
	else
		to_chat(target, "<span class='cult'>Do you want to join the cult of Nar'Sie? You can choose to ignore offer... <a href='?src=\ref[src];join=1'>Join the cult</a>.</span>")

	spamcheck = 1
	spawn(40)
		spamcheck = 0
		if(!iscultist(target) && target.loc == get_turf(src)) // They hesitated, resisted, or can't join, and they are still on the rune - burn them
			if(target.stat == CONSCIOUS)
				target.take_overall_damage(0, 10)
				switch(target.getFireLoss())
					if(0 to 25)
						to_chat(target, "<span class='danger'>Your blood boils as you force yourself to resist the corruption invading every corner of your mind.</span>")
					if(25 to 45)
						to_chat(target, "<span class='danger'>Your blood boils and your body burns as the corruption further forces itself into your body and mind.</span>")
						target.take_overall_damage(0, 3)
					if(45 to 75)
						to_chat(target, "<span class='danger'>You begin to hallucinate images of a dark and incomprehensible being and your entire body feels like its engulfed in flame as your mental defenses crumble.</span>")
						target.take_overall_damage(0, 5)
					if(75 to 100)
						to_chat(target, "<span class='cult'>Your mind turns to ash as the burning flames engulf your very soul and images of an unspeakable horror begin to bombard the last remnants of mental resistance.</span>")
						target.take_overall_damage(0, 10)

/obj/effect/rune/convert/Topic(href, href_list)
	if(href_list["join"])
		if(usr.loc == loc && !iscultist(usr))
			cult.add_antagonist(usr.mind, ignore_role = 1, do_not_equip = 1)

/obj/effect/rune/teleport
	cultname = "teleport"
	var/destination

/obj/effect/rune/teleport/New()
	..()
	var/area/A = get_area(src)
	destination = A.name
	cult.teleport_runes += src

/obj/effect/rune/teleport/Destroy()
	cult.teleport_runes -= src
	var/turf/T = get_turf(src)
	for(var/atom/movable/A in contents)
		A.forceMove(T)
	return ..()

/obj/effect/rune/teleport/examine(var/mob/user)
	. = ..()
	if(iscultist(user))
		to_chat(user, "Its name is [destination].")

/obj/effect/rune/teleport/cast(var/mob/living/user)
	if(user.loc == src)
		showOptions(user)
	else if(user.loc == get_turf(src))
		speak_incantation(user, "Sas[pick("'","`")]so c'arta forbici!")
		if(do_after(user, 30))
			user.visible_message("<span class='warning'>\The [user] disappears in a flash of red light!</span>", "<span class='warning'>You feel as your body gets dragged into the dimension of Nar-Sie!</span>", "You hear a sickening crunch.")
			user.forceMove(src)
			showOptions(user)
			var/warning = 0
			while(user.loc == src)
				user.take_organ_damage(0, 2)
				if(user.getFireLoss() > 50)
					to_chat(user, "<span class='danger'>Your body can't handle the heat anymore!</span>")
					leaveRune(user)
					return
				if(warning == 0)
					to_chat(user, "<span class='warning'>You feel the immerse heat of the realm of Nar-Sie...</span>")
					++warning
				if(warning == 1 && user.getFireLoss() > 15)
					to_chat(user, "<span class='warning'>Your burns are getting worse. You should return to your realm soon...</span>")
					++warning
				if(warning == 2 && user.getFireLoss() > 35)
					to_chat(user, "<span class='warning'>The heat! It burns!</span>")
					++warning
				sleep(10)
	else
		var/input = input(user, "Choose a new rune name.", "Destination", "") as text|null
		if(!input)
			return
		destination = sanitize(input)

/obj/effect/rune/teleport/Topic(href, href_list)
	if(usr.loc != src)
		return
	if(href_list["target"])
		var/obj/effect/rune/teleport/targ = locate(href_list["target"])
		if(istype(targ)) // Checks for null, too
			usr.forceMove(targ)
			targ.showOptions(usr)
	else if(href_list["leave"])
		leaveRune(usr)

/obj/effect/rune/teleport/proc/showOptions(var/mob/living/user)
	var/list/t = list()
	for(var/obj/effect/rune/teleport/T in cult.teleport_runes)
		if(T == src)
			continue
		t += "<a href='?src=\ref[src];target=\ref[T]'>[T.destination]</a>"
	to_chat(user, "Teleport runes: [english_list(t, nothing_text = "no other runes exist")]... or <a href='?src=\ref[src];leave=1'>return from this rune</a>.")

/obj/effect/rune/teleport/proc/leaveRune(var/mob/living/user)
	if(user.loc != src)
		return
	user.forceMove(get_turf(src))
	user.visible_message("<span class='warning'>\The [user] appears in a flash of red light!</span>", "<span class='warning'>You feel as your body gets thrown out of the dimension of Nar-Sie!</span>", "You hear a pop.")

/obj/effect/rune/tome
	cultname = "summon tome"

/obj/effect/rune/tome/cast(var/mob/living/user)
	new /obj/item/weapon/book/tome(get_turf(src))
	speak_incantation(user, "N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
	visible_message("<span class='notice'>\The [src] disappears with a flash of red light, and in its place now a book lies.</span>", "You hear a pop.")
	qdel(src)

/obj/effect/rune/wall
	cultname = "wall"

	var/obj/effect/cultwall/wall = null

/obj/effect/rune/wall/Destroy()
	qdel_null(wall)
	return ..()

/obj/effect/rune/wall/cast(var/mob/living/user)
	var/t
	if(wall)
		if(wall.health >= wall.max_health)
			to_chat(user, "<span class='notice'>The wall doesn't need mending.</span>")
			return
		t = wall.max_health - wall.health
		wall.health += t
	else
		wall = new /obj/effect/cultwall(get_turf(src), bcolor)
		wall.rune = src
		t = wall.health
	user.pay_for_rune(t / 50)
	speak_incantation(user, "Khari[pick("'","`")]d! Eske'te tannin!")
	to_chat(user, "<span class='warning'>Your blood flows into the rune, and you feel that the very space over the rune thickens.</span>")

/obj/effect/cultwall
	name = "red mist"
	desc = "A strange red mist emanating from a rune below it."
	icon = 'icons/effects/effects.dmi'//TODO: better icon
	icon_state = "smoke"
	color = "#ff0000"
	anchored = 1
	density = 1
	unacidable = 1
	var/obj/effect/rune/wall/rune
	var/health
	var/max_health = 200

/obj/effect/cultwall/New(var/loc, var/bcolor)
	..()
	health = max_health
	if(bcolor)
		color = bcolor

/obj/effect/cultwall/Destroy()
	if(rune)
		rune.wall = null
		rune = null
	return ..()

/obj/effect/cultwall/examine(var/mob/user)
	. = ..()
	if(iscultist(user))
		if(health == max_health)
			to_chat(user, "<span class='notice'>It is fully intact.</span>")
		else if(health > max_health * 0.5)
			to_chat(user, "<span class='warning'>It is damaged.</span>")
		else
			to_chat(user, "<span class='danger'>It is about to dissipate.</span>")

/obj/effect/cultwall/attack_hand(var/mob/living/user)
	if(iscultist(user))
		user.visible_message("<span class='notice'>\The [user] touches \the [src], and it fades.</span>", "<span class='notice'>You touch \the [src], whispering the old ritual, making it disappear.</span>")
		qdel(src)
	else
		to_chat(user, "<span class='notice'>You touch \the [src]. It feels wet and becomes harder the further you push your arm.</span>")

/obj/effect/cultwall/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/nullrod))
		user.visible_message("<span class='notice'>\The [user] touches \the [src] with \the [I], and it disappears.</span>", "<span class='notice'>You disrupt the vile magic with the deadening field of \the [I].</span>")
		qdel(src)
	else if(I.force)
		user.visible_message("<span class='notice'>\The [user] hits \the [src] with \the [I].</span>", "<span class='notice'>You hit \the [src] with \the [I].</span>")
		take_damage(I.force)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)

/obj/effect/cultwall/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return
	take_damage(Proj.damage)
	..()

/obj/effect/cultwall/proc/take_damage(var/amount)
	health -= amount
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] dissipates.</span>")
		qdel(src)

/obj/effect/rune/ajorney
	cultname = "astral journey"

/obj/effect/rune/ajorney/cast(var/mob/living/user)
	var/tmpkey = user.key
	if(user.loc != get_turf(src))
		return
	speak_incantation(user, "Fwe[pick("'","`")]sh mah erl nyag r'ya!")
	user.visible_message("<span class='warning'>\The [user]'s eyes glow blue as \he freezes in place, absolutely motionless.</span>", "<span class='warning'>The shadow that is your spirit separates itself from your body. You are now in the realm beyond. While this is a great sight, being here strains your mind and body. Hurry...</span>", "You hear only complete silence for a moment.")
	announce_ghost_joinleave(user.ghostize(1), 1, "You feel that they had to use some [pick("dark", "black", "blood", "forgotten", "forbidden")] magic to [pick("invade", "disturb", "disrupt", "infest", "taint", "spoil", "blight")] this place!")
	var/mob/observer/ghost/soul
	for(var/mob/observer/ghost/O in dead_mob_list_)
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

/obj/effect/rune/defile
	cultname = "defile"

/obj/effect/rune/defile/cast(var/mob/living/user)
	speak_incantation(user, "Ia! Ia! Zasan therium viortia!")
	for(var/turf/T in range(1, src))
		if(T.holy)
			T.holy = 0
		else
			T.cultify()
	visible_message("<span class='warning'>\The [src] embeds into the floor and walls around it, changing them!</span>", "You hear liquid flow.")
	qdel(src)

/* Tier 2 runes */


/obj/effect/rune/armor
	cultname = "summon robes"
	strokes = 3

/obj/effect/rune/armor/cast(var/mob/living/user)
	speak_incantation(user, "N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	visible_message("<span class='warning'>\The [src] disappears with a flash of red light, and a set of armor appears on \the [user].</span>", "<span class='warning'>You are blinded by the flash of red light. After you're able to see again, you see that you are now wearing a set of armor.</span>")

	var/obj/O = user.get_equipped_item(slot_head) // This will most likely kill you if you are wearing a spacesuit, and it's 100% intended
	if(O && !istype(O, /obj/item/clothing/head/culthood))
		user.unEquip(O)
	O = user.get_equipped_item(slot_wear_suit)
	if(O && !istype(O, /obj/item/clothing/suit/cultrobes))
		user.unEquip(O)
	O = user.get_equipped_item(slot_shoes)
	if(O && !istype(O, /obj/item/clothing/shoes/cult))
		user.unEquip(O)

	user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), slot_head)
	user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit)
	user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), slot_shoes)

	O = user.get_equipped_item(slot_back)
	if(istype(O, /obj/item/weapon/storage) && !istype(O, /obj/item/weapon/storage/backpack/cultpack)) // We don't want to make the vox drop their nitrogen tank, though
		user.unEquip(O)
		var/obj/item/weapon/storage/backpack/cultpack/C = new /obj/item/weapon/storage/backpack/cultpack(user)
		user.equip_to_slot_or_del(C, slot_back)
		if(C)
			for(var/obj/item/I in O)
				I.forceMove(C)
	else if(!O)
		var/obj/item/weapon/storage/backpack/cultpack/C = new /obj/item/weapon/storage/backpack/cultpack(user)
		user.equip_to_slot_or_del(C, slot_back)

	user.update_icons()

	qdel(src)

/obj/effect/rune/offering
	cultname = "offering"
	strokes = 3
	var/mob/living/victim

/obj/effect/rune/offering/cast(var/mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(victim)
		to_chat(user, "<span class='warning'>You are already sarcificing \the [victim] on this rune.</span>")
		return
	if(cultists.len < 3)
		to_chat(user, "<span class='warning'>You need three cultists around this rune to make it work.</span>")
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
		if(casters.len < 3)
			break
		//T.turf_animation('icons/effects/effects.dmi', "rune_sac")
		victim.fire_stacks = max(2, victim.fire_stacks)
		victim.IgniteMob()
		victim.take_organ_damage(2 + casters.len, 2 + casters.len) // This is to speed up the process and also damage mobs that don't take damage from being on fire, e.g. borgs
		sleep(40)
	if(victim && victim.loc == T && victim.stat == DEAD)
		cult.add_cultiness(CULTINESS_PER_SACRIFICE)
		var/obj/item/device/soulstone/full/F = new(get_turf(src))
		for(var/mob/M in cultists | get_cultists())
			to_chat(M, "<span class='warning'>The Geometer of Blood accepts this offering.</span>")
		visible_message("<span class='notice'>\The [F] appears over \the [src].</span>")
		cult.sacrificed += victim.mind
		if(victim.mind == cult.sacrifice_target)
			for(var/datum/mind/H in cult.current_antagonists)
				if(H.current)
					to_chat(H.current, "<span class='cult'>Your objective is now complete.</span>")
		//TODO: other rewards?
		/* old sac code - left there in case someone wants to salvage it
		var/worth = 0
		if(istype(H,/mob/living/carbon/human))
			var/mob/living/carbon/human/lamb = H
			if(lamb.species.rarity_value > 3)
				worth = 1

		if(H.mind == cult.sacrifice_target)

		to_chat(usr, "<span class='warning'>The Geometer of Blood accepts this sacrifice, your objective is now complete.</span>")

		to_chat(usr, "<span class='warning'>The Geometer of Blood accepts this [worth ? "exotic " : ""]sacrifice.</span>")

		to_chat(usr, "<span class='warning'>The Geometer of blood accepts this sacrifice.</span>")
		to_chat(usr, "<span class='warning'>However, this soul was not enough to gain His favor.</span>")

		to_chat(usr, "<span class='warning'>The Geometer of blood accepts this sacrifice.</span>")
		to_chat(usr, "<span class='warning'>However, a mere dead body is not enough to satisfy Him.</span>")
		*/
		to_chat(victim, "<span class='cult'>The Geometer of Blood claims your body.</span>")
		victim.dust()
	if(victim)
		victim.ExtinguishMob() // Technically allows them to put the fire out by sacrificing them and stopping immediately, but I don't think it'd have much effect
		victim = null


/obj/effect/rune/drain
	cultname = "blood drain"
	strokes = 3

/obj/effect/rune/drain/cast(var/mob/living/user)
	var/mob/living/carbon/human/victim
	for(var/mob/living/carbon/human/M in get_turf(src))
		if(iscultist(M))
			continue
		victim = M
	if(!victim)
		return fizzle(user)
	if(!victim.vessel.has_reagent("blood", 20))
		to_chat(user, "<span class='warning'>This body has no blood in it.</span>")
		return fizzle(user)
	victim.vessel.remove_reagent("blood", 20)
	admin_attack_log(user, victim, "Used a blood drain rune.", "Was victim of a blood drain rune.", "used a blood drain rune on")
	speak_incantation(user, "Yu[pick("'","`")]gular faras desdae. Havas mithum javara. Umathar uf'kal thenar!")
	user.visible_message("<span class='warning'>Blood flows from \the [src] into \the [user]!</span>", "<span class='cult'>The blood starts flowing from \the [src] into your frail mortal body. [capitalize(english_list(heal_user(user), nothing_text = "you feel no different"))].</span>", "You hear liquid flow.")
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/effect/rune/drain/proc/heal_user(var/mob/living/carbon/human/user)
	if(!istype(user))
		return list("you feel no different")
	var/list/statuses = list()
	var/charges = 20
	var/use
	use = min(charges, user.species.blood_volume - user.vessel.total_volume)
	if(use > 0)
		user.vessel.add_reagent("blood", use)
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
		user.heal_organ_damage(healbrute, healburn)
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
	if(damaged.len)
		statuses += "you feel pain inside for a moment that passes quickly"
		while(charges && damaged.len)
			var/obj/item/organ/fix = pick(damaged)
			fix.damage = max(0, fix.damage - min(charges, 1))
			charges = max(charges - 1, 0)
			if(fix.damage == 0)
				damaged -= fix
	/* this is going to need rebalancing
	if(charges)
		user.ingested.add_reagent("hell_water", charges)
		statuses += "you feel empowered"
	*/
	return statuses

/datum/reagent/hell_water
	name = "Hell water"
	id = "hell_water"
	reagent_state = LIQUID
	color = "#0050a177"
	metabolism = REM * 0.1

/datum/reagent/hell_water/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(iscultist(M))
		M.AdjustParalysis(-1)
		M.AdjustStunned(-1)
		M.AdjustWeakened(-1)
		M.add_chemical_effect(CE_PAINKILLER, 40)
		M.add_chemical_effect(CE_SPEEDBOOST, 1)
		M.adjustOxyLoss(-10 * removed)
		M.heal_organ_damage(5 * removed, 5 * removed)
		M.adjustToxLoss(-5 * removed)
	else
		M.fire_stacks = max(2, M.fire_stacks)
		M.IgniteMob()

/obj/effect/rune/emp
	cultname = "emp"
	strokes = 4

/obj/effect/rune/emp/cast(var/mob/living/user)
	empulse(get_turf(src), 4, 2, 1)
	speak_incantation(user, "Ta'gh fara[pick("'","`")]qha fel d'amar det!")
	qdel(src)

/obj/effect/rune/massdefile //Defile but with a huge range. Bring a buddy for this, you're hitting the floor.
	cultname = "mass defile"

/obj/effect/rune/massdefile/cast(var/mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(cultists.len < 3)
		to_chat(user, "<span class='warning'>You need three cultists around this rune to make it work.</span>")
		return fizzle(user)
	else
		for(var/mob/living/M in cultists)
			M.say("Ia! Ia! Zasan therium viortia! Razan gilamrua kioha!")
		for(var/turf/T in range(5, src))
			if(T.holy)
				T.holy = 0
			else
				T.cultify()
	visible_message("<span class='warning'>\The [src] embeds into the floor and walls around it, changing them!</span>", "You hear liquid flow.")
	qdel(src)

/* Tier 3 runes */

/obj/effect/rune/weapon
	cultname = "summon weapon"
	strokes = 4

/obj/effect/rune/weapon/cast(var/mob/living/user)
	if(!istype(user.get_equipped_item(slot_head), /obj/item/clothing/head/culthood) || !istype(user.get_equipped_item(slot_wear_suit), /obj/item/clothing/suit/cultrobes) || !istype(user.get_equipped_item(slot_shoes), /obj/item/clothing/shoes/cult))
		to_chat(user, "<span class='warning'>You need to be wearing your robes to use this rune.</span>")
		return fizzle(user)
	var/turf/T = get_turf(src)
	if(T.icon_state != "cult" && T.icon_state != "cult-narsie")
		to_chat(user, "<span class='warning'>This rune needs to be placed on the defiled ground.</span>")
		return fizzle(user)
	speak_incantation(user, "N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	user.put_in_hands(new /obj/item/weapon/melee/cultblade(user))
	qdel(src)

/obj/effect/rune/shell
	cultname = "summon shell"
	strokes = 4

/obj/effect/rune/shell/cast(var/mob/living/user)
	var/turf/T = get_turf(src)
	if(T.icon_state != "cult" && T.icon_state != "cult-narsie")
		to_chat(user, "<span class='warning'>This rune needs to be placed on the defiled ground.</span>")
		return fizzle(user)

	var/obj/item/stack/material/steel/target
	for(var/obj/item/stack/material/steel/S in get_turf(src))
		if(S.get_amount() >= 10)
			target = S
			break

	if(!target)
		to_chat(user, "<span class='warning'>You need ten sheets of metal to fold them into a construct shell.</span>")
		return fizzle(user)

	speak_incantation(user, "Da A[pick("'","`")]ig Osk!")
	target.use(10)
	var/obj/O = new /obj/structure/constructshell/cult(get_turf(src))
	visible_message("<span class='warning'>The metal bends into \the [O], and \the [src] imbues into it.</span>", "You hear a metallic sound.")
	qdel(src)

/obj/effect/rune/confuse
	cultname = "confuse"
	strokes = 4

/obj/effect/rune/confuse/cast(var/mob/living/user)
	speak_incantation(user, "Fuu ma[pick("'","`")]jin!")
	visible_message("<span class='danger'>\The [src] explodes in a bright flash.</span>")
	var/list/mob/affected = list()
	for(var/mob/living/M in viewers(src))
		if(iscultist(M))
			continue
		var/obj/item/weapon/nullrod/N = locate() in M
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

/obj/effect/rune/revive
	cultname = "revive"
	strokes = 4

/obj/effect/rune/revive/cast(var/mob/living/user)
	var/mob/living/carbon/human/target
	var/obj/item/device/soulstone/source
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
	target.visible_message("<span class='warning'>\The [target]'s eyes glow with a faint red as \he stands up, slowly starting to breathe again.</span>", "<span class='warning'>Life... I'm alive again...</span>", "You hear liquid flow.")

/obj/effect/rune/blood_boil
	cultname = "blood boil"
	strokes = 4

/obj/effect/rune/blood_boil/cast(var/mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(cultists.len < 3)
		return fizzle()

	for(var/mob/living/M in cultists)
		M.say("Dedo ol[pick("'","`")]btoh!")

	var/list/mob/living/previous = list()
	var/list/mob/living/current = list()
	while(cultists.len >= 3)
		cultists = get_cultists()
		for(var/mob/living/carbon/M in viewers(src))
			if(iscultist(M))
				continue
			current |= M
			var/obj/item/weapon/nullrod/N = locate() in M
			if(N)
				continue
			M.take_overall_damage(5, 5)
			if(!(M in previous))
				if(M.should_have_organ(BP_HEART))
					to_chat(M, "<span class='danger'>Your blood boils!</span>")
				else
					to_chat(M, "<span class='danger'>You feel searing heat inside!</span>")
		previous = current.Copy()
		current.Cut()
		sleep(10)

/* Tier NarNar runes */

/obj/effect/rune/tearreality
	cultname = "tear reality"
	var/the_end_comes = 0
	var/the_time_has_come = 300
	var/obj/singularity/narsie/large/HECOMES = null
	strokes = 9

/obj/effect/rune/tearreality/cast(var/mob/living/user)
	if(!cult.allow_narsie)
		return
	if(the_end_comes)
		to_chat(user, "<span class='cult'>You are already summoning! Be patient!</span>")
		return
	var/list/mob/living/cultists = get_cultists()
	if(cultists.len < 5)
		return fizzle()
	for(var/mob/living/M in cultists)
		M.say("Tok-lyr rqa'nap g[pick("'","`")]lt-ulotf!")
		to_chat(M, "<span class='cult'>You are staring to tear the reality to bring Him back... stay around the rune!</span>")
	log_and_message_admins_many(cultists, "started summoning Nar-sie.")

	var/area/A = get_area(src)
	command_announcement.Announce("High levels of bluespace interference detected at \the [A]. Suspected wormhole forming. Investigate it immediately.")
	while(cultists.len > 4 || the_end_comes)
		cultists = get_cultists()
		if(cultists.len > 8)
			++the_end_comes
		if(cultists.len > 4)
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

/obj/effect/rune/tearreality/attack_hand(var/mob/living/user)
	..()
	if(HECOMES && !iscultist(user))
		var/input = input(user, "Are you SURE you want to sacrifice yourself?", "DO NOT DO THIS") in list("Yes", "No")
		if(input != "Yes")
			return
		speak_incantation(user, "Uhrast ka'hfa heldsagen ver[pick("'","`")]lot!")
		to_chat(user, "<span class='warning'>In the last moment of your humble life, you feel an immense pain as fabric of reality mends... with your blood.</span>")
		for(var/mob/M in living_mob_list_)
			if(iscultist(M))
				to_chat(M, "You see a vision of \the [user] keeling over dead, his blood glowing blue as it escapes \his body and dissipates into thin air; you hear an otherwordly scream and feel that a great disaster has just been averted.")
			else
				to_chat(M, "You see a vision of [name] keeling over dead, his blood glowing blue as it escapes his body and dissipates into thin air; you hear an otherwordly scream and feel very weak for a moment.")
		log_and_message_admins("mended reality with the greatest sacrifice", user)
		user.dust()
		cult.powerless = 1
		qdel(HECOMES)
		qdel(src)
		return

/obj/effect/rune/tearreality/attackby()
	if(the_end_comes)
		return
	..()

/* Imbue runes */

/obj/effect/rune/imbue
	cultname = "otherwordly abomination that shouldn't exist and that you should report to your local god as soon as you see it, along with the instructions for making this"
	var/papertype

/obj/effect/rune/imbue/cast(var/mob/living/user)
	var/obj/item/weapon/paper/target
	var/tainted = 0
	for(var/obj/item/weapon/paper/P in get_turf(src))
		if(!P.info)
			target = P
			break
		else
			tainted = 1
	if(!target)
		if(tainted)
			to_chat(user, "<span class='warning'>The blank is tainted. It is unsuitable.</span>")
		return fizzle(user)
	speak_incantation(user, "H'drak v[pick("'","`")]loso, mir'kanas verbot!")
	visible_message("<span class='warning'>The rune forms into an arcane image on the paper.</span>")
	new papertype(get_turf(src))
	qdel(target)
	qdel(src)

/obj/effect/rune/imbue/stun
	cultname = "stun imbue"
	papertype = /obj/item/weapon/paper/talisman/stun

/obj/effect/rune/imbue/emp
	cultname = "destroy technology imbue"
	papertype = /obj/item/weapon/paper/talisman/emp
