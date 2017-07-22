	// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(incapacitated(INCAPACITATION_DISABLED) || buckled || pinned.len)
		to_chat(src, "<span class='warning'>You cannot tackle in your current state.</span>")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	//check again because we waited for user input
	if(last_special > world.time)
		return

	if(incapacitated(INCAPACITATION_DISABLED) || buckled || pinned.len)
		to_chat(src, "<span class='warning'>You cannot tackle in your current state.</span>")
		return

	last_special = world.time + 50

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
	T.Weaken(rand(1,3))
	if(prob(75))
		visible_message("<span class='danger'>\The [src] has tackled down [T]!</span>")
	else
		visible_message("<span class='danger'>\The [src] tried to tackle down [T]!</span>")
		src.Weaken(rand(2,4)) //failure, you both get knocked down

/mob/living/carbon/human/proc/leap()
	set category = "Abilities"
	set name = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	if(last_special > world.time)
		return

	if(incapacitated(INCAPACITATION_DISABLED) || buckled || pinned.len)
		to_chat(src, "<span class='warning'>You cannot leap in your current state.</span>")
		return

	var/list/choices = list()
	for(var/mob/living/M in oview(6,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to leap at?") as null|anything in choices

	if(!T || !isturf(T.loc) || !src || !isturf(loc)) return

	if(get_dist(get_turf(T), get_turf(src)) > 4) return

	//check again because we waited for user input
	if(last_special > world.time)
		return

	if(incapacitated(INCAPACITATION_DISABLED) || buckled || pinned.len || stance_damage >= 4)
		to_chat(src, "<span class='warning'>You cannot leap in your current state.</span>")
		return

	last_special = world.time + (17.5 SECONDS)
	status_flags |= LEAPING

	src.visible_message("<span class='danger'>\The [src] leaps at [T]!</span>")
	src.throw_at(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	playsound(src.loc, 'sound/voice/shriek1.ogg', 50, 1)

	sleep(5)

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, "<span class='warning'>You miss!</span>")
		return

	T.Weaken(3)

	var/use_hand = "left"
	if(l_hand)
		if(r_hand)
			to_chat(src, "<span class='danger'>You need to have one hand free to grab someone.</span>")
			return
		else
			use_hand = "right"

	src.visible_message("<span class='warning'><b>\The [src]</b> seizes [T] aggressively!</span>")

	var/obj/item/grab/G = new(src,T)
	if(use_hand == "left")
		l_hand = G
	else
		r_hand = G

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
		to_chat(src, "<span class='warning'>Not even a [src.species.name] can speak to the dead.</span>")
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	to_chat(M, "<span class='notice'>Like lead slabs crashing into the ocean, alien thoughts drop into your mind: <i>[text]</i></span>")
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return
		if(prob(75))
			to_chat(H, "<span class='warning'>Your nose begins to bleed...</span>")
			H.drip(1)

/mob/living/carbon/human/proc/regurgitate()
	set name = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Abilities"

	if(stomach_contents.len)
		for(var/mob/M in src)
			if(M in stomach_contents)
				stomach_contents.Remove(M)
				M.forceMove(loc)
		src.visible_message("<span class='danger'>[src] hurls out the contents of their stomach!</span>")
	return

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]")
		to_chat(M, "<span class='alium'>You hear a strange, alien voice in your head... <i>[msg]</i></span>")
		to_chat(src, "<span class='alium'>You channel a message: \"[msg]\" to [M]</span>")
	return

/mob/living/carbon/human/proc/diona_split_nymph()
	set name = "Split"
	set desc = "Split your humanoid form into its constituent nymphs."
	set category = "Abilities"
	diona_split_into_nymphs(5)	// Separate proc to void argments being supplied when used as a verb

/mob/living/carbon/human/proc/diona_heal_toggle()
	set name = "Toggle Heal"
	set desc = "Turn your inate healing on or off."
	set category = "Abilities"
	innate_heal = !innate_heal
	if (innate_heal)
		to_chat(src, "<span class='alium'>You are now using nutrients to regenerate.</span>")
	else
		to_chat(src, "<span class='alium'>You are no longer using nutrients to regenerate.</span>")

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
	var/mob/living/carbon/alien/diona/L = S

	for(var/mob/living/carbon/alien/diona/D in src)
		nymphs++
		D.forceMove(T)
		transfer_languages(src, D, WHITELISTED|RESTRICTED)
		D.set_dir(pick(NORTH, SOUTH, EAST, WEST))
		L.set_next_nymph(D)
		D.set_last_nymph(L)
		L = D

	if(nymphs < number_of_resulting_nymphs)
		for(var/i in nymphs to (number_of_resulting_nymphs - 1))
			var/mob/living/carbon/alien/diona/M = new(T)
			transfer_languages(src, M, WHITELISTED|RESTRICTED)
			M.set_dir(pick(NORTH, SOUTH, EAST, WEST))
			L.set_next_nymph(M)
			M.set_last_nymph(L)
			L = M

	L.set_next_nymph(S)
	S.set_last_nymph(L)

	for(var/obj/item/W in src)
		drop_from_inventory(W)

	visible_message("<span class='warning'>\The [src] quivers slightly, then splits apart with a wet slithering noise.</span>")
	qdel(src)

/mob/living/carbon/human/proc/nab()
	set category = "Abilities"
	set name = "Nab"
	set desc = "Nab someone."

	if(last_special > world.time)
		return

	if(incapacitated(INCAPACITATION_DISABLED) || buckled || pinned.len)
		to_chat(src, "<span class='warning'>You cannot nab in your current state.</span>")
		return

	if(!cloaked || pulling_punches)
		to_chat(src, "<span class='warning'>You can only nab people when you are well hidden and ready to hunt.</span>")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to nab?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	//check again because we waited for user input
	if(last_special > world.time)
		return

	if(incapacitated(INCAPACITATION_DISABLED) || buckled || pinned.len)
		to_chat(src, "<span class='warning'>You cannot nab in your current state.</span>")
		return

	last_special = world.time + 50

	if(l_hand) unEquip(l_hand)
	if(r_hand) unEquip(r_hand)
	to_chat(src, "<span class='warning'>You drop everything as you spring out to nab someone!.</span>")

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
	cloaked = 0
	update_icons()

	if(prob(90) && src.make_grab(src, T, GRAB_NAB_SPECIAL))
		T.Weaken(rand(1,3))
		visible_message("<span class='danger'>[src] suddenly appears, lunging out and grabbing [T]!</span>")
		LAssailant = src

		src.do_attack_animation(T)
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return 1

	else
		visible_message("<span class='danger'>[src] suddenly appears, lunging and almost grabbing [T]!</span>")

/mob/living/carbon/human/proc/active_camo()
	set category = "Abilities"
	set name = "Active Camo"
	set desc = "Camouflage yourself"
	cloaked = !cloaked
	if(cloaked)
		apply_effect(2, STUN, 0)
		to_chat(src, "<span class='notice'>You hold perfectly still, shifting your exterior to match the things around you.</span>")
	else
		visible_message("<span class='danger'>[src] suddenly appears!</span>")
	update_icons()


/mob/living/carbon/human/proc/switch_stance()
	set category = "Abilities"
	set name = "Switch Stance"
	set desc = "Toggle between your hunting and manipulation stance"

	if(stat) return

	to_chat(src, "<span class='notice'>You begin to adjust the fluids in your arms, dropping everything and getting ready to swap which set you're using.</span>")

	if(l_hand) unEquip(l_hand)
	if(r_hand) unEquip(r_hand)

	// So there's a progress bar if you're not cloaked and there isn't one if you are cloaked.
	var/hidden = cloaked

	if(do_after(src, 30))
		pulling_punches = !pulling_punches

		if(pulling_punches)
			current_grab_type = all_grabobjects[GRAB_NORMAL]
			to_chat(src, "<span class='notice'>You relax your hunting arms, lowering the pressure and folding them tight to your thorax.\
			You reach out with your manipulation arms, ready to use complex items.</span>")
			if(!hidden)
				visible_message("<span class='notice'>[src] seems to relax as \he folds \his massive curved arms to \his thorax and reaches out \
				with \his small handlike limbs.</span>")
		else
			current_grab_type = all_grabobjects[GRAB_NAB]
			to_chat(src, "<span class='notice'>You pull in your manipulation arms, dropping any items and unfolding your massive hunting arms in preparation of grabbing prey.</span>")
			if(!hidden)
				visible_message("<span class='warning'>[src] tenses as \he brings his smaller arms in close to \his body. \his two massive apiked arms reach \
				out. \he looks dangerous and ready to attack.</span>")
	else
		to_chat(src, "<span class='notice'>You stop adjusting your arms and don't switch between them.</span>")

/mob/living/carbon/human/proc/change_colour()
	set category = "Abilities"
	set name = "Change Colour"
	set desc = "Choose the colour of your skin."

	var/new_skin = input(usr, "Choose your new skin colour: ", "Change Colour", rgb(r_skin, g_skin, b_skin)) as color|null
	change_skin_color(hex2num(copytext(new_skin, 2, 4)), hex2num(copytext(new_skin, 4, 6)), hex2num(copytext(new_skin, 6, 8)))
