// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z
/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = sanitize(text)

	if(!text) return

	var/mob/M = targets[target]

	if(isghost(M) || M.stat == DEAD)
		src << "Not even a [src.species.name] can speak to the dead."
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	M << "\blue Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]"
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return
		H << "\red Your nose begins to bleed..."
		H.drip(1)

/mob/living/carbon/human/proc/diona_split_into_nymphs(var/number_of_resulting_nymphs)
	var/turf/T = get_turf(src)

	var/mob/living/carbon/alien/diona/S = new(T)
	S.set_dir(dir)
	transfer_languages(src, S)
	if(mind)
		mind.transfer_to(S)

	message_admins("\The [src] has split into nymphs; player now controls [key_name_admin(S)]")
	log_admin("\The [src] has split into nymphs; player now controls [key_name(S)]")

	var/nymphs = 1

	for(var/mob/living/carbon/alien/diona/D in src)
		nymphs++
		D.forceMove(T)
		transfer_languages(src, D, WHITELISTED|RESTRICTED)
		D.set_dir(pick(NORTH, SOUTH, EAST, WEST))

	if(nymphs < number_of_resulting_nymphs)
		for(var/i in nymphs to (number_of_resulting_nymphs - 1))
			var/mob/M = new /mob/living/carbon/alien/diona(T)
			transfer_languages(src, M, WHITELISTED|RESTRICTED)
			M.set_dir(pick(NORTH, SOUTH, EAST, WEST))

	for(var/obj/item/W in src)
		drop_from_inventory(W)

	visible_message("<span class='warning'>\The [src] quivers slightly, then splits apart with a wet slithering noise.</span>")
	qdel(src)


/**********************
*     SPELL VERSIONS  *
**********************/
/spell/targeted/free/regurgitate
	name = "Regurgitate"
	desc = "Empties the contents of your stomach"
	panel = "Innate Abilities"
	spell_flags = INCLUDEUSER
	range = -1

	hud_state = "alien_barf"

/spell/targeted/free/regurgitate/cast(var/list/targets, mob/user)
	if(!istype(targets[1],/mob/living/carbon))
		return
	var/mob/living/carbon/C = targets[1]
	if(C.stomach_contents.len)
		for(var/atom/movable/M in C)
			if(M in C.stomach_contents)
				C.stomach_contents.Remove(M)
				M.loc = get_turf(C)
		user.visible_message("\red <B>[user] hurls out the contents of their stomach!</B>")
		playsound(user,'sound/effects/splat.ogg',80,1)
	return
/spell/targeted/free/psychic_whisper
	name = "Psychic Whisper"
	desc = "Whisper silently to someone over a distance."
	spell_flags = SELECTABLE
	range = null //null because we want view() and view(null) is equal to view()
	hud_state = "alien_whisper"

/spell/targeted/free/psychic_whisper/cast(var/list/targets, var/mob/user)
	var/mob/target = targets[1]

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(user)]->[target.key] : [msg]")
		target << "\green You hear a strange, alien voice in your head... \italic [msg]"
		user << "\green You said: \"[msg]\" to [target]"
		say_dead_direct("<i>[user] psychically whispers to [target], \"[msg]\"</i>")

/spell/targeted/free/split_diona
	name = "Split"
	desc = "Split your humanoid form into its constituent nymphs."
	range = -1
	spell_flags = INCLUDEUSER
	compatible_mobs = list(/mob/living/carbon/human)

	hud_state = "alien_split"

/spell/targeted/free/split_diona/cast(var/list/targets, var/mob/user)
	user.remove_spell(src)
	var/mob/living/carbon/human/H = targets[1]
	H.diona_split_into_nymphs(5)

/spell/gut
	name = "Gut"
	desc = "While grabbing someone aggressively, rip their guts out or tear them apart."
	spell_flags = 0

	charge_max = 200 //20 seconds. Probably a bit low but xenos shouldn't be killing people anyways
	hud_state = "alien_gut"

/spell/gut/choose_targets()
	var/obj/item/weapon/grab/G = locate() in holder
	if(!G || !istype(G))
		holder << "\red You are not grabbing anyone."
		return null

	if(G.state < GRAB_AGGRESSIVE)
		holder << "\red You must have an aggressive grab to gut your prey!"
		return null

	return list(G.affecting)

/spell/gut/cast(var/list/targets, var/mob/user)
	var/mob/target = targets[1]

	user.visible_message("<span class='warning'><b>\The [user]</b> rips viciously at \the [target]'s body with its claws!</span>")
	if(!istype(target,/mob/living))
		return

	var/mob/living/M = target

	M.adjustBruteLoss(50)
	if(M.stat == 2)
		var/obj/item/weapon/grab/G = locate() in holder
		if(G)//we drop it here because of some weird interaction between gib() and grabs that causes exceptions.
			user.drop_from_inventory(G)
		M.gib()

