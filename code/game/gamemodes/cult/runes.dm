var/list/sacrificed = list()

/obj/effect/rune
	name = "rune"
	desc = "A strange collection of symbols drawn in blood."
	anchored = 1
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	unacidable = 1
	layer = TURF_LAYER

	var/cultname = ""

/obj/effect/rune/examine(var/mob/user)
	..()
	if(iscultist(user))
		user << "This is \a [cultname] rune."

/obj/effect/rune/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/book/tome) && iscultist(user))
		user.visible_message("<span class='notice'>[user] rubs \the [src] with \the [I], and \the [src] is absorbed by it.</span>", "You retrace your steps, carefully undoing the lines of the rune.")
		qdel(src)
		return
	else if(istype(I, /obj/item/weapon/nullrod))
		user.visible_message("<span class='notice'>[user] hits \the [src] with \the [I], and it disappears, fizzling.</span>", "<span class='notice'>You disrupt the vile magic with the deadening field of \the [I].</span>")
		qdel(src)
		return

/obj/effect/rune/attack_hand(var/mob/living/user)
	if(!iscultist(user))
		user << "You can't mouth the arcane scratchings without fumbling over them."
		return
	if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle) || user.silent)
		user << "You are unable to speak the words of the rune."
		return
	cast(user)

/obj/effect/rune/proc/cast(var/mob/living/user)
	fizzle(user)

/obj/effect/rune/proc/get_cultists()
	. = list()
	for(var/mob/living/M in range(1))
		if(iscultist(M))
			. += M

/obj/effect/rune/proc/fizzle(var/mob/living/user)
	user.say(pick("Hakkrutju gopoenjim.", "Nherasai pivroiashan.", "Firjji prhiv mazenhor.", "Tanah eh wakantahe.", "Obliyae na oraie.", "Miyf hon vnor'c.", "Wakabai hij fen juswix."))
	visible_message("<span class='warning'>The markings pulse with a small burst of light, then fall dark.</span>", "You hear a faint fizzle.")

	//obj/effect/rune/proc/check_icon()
		//icon = get_uristrune_cult(word1, word2, word3)

/obj/effect/rune/cultify()
	return

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

	user.say("Mah[pick("'","`")]weyh pleggh at e'ntrath!")
	target.visible_message("<span class='warning'>The markings below [target] glow a bloody red.</span>")

	if(!cult.can_become_antag(target.mind) || jobban_isbanned(target, "cultist"))
		target << "<span class='cult'>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</span>"
		target << "<span class='danger'>And you were able to force it out of your mind. You now know the truth, there's something horrible out there, stop it and its minions at all costs.</span>"
	else
		target << "<span class='cult'>Do you want to join the cult of Nar'Sie? <a href='?src=\ref[src];join=1'>YES</a></span>"

	spamcheck = 1
	spawn(40)
		spamcheck = 0
		if(!iscultist(target) && target.loc == get_turf(src)) // They hesitated, resisted, or can't join, and they are still on the rune - burn them
			if(target.stat == CONSCIOUS)
				target.take_overall_damage(0, 10)
				switch(target.getFireLoss())
					if(0 to 25)
						target << "<span class='danger'>Your blood boils as you force yourself to resist the corruption invading every corner of your mind.</span>"
					if(25 to 45)
						target << "<span class='danger'>Your blood boils and your body burns as the corruption further forces itself into your body and mind.</span>"
						target.take_overall_damage(0, 3)
					if(45 to 75)
						target << "<span class='danger'>You begin to hallucinate images of a dark and incomprehensible being and your entire body feels like its engulfed in flame as your mental defenses crumble.</span>"
						target.take_overall_damage(0, 5)
					if(75 to 100)
						target << "<span class='cult'>Your mind turns to ash as the burning flames engulf your very soul and images of an unspeakable horror begin to bombard the last remnants of mental resistance.</span>"
						target.take_overall_damage(0, 10)
					if(100 to INFINITY)
						target << "<span class='cult'>Your entire broken soul and being is engulfed in corruption and flames as your mind shatters away into nothing.</span>"
//TODO: kick out, replace by ghost
//else
//TODO: same

/obj/effect/rune/convert/Topic(href, href_list)
	if(href_list["join"])
		if(usr.loc == loc && !iscultist(usr))
			cult.add_antagonist(usr.mind)

/obj/effect/rune/teleport
	cultname = "teleport"
	var/destination

/obj/effect/rune/teleport/New()
	var/area/A = get_area(src)
	destination = A.name

/obj/effect/rune/teleport/examine(var/mob/user)
	..()
	if(iscultist(user))
		user << "Its name is [destination]."

/obj/effect/rune/teleport/cast(var/mob/living/user)
	if(user.loc == get_turf(src))
		user.say("Sas[pick("'","`")]so c'arta forbici!")
		user.visible_message("<span class='warning'>\The [user] disappears in a flash of red light!</span>", "<span class='warning'>You feel as your body gets dragged through the dimension of Nar-Sie!</span>", "<span class='warning'>You hear a sickening crunch.</span>")
		// TODO: actually teleport them
	else
		var/input = input(user, "Choose a new rune name.", "Destination", "")
		if(!input)
			return
		destination = sanitize(input)

/obj/effect/rune/tome
	cultname = "summon tome"

/obj/effect/rune/tome/cast(var/mob/living/user)
	new /obj/item/weapon/book/tome(get_turf(src))
	user.say("N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
	visible_message("<span class='notice'>\The [src] disappears with a flash of red light, and in its place now a book lies.</span>", "You hear a pop.")
	qdel(src)

/obj/effect/rune/wall
	cultname = "wall"

	var/obj/effect/cultwall/wall = null

/obj/effect/rune/wall/Destroy()
	if(wall)
		qdel(wall)
	..()

/obj/effect/rune/wall/cast(var/mob/living/user)
	var/t
	if(wall)
		if(wall.health >= wall.max_health)
			user << "<span class='notice'>The wall doesn't need mending.</span>"
			return
		t = min(100, wall.max_health - wall.health) // I'm limiting it in case someone edits the wall to have a lot of maxhealth so it won't kill cultists in one cast
		wall.health += t
	else
		wall = new /obj/effect/cultwall(get_turf(src))
		wall.rune = src
		t = wall.health
	user.pay_for_rune(t / 10)
	user.say("Khari[pick("'","`")]d! Eske'te tannin!")
	user << "<span class='warning'>Your blood flows into the rune, and you feel that the very space over the rune thickens.</span>"

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
	var/health = 50
	var/max_health = 50

/obj/effect/cultwall/Destroy()
	rune.wall = null
	..()

/obj/effect/cultwall/examine(var/mob/user)
	..()
	if(iscultist(user))
		switch(health / max_health)
			if(0 to 0.5)
				user << "<span class='danger'>It is about to dissipate.</span>"
			if(0.5 to 1)
				user << "<span class='warning'>It is damaged.</span>"
			if(1)
				user << "<span class='notice'>It is fully intact.</span>"

/obj/effect/cultwall/attack_hand(var/mob/living/user)
	if(iscultist(user))
		user.visible_message("<span class='notice'>\The [user] touches \the [src], and it fades.</span>", "<span class='notice'>You touch \the [src], whispering the old ritual, making it disappear.</span>")
		qdel(src)
	else
		user << "<span class='notice'>You touch \the [src]. It feels wet and becomes harder the further you push your arm.</span>"

/obj/effect/cultwall/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/nullrod))
		user.visible_message("<span class='notice'>\The [user] touches \the [src] with \the [I], and it disappears.</span>", "<span class='notice'>You disrupt the vile magic with the deadening field of \the [I].</span>")
		qdel(src)
	else if(I.force)
		user.visible_message("<span class='notice'>\The [user] hits \the [src] with \the [I].</span>", "<span class='notice'>You hit \the [src] with \the [I].</span>")
		take_damage(I.force)//TODO: bullet_act and hitby

/obj/effect/cultwall/proc/take_damage(var/amount)
	health -= amount
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] dissipates.</span>")
		qdel(src)

/obj/effect/rune/ajorney
	cultname = "astral journey"

/obj/effect/rune/ajorney/cast(var/mob/living/user)
	if(user.loc != get_turf(src))
		return
	user.say("Fwe[pick("'","`")]sh mah erl nyag r'ya!")
	user.visible_message("<span class='warning'>\The [user]'s eyes glow blue as \he freezes in place, absolutely motionless.</span>", "<span class='warning'>The shadow that is your spirit separates itself from your body. You are now in the realm beyond. While this is a great sight, being here strains your mind and body. Hurry...</span>", "You hear only complete silence for a moment.")
	announce_ghost_joinleave(user.ghostize(1), 1, "You feel that they had to use some [pick("dark", "black", "blood", "forgotten", "forbidden")] magic to [pick("invade", "disturb", "disrupt", "infest", "taint", "spoil", "blight")] this place!")
	while(user)
		if(user.stat == DEAD)
			return
		if(user.key)
			return
		else if(user.loc != get_turf(src) && 0) // TODO
			var/mob/dead/observer/O
			O.reenter_corpse()
		else
			user.take_organ_damage(0, 1)
		sleep(20)
	fizzle(user)

/obj/effect/rune/defile
	cultname = "defile"

/obj/effect/rune/defile/cast(var/mob/living/user)
	user.say("Ia! Ia! Zasan therium viortia.")
	for(var/turf/T in range(1))
		T.cultify()
	visible_message("<span class='warning'>\The [src] embeds into the floor and walls around it, changing them!</span>", "You hear a liquid flow.")
	qdel(src)

/* Tier 2 runes */

/obj/effect/rune/armor
	cultname = "summon robes"

/obj/effect/rune/armor/cast(var/mob/living/user)
	user.say("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	visible_message("<span class='warning'>\The [src] disappears with a flash of red light, and a set of armor appears on \the [user].</span>", "<span class='warning'>You are blinded by the flash of red light. After you're able to see again, you see that you are now wearing a set of armor.</span>")

	var/obj/O = user.get_equipped_item(slot_head) // This will most likely kill you if you are wearing a spacesuit, and it's 100% intended
	if(O)
		user.unEquip(O)
	O = user.get_equipped_item(slot_wear_suit)
	if(O)
		user.unEquip(O)
	O = user.get_equipped_item(slot_shoes)
	if(O)
		user.unEquip(O)
	O = user.get_equipped_item(slot_back)
	if(istype(O, /obj/item/weapon/storage)) // We don't want to make the vox drop their nitrogen tank, though
		user.unEquip(O)

	user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), slot_head)
	user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit)
	user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), slot_shoes)
	user.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/cultpack(user), slot_back)
	user.update_icons()

	qdel(src)