/spell/hand/leap
	name = "Leap"
	hand_name = "ability"
	not_ready_message = "Leaping again will put too much strain on your body!"
	intent_help_message = "You decide against leaping as your intent is set to help."
	empty_hand_message = "You need an empty hand to use this!"
	spell_delay = 20
	charge_max = 0
	spell_flags = 0
	min_range = 1
	range = 4
	compatible_targets = list(/atom)
	custom_stat = 1
	var/list/allowed_grabs = list(/mob) //mob or /obj/item mostly. Can put further children in there however but those are the compatible bases.

	hud_state = "alien_leap"

/spell/hand/leap/get_stat()
	return "Free"

/spell/hand/leap/cast_hand(var/atom/a,var/mob/user, var/obj/item/magic_hand/hand)
	if(user.buckled || user.restrained())
		user << "You cannot leap if you're restrained!"
		return 0
	user.status_flags |= LEAPING
	user.visible_message("<span class='danger'>\The [user] leaps[ismob(a) ? " at [a]!" : "!"]</span>")

	playsound(get_turf(user), 'sound/voice/shriek1.ogg', 50, 1)
	user.throw_at(get_step(get_turf(a),get_turf(user)), 4, 1, user)
	sleep(5)
	if(user.status_flags & LEAPING)
		user.status_flags &= ~LEAPING

	if(!user.Adjacent(a))
		user << "<span class='warning'>You miss!</span>"
		return 1

	if(istype(a,/atom/movable))
		var/atom/movable/m = a
		if(m.anchored)
			return 1

	if(!is_type_in_list(a,allowed_grabs))
		return 1

	if(user.l_hand && !istype(user.l_hand,/obj/item/magic_hand))
		if(user.r_hand && !istype(user.r_hand,/obj/item/magic_hand))
			user << "<span class='danger'>You need to have one hand free to grab someone.</span>"
			return 1
	if(istype(a,/obj/item))
		user.drop_from_inventory(hand)
		user.put_in_hands(a)
		user.visible_message("\The [user] snatches up \the [a]!")
	else if(istype(a,/mob))
		user.drop_from_inventory(hand)
		var/obj/item/weapon/grab/G = new(user,a)
		user.put_in_hands(G)
		G.state = GRAB_PASSIVE
		G.icon_state = "grabbed1"
		G.synch()
		var/mob/M = a
		M.Weaken(3)

	return 1

/spell/hand/leap/vox
	allowed_grabs = list(/mob,/obj/item)

/spell/hand/leap/vox/get_stat()
	return "50 Nutrition Per"

/spell/hand/leap/vox/take_hand_charge(var/mob/user, var/obj/item/magic_hand/hand)
	if(!istype(user,/mob/living/carbon))
		return 1
	var/mob/living/carbon/C = user
	if(C.nutrition < 25)
		C.nutrition = 0
		user << "<span class='warning'>Your muscles tear from overexertion!</span>"
		if(!istype(user,/mob/living/carbon/human))
			C.adjustBruteLoss(15)
		else
			var/limb = pick("l_leg","r_leg","l_foot","r_foot") //legs, basically
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/O = H.get_organ(limb)
			O.take_damage(15)
	else
		C.nutrition -= 25
		if(C.nutrition <= 75)
			user << "<span class='warning'>Your body can't take too many more leaps!</span>"
	return 1

/spell/hand/leap/vox/pariah
	allowed_grabs = list()

/spell/hand/leap/vox/pariah/cast_hand(var/atom/a,var/mob/user)
	if(..())
		user.Weaken(5)

/spell/hand/tackle
	name = "tackle"
	hand_name = "ability"
	spell_flags = 0
	intent_help_message = "You decide against tackling as your intent is set to help."
	empty_hand_message = "You need an empty hand to use this!"
	compatible_targets = list(/mob)
	custom_stat = 1
	range = 1

/spell/hand/tackle/get_stat()
	return "25% chance failure"

/spell/hand/tackle/cast_hand(var/atom/a,var/mob/user, var/obj/item/magic_hand/hand)
	if(user.buckled || user.restrained() || user.weakened)
		user << "You are restrained! You can't tackle anybody!"
		return
	var/mob/M = a
	var/failed
	if(prob(75))
		M.Weaken(rand(0.5,3))
	else
		user.Weaken(rand(2,4))
		failed = 1

	playsound(user, 'sound/weapons/pierce.ogg', 25, 1, -1)

	user.visible_message("<span class='danger'>[user] [failed ? "tried to tackle" : "has tackled"] down [M]!</span>")

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot tackle someone in your current state."
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot tackle in your current state."
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.Weaken(rand(0.5,3))
	else
		src.Weaken(rand(2,4))
		failed = 1

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
	if(failed)
		src.Weaken(rand(2,4))

	for(var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message(text("\red <B>[] [failed ? "tried to tackle" : "has tackled"] down []!</B>", src, T), 1)