/obj/effect/rune/sacrifice
	cultname = "sacrifice"

/obj/effect/rune/sacrifice/cast(var/mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(cultists.len < 3)
		user << "<span class='warning'>You need three cultists around this rune to make it work.</span>"
		return fizzle(user)
	var/turf/T = get_turf(src)
	var/mob/living/victim
	for(var/mob/living/M in T)
		if(M.stat != DEAD && !iscultist(M))
			victim = M
			break
	if(!victim)
		return fizzle(user)

	for(var/mob/living/M in cultists)
		M.say("Barhah hra zar[pick("'","`")]garis!")

	while(victim && victim.loc == T && victim.stat != DEAD)
		T.turf_animation('icons/effects/effects.dmi', "rune_sac")
		victim.fire_stacks = max(2, victim.fire_stacks)
		victim.IgniteMob()
		victim.take_organ_damage(5, 5) // This is to speed up the process and also damage mobs that don't take damage from being on fire, e.g. borgs
		switch(victim.health)
			if(50 to INFINITY)
				world << "<span class='danger'>Your flesh burns!</span>"
			if(0 to 50)
				world << "<span class='danger'>You feel as if your body is rippened apart and burned!</span>"
			if(-INFINITY to 0)
				world << "<span class='danger'>!</span>" // TODO goddamn this is hard
		sleep(40)
	if(victim && victim.loc == T && victim.stat == DEAD)
		//TODO: add points and handle sac target, give soulstone. Other rewards?
		/*
		var/worth = 0
		if(istype(H,/mob/living/carbon/human))
			var/mob/living/carbon/human/lamb = H
			if(lamb.species.rarity_value > 3)
				worth = 1

		if(H.mind == cult.sacrifice_target)

		usr << "<span class='warning'>The Geometer of Blood accepts this sacrifice, your objective is now complete.</span>"

		usr << "<span class='warning'>The Geometer of Blood accepts this [worth ? "exotic " : ""]sacrifice.</span>"

		usr << "<span class='warning'>The Geometer of blood accepts this sacrifice.</span>"
		usr << "<span class='warning'>However, this soul was not enough to gain His favor.</span>"

		usr << "<span class='warning'>The Geometer of blood accepts this sacrifice.</span>"
		usr << "<span class='warning'>However, a mere dead body is not enough to satisfy Him.</span>"
		*/
		world << "<span class='cult'>The Geometer of Blood claims your body.</span>"
		victim.dust()
	victim.ExtinguishMob() // Technically allows them to put the fire out by sacrificing them and stopping immediately, but I don't think it'd have much effect

/obj/effect/rune/manifest
	cultname = "manifest"
	var/mob/living/carbon/human/puppet = null

/obj/effect/rune/manifest/Destroy()
	if(puppet)
		puppet.dust()
		puppet = null
	..()

/obj/effect/rune/manifest/cast(var/mob/living/user)
	if(puppet)
		user << "<span class='warning'>This rune already has a servant bound to it.</span>"
		return fizzle()
	var/mob/dead/observer/ghost
	for(var/mob/dead/observer/O in get_turf(src))
		if(!O.client)
			continue
		if(!O.MayRespawn()) // Antaghud or actually a journeying cultist/wizard, has nothing to do with timer
			continue
		if(jobban_isbanned(O, "cultist"))
			continue
		ghost = O
		break
	if(!ghost)
		return fizzle(user)
	user.say("Gal'h'rfikk harfrandid mud[pick("'","`")]gib!")
	puppet = new /mob/living/carbon/human(get_turf(src)) // TODO: give them their own species
	visible_message("<span class='warning'>A shape forms in the center of the rune. A shape of... a man.</span>", "You hear a liquid flow.")
	puppet.real_name = pick("Anguished", "Blasphemous", "Corrupt", "Cruel", "Depraved", "Despicable", "Disturbed", "Exacerbated", "Foul", "Hateful", "Inexorable", "Implacable", "Impure", "Malevolent", "Malignant", "Malicious", "Pained", "Profane", "Profligate", "Relentless", "Resentful", "Restless", "Spiteful", "Tormented", "Unclean", "Unforgiving", "Vengeful", "Vindictive", "Wicked", "Wronged")
	puppet.real_name += " "
	puppet.real_name += pick("Apparition", "Aptrgangr", "Dis", "Draugr", "Dybbuk", "Eidolon", "Fetch", "Fylgja", "Ghast", "Ghost", "Gjenganger", "Haint", "Phantom", "Phantasm", "Poltergeist", "Revenant", "Shade", "Shadow", "Soul", "Spectre", "Spirit", "Spook", "Visitant", "Wraith")
	puppet.universal_speak = 1
	puppet.s_tone = 35
	puppet.b_eyes = 200
	puppet.r_eyes = 200
	puppet.g_eyes = 200
	puppet.update_eyes()
	puppet.underwear = 0
	puppet.key = ghost.key
	cult.add_antagonist(puppet.mind)

	log_and_message_admins("used a manifest rune.")

/obj/effect/rune/drain
	cultname = "blood drain"

/obj/effect/rune/drain/cast(var/mob/living/user)
	var/mob/living/carbon/human/victim
	for(var/mob/living/carbon/human/M in get_turf(src))
		if(iscultist(M))
			continue
		if(M.species && (M.species.flags & NO_BLOOD))
			continue
		victim = M
	if(!victim)
		return fizzle(user)
	if(!victim.vessel.has_reagent("blood", 20))
		user << "<span class='warning'>This body has no blood left.</span>"
		return fizzle(user)
	victim.vessel.remove_reagent("blood", 20)
	// TODO: drain blood
	admin_attack_log(user, victim, "Used a blood drain rune.", "Was victim of a blood drain rune.", "used a blood drain rune on")
	victim << "<span class='danger'>You feel weakened.</span>"
	user.say("Yu[pick("'","`")]gular faras desdae. Havas mithum javara. Umathar uf'kal thenar!")
	user.visible_message("<span class='warning'>Blood flows from \the [src] into \the [user]!</span>", "<span class='cult'>The blood starts flowing from \the [src] into your frail mortal body. You feel... empowered. [capitalize(english_list(heal_user(user)))].</span>", "You hear a liquid flow.")
	//user.visible_message("<span class='warning'>\The [user]'s eyes give off eerie red glow!</span>", "<span class='warning'>...but it wasn't nearly enough. You crave, crave for more. The hunger consumes you from within.</span>", "<span class='warning'>You hear a heartbeat.</span>")

/obj/effect/rune/drain/proc/heal_user(var/mob/living/carbon/human/user)
	if(!istype(user))
		return list("you feel no different")
	var/list/statuses = list()
	var/charges = 20
	var/use
	if(!(user.species && (user.species.flags & NO_BLOOD)))
		use = min(charges, 560 - user.vessel.total_volume)
		if(use)
			user.vessel.add_reagent("blood", use)
			charges -= use
			statuses += "you feel warmer, regaining lost blood"
			if(!charges)
				return statuses
	if(user.getBruteLoss() || user.getFireLoss())
		var/healbrute = user.getBruteLoss()
		var/healburn = user.getBruteLoss()
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
	if(charges >= 10)
		for(var/obj/item/organ/external/e in user.organs)
			if(e && e.status & ORGAN_BROKEN)
				e.status &= ~ORGAN_BROKEN
				e.status &= ~ORGAN_SPLINTED
				e.perma_injury = 0
				statuses += "bones in your [e] snap into place"
				charges -= 10
				if(charges < 10)
					break
	if(!charges)
		return statuses
	var/list/obj/item/organ/damaged = list()
	for(var/obj/item/organ/I in user.internal_organs)
		if(I.damage)
			damaged += I
	if(damaged.len)
		statuses += "you feel pain inside for a moment, it passes"
		while(charges && damaged.len)
			var/obj/item/organ/fix = pick(damaged)
			fix.damage = max(0, fix.damage - min(charges, 1))
			charges = max(charges - 1, 0)
			if(fix.damage == 0)
				damaged -= fix
	if(!statuses.len)
		statuses += "you feel no different"
	return statuses

/* Tier 3 runes */

/obj/effect/rune/weapon
	cultname = "summon weapon"

/obj/effect/rune/weapon/cast(var/mob/living/user)
	if(!istype(user.get_equipped_item(slot_head), /obj/item/clothing/head/culthood) || !istype(user.get_equipped_item(slot_wear_suit), /obj/item/clothing/suit/cultrobes) || !istype(user.get_equipped_item(slot_shoes), /obj/item/clothing/shoes/cult))
		user << "<span class='warning'>You need to be wearing your robes to use this rune.</span>"
		return fizzle(user)
	var/turf/T = get_turf(src)
	if(T.icon_state != "cult" && T.icon_state != "cult-narsie")
		user << "<span class='warning'>This rune needs to be placed on the defiled ground.</span>"
		return fizzle(user)
	user.say("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	user.put_in_hands(new /obj/item/weapon/melee/cultblade(user))
	qdel(src)

/obj/effect/rune/shell
	cultname = "summon shell"

/obj/effect/rune/shell/cast(var/mob/living/user)
	var/turf/T = get_turf(src)
	if(T.icon_state != "cult" && T.icon_state != "cult-narsie")
		user << "<span class='warning'>This rune needs to be placed on the defiled ground.</span>"
		return fizzle(user)

	var/obj/item/stack/material/steel/target
	for(var/obj/item/stack/material/steel/S in get_turf(src))
		if(S.get_amount() >= 10)
			target = S
			break

	if(!target)
		user << "<span class='warning'>You need ten sheets of metal to fold them into a construct shell.</span>"
		return fizzle(user)

	user.say("Da A[pick("'","`")]ig Osk!")
	target.use(10)
	var/obj/O = new /obj/structure/constructshell/cult(get_turf(src))
	visible_message("<span class='warning'>The metal bends into \the [O], and \the [src] imbues into it.</span>", "You hear a metallic sound.")
	qdel(src)

/obj/effect/rune/bloodboil
	cultname = "blood boil"

/obj/effect/rune/confuse
	cultname = "confuse"

/obj/effect/rune/confuse/cast(var/mob/living/user)
	user.say("Fuu ma[pick("'","`")]jin!")
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
			C.eye_blind += 20
			C.Weaken(3)
			C.Stun(5)
		else if(issilicon(M))
			M.Weaken(10)

	admin_attacker_log_many_victims(user, affected, "Used a confuse rune.", "Was victim of a confuse rune.", "used a confuse rune on")
	qdel(src)

/obj/effect/rune/revive
	cultname = "revive"

/obj/effect/rune/revive/cast(var/mob/living/user)
	var/mob/living/carbon/human/target//TODO: demand a soulstone
	for(var/mob/living/carbon/human/M in get_turf(src))
		if(M.stat == DEAD)
			if(iscultist(M))
				if(M.key)
					target = M
					break
	if(!target)
		return fizzle()
	target.rejuvenate()
	user.say("Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!")
	//corpse_to_raise.visible_message("<span class='warning'>\The [corpse_to_raise]'s eyes glow with a faint red as he stands up, slowly starting to breathe again.</span>", "<span class='warning'>Life... I'm alive again...</span>", "<span class='warning'>You hear a faint, slightly familiar whisper.</span>")
	//body_to_sacrifice.visible_message("<span class='warning'>\The [body_to_sacrifice] is torn apart, a black smoke swiftly dissipating from his remains!</span>", "<span class='warning'>You feel as your blood boils, tearing you apart.</span>", "<span class='warning'>You hear a thousand voices, all crying in pain.</span>")

/* Tier NarNar runes */

/obj/effect/rune/tearreality
	cultname = "tear reality"

/obj/effect/rune/tearreality/cast(var/mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(cultists.len < 9)
		return fizzle()
	for(var/mob/living/M in cultists)
		M.say("Tok-lyr rqa'nap g[pick("'","`")]lt-ulotf!")
	log_and_message_admins_many(cultists, "summoned Nar-sie.") // Doesn't delete itself; TODO: give it a cool animation
	new /obj/singularity/narsie/large(get_turf(src)) // THE END HAS COME

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
			user << "<span class='warning'>The blank is tainted. It is unsuitable.</span>"
		return fizzle(user)
	user.say("H'drak v[pick("'","`")]loso, mir'kanas verbot!")
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

	/* This is neat shit, give it to chaplain? If he gets to narnar's rune after he's summoned?
		mend()
			var/mob/living/user = usr
			src = null
			user.say("Uhrast ka'hfa heldsagen ver[pick("'","`")]lot!")
			user.take_overall_damage(200, 0)
			user.visible_message("<span class='warning'>\The [user] keels over dead, his blood glowing blue as it escapes his body and dissipates into thin air.</span>", \
			"<span class='warning'>In the last moment of your humble life, you feel an immense pain as fabric of reality mends... with your blood.</span>", \
			"<span class='warning'>You hear faint rustle.</span>")
			for(,user.stat==2)
				sleep(600)
				if (!user)
					return
			return
			*/

/*

		bloodboil() //cultists need at least one DANGEROUS rune. Even if they're all stealthy.
			var/list/cultists = new //also, wording for it is old wording for obscure rune, which is now hide-see-blood.
			var/list/victims = new
//			var/list/cultboil = list(cultists-usr) //and for this words are destroy-see-blood.
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					cultists+=C
			if(cultists.len>=3)
				for(var/mob/living/carbon/M in viewers(usr))
					if(iscultist(M))
						continue
					var/obj/item/weapon/nullrod/N = locate() in M
					if(N)
						continue
					M.take_overall_damage(51,51)
					M << "<span class='warning'>Your blood boils!</span>"
					victims += M
					if(prob(5))
						spawn(5)
							M.gib()
				for(var/obj/effect/rune/R in view(src))
					if(prob(10))
						explosion(R.loc, -1, 0, 1, 5)
				for(var/mob/living/carbon/human/C in orange(1,src))
					if(iscultist(C) && !C.stat)
						C.say("Dedo ol[pick("'","`")]btoh!")
						C.take_overall_damage(15, 0)
				admin_attacker_log_many_victims(usr, victims, "Used a blood boil rune.", "Was the victim of a blood boil rune.", "used a blood boil rune on")
				log_and_message_admins_many(cultists - usr, "assisted activating a blood boil rune.")
				qdel(src)
			else
				return fizzle()
*/
