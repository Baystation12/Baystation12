// Contains all /mob/procs that relate to vampire.

// Drains the target's blood.
/mob/living/carbon/human/proc/vampire_drain_blood()
	set category = "Vampire"
	set name = "Drain Blood"
	set desc = "Drain the blood of a humanoid creature."

	var/datum/vampire/vampire = vampire_power(0, 0)
	if (!vampire)
		return

	var/obj/item/grab/G = get_active_hand()
	if (!istype(G))
		to_chat(src, "<span class='warning'>You must be grabbing a victim in your active hand to drain their blood.</span>")
		return

	if (G.state == GRAB_PASSIVE || G.state == GRAB_UPGRADING)
		to_chat(src, "<span class='warning'>You must have the victim pinned to the ground to drain their blood.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting
	if (!istype(T) || T.species.flags & NO_BLOOD)
		//Added this to prevent vampires draining diona and IPCs
		//Diona have 'blood' but its really green sap and shouldn't help vampires
		//IPCs leak oil
		to_chat(src, "<span class='warning'>[T] is not a creature you can drain useful blood from.</span>")
		return

	if (vampire.status & VAMP_DRAINING)
		to_chat(src, "<span class='warning'>Your fangs are already sunk into a victim's neck!</span>")
		return

	var/datum/vampire/draining_vamp = null
	if (T.mind && T.mind.vampire)
		draining_vamp = T.mind.vampire

	var/blood = 0
	var/blood_total = 0
	var/blood_usable = 0

	vampire.status |= VAMP_DRAINING

	visible_message("<span class='danger'>[src.name] bites [T.name]'s neck!</span>", "<span class='danger'>You bite [T.name]'s neck and begin to drain their blood.</span>", "<span class='notice'>You hear a soft puncture and a wet sucking noise</span>")
	admin_attack_log(src, T, "drained blood from [key_name(T)]", "was drained blood from by [key_name(src)]", "is draining blood from")

	to_chat(T, "<span class='warning'>You are unable to resist or even move. Your mind blanks as you're being fed upon.</span>")

	T.Stun(10)

	while (do_mob(src, T, 50))
		if (!mind.vampire)
			to_chat(src, "<span class='danger'>Your fangs have disappeared!</span>")
			return

		blood_total = vampire.blood_total
		blood_usable = vampire.blood_usable

		if (!T.vessel.get_reagent_amount("blood"))
			to_chat(src, "<span class='danger'>[T] has no more blood left to give.</span>")
			break

		if (!T.stunned)
			T.Stun(10)

		var/frenzy_lower_chance = 0

		// Alive and not of empty mind.
		if (T.stat < 2 && T.client)
			blood = min(10, T.vessel.get_reagent_amount("blood"))
			vampire.blood_total += blood
			vampire.blood_usable += blood

			frenzy_lower_chance = 40

			if (draining_vamp)
				vampire.blood_vamp += blood
				// Each point of vampire blood will increase your chance to frenzy.
				vampire.frenzy += blood

				// And drain the vampire as well.
				draining_vamp.blood_usable -= min(blood, draining_vamp.blood_usable)
				vampire_check_frenzy()

				frenzy_lower_chance = 0
		// SSD/protohuman or dead.
		else
			blood = min(5, T.vessel.get_reagent_amount("blood"))
			vampire.blood_usable += blood

			frenzy_lower_chance = 40

		if (prob(frenzy_lower_chance) && vampire.frenzy > 0)
			vampire.frenzy--

		if (blood_total != vampire.blood_total)
			var/update_msg = "<span class='notice'>You have accumulated [vampire.blood_total] [vampire.blood_total > 1 ? "units" : "unit"] of blood.</span>"
			if (blood_usable != vampire.blood_usable)
				update_msg += "<span class='notice'> And have [vampire.blood_usable] left to use.</span>"

			to_chat(src, update_msg)
		check_vampire_upgrade()
		T.vessel.remove_reagent("blood", 25)

	vampire.status &= ~VAMP_DRAINING
	to_chat(src, "<span class='notice'>You extract your fangs from [T.name]'s neck and stop draining them of blood. They will remember nothing of this occurance. Provided they survived.</span>")

	if (T.stat != 2)
		to_chat(T, "<span class='warning'>You remember nothing about being fed upon. Instead, you simply remember having a pleasant encounter with [src.name].</span>")

// Small area of effect stun.
/mob/living/carbon/human/proc/vampire_glare()
	set category = "Vampire"
	set name = "Glare"
	set desc = "Your eyes flash a bright light, stunning any who are watching."

	if (!vampire_power(0, 1))
		return

	if (!has_eyes())
		to_chat(src, "<span class='warning'>You don't have eyes!</span>")
		return

	if (istype(glasses, /obj/item/clothing/glasses/sunglasses/blindfold))
		to_chat(src, "<span class='warning'>You're blindfolded!</span>")
		return

	visible_message("<span class='danger'>[src.name]'s eyes emit a blinding flash!</span>")
	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(2))
		if (H == src)
			continue

		if (!vampire_can_affect_target(H, 0))
			continue

		H.Weaken(8)
		H.stuttering = 20
		to_chat(H, "<span class='danger'>You are blinded by [src]'s glare!</span>")
		flick("flash", H.flash)
		victims += H

	admin_attacker_log_many_victims(src, victims, "used glare to stun", "was stunned by [key_name(src)] using glare", "used glare to stun")

	verbs -= /mob/living/carbon/human/proc/vampire_glare
	ADD_VERB_IN_IF(src, 800, /mob/living/carbon/human/proc/vampire_glare, CALLBACK(src, .proc/finish_vamp_timeout))

// Targeted stun ability, moderate duration.
/mob/living/carbon/human/proc/vampire_hypnotise()
	set category = "Vampire"
	set name = "Hypnotise (10)"
	set desc = "Through blood magic, you dominate the victim's mind and force them into a hypnotic transe."

	var/datum/vampire/vampire = vampire_power(10, 1)
	if (!vampire)
		return

	if (!has_eyes())
		to_chat(src, "<span class='warning'>You don't have eyes!</span>")
		return

	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(3))
		if (H == src)
			continue
		victims += H

	if (!victims.len)
		to_chat(src, "<span class='warning'>No suitable targets.</span>")
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims

	if (!vampire_can_affect_target(T))
		return

	to_chat(src, "<span class='notice'>You begin peering into [T.name]'s mind, looking for a way to render them useless.</span>")

	if (do_mob(src, T, 50))
		to_chat(src, "<span class='danger'>You dominate [T.name]'s mind and render them temporarily powerless to resist.</span>")
		to_chat(T, "<span class='danger'>You are captivated by [src.name]'s gaze, and find yourself unable to move or even speak.</span>")
		T.Weaken(25)
		T.Stun(25)
		T.silent += 30

		vampire.use_blood(10)
		admin_attack_log(src, T, "used hypnotise to stun [key_name(T)]", "was stunned by [key_name(src)] using hypnotise", "used hypnotise on")

		verbs -= /mob/living/carbon/human/proc/vampire_hypnotise
		ADD_VERB_IN_IF(src, 1200, /mob/living/carbon/human/proc/vampire_hypnotise, CALLBACK(src, .proc/finish_vamp_timeout))
	else
		to_chat(src, "<span class='warning'>You broke your gaze.</span>")

// Targeted teleportation, must be to a low-light tile.
/mob/living/carbon/human/proc/vampire_veilstep(var/turf/T in world)
	set category = "Vampire"
	set name = "Veil Step (20)"
	set desc = "For a moment, move through the Veil and emerge at a shadow of your choice."

	if (!T || T.density || T.contains_dense_objects())
		to_chat(src, "<span class='warning'>You cannot do that.</span>")
		return

	var/datum/vampire/vampire = vampire_power(20, 1)
	if (!vampire)
		return

	if (!istype(loc, /turf))
		to_chat(src, "<span class='warning'>You cannot teleport out of your current location.</span>")
		return

	if (T.z != src.z || get_dist(T, get_turf(src)) > world.view)
		to_chat(src, "<span class='warning'>Your powers are not capable of taking you that far.</span>")
		return

	if (!T.dynamic_lighting || T.get_lumcount() > 0.1)
		// Too bright, cannot jump into.
		to_chat(src, "<span class='warning'>The destination is too bright.</span>")
		return

	vampire_phase_out(get_turf(loc))

	forceMove(T)

	vampire_phase_in(T)

	for (var/obj/item/weapon/grab/G in contents)
		if (G.affecting && (vampire.status & VAMP_FULLPOWER))
			G.affecting.vampire_phase_out(get_turf(G.affecting.loc))
			G.affecting.forceMove(locate(T.x + rand(-1,1), T.y + rand(-1,1), T.z))
			G.affecting.vampire_phase_in(get_turf(G.affecting.loc))
		else
			qdel(G)

	log_and_message_admins("activated veil step.")

	vampire.use_blood(20)
	verbs -= /mob/living/carbon/human/proc/vampire_veilstep
	ADD_VERB_IN_IF(src, 300, /mob/living/carbon/human/proc/vampire_veilstep, CALLBACK(src, .proc/finish_vamp_timeout))

// Summons bats.
/mob/living/carbon/human/proc/vampire_bats()
	set category = "Vampire"
	set name = "Summon Bats (60)"
	set desc = "You tear open the Veil for just a moment, in order to summon a pair of bats to assist you in combat."

	var/datum/vampire/vampire = vampire_power(60, 0)
	if (!vampire)
		return

	var/list/locs = list()

	for (var/direction in alldirs)
		if (locs.len == 2)
			break

		var/turf/T = get_step(src, direction)
		if (AStar(src.loc, T, /turf/proc/AdjacentTurfs, /turf/proc/Distance, 1))
			locs += T

	var/list/spawned = list()
	if (locs.len)
		for (var/turf/to_spawn in locs)
			spawned += new /mob/living/simple_animal/hostile/scarybat(to_spawn, src)

		if (spawned.len != 2)
			spawned += new /mob/living/simple_animal/hostile/scarybat(src.loc, src)
	else
		spawned += new /mob/living/simple_animal/hostile/scarybat(src.loc, src)
		spawned += new /mob/living/simple_animal/hostile/scarybat(src.loc, src)

	if (!spawned.len)
		return

	for (var/mob/living/simple_animal/hostile/scarybat/bat in spawned)
		LAZYADD(bat.friends, src)

		if (vampire.thralls.len)
			LAZYADD(bat.friends, vampire.thralls)

	log_and_message_admins("summoned bats.")

	vampire.use_blood(60)
	verbs -= /mob/living/carbon/human/proc/vampire_bats
	ADD_VERB_IN_IF(src, 1200, /mob/living/carbon/human/proc/vampire_bats, CALLBACK(src, .proc/finish_vamp_timeout))

// Chiropteran Screech
/mob/living/carbon/human/proc/vampire_screech()
	set category = "Vampire"
	set name = "Chiropteran Screech (90)"
	set desc = "Emit a powerful screech which shatters glass within a seven-tile radius, and stuns hearers in a four-tile radius."

	var/datum/vampire/vampire = vampire_power(90, 0)
	if (!vampire)
		return

	visible_message("<span class='danger'>[src.name] lets out an ear piercin shriek!</span>", "<span class='danger'>You let out an ear-shattering shriek!</span>", "<span class='danger'>You hear a painfully loud shriek!</span>")

	var/list/victims = list()

	for (var/mob/living/carbon/human/T in hearers(4, src))
		if (T == src)
			continue

		if (istype(T) && (T:l_ear || T:r_ear) && istype((T:l_ear || T:r_ear), /obj/item/clothing/ears/earmuffs))
			continue

		if (!vampire_can_affect_target(T, 0))
			continue

		to_chat(T, "<span class='danger'><font size='3'><b>You hear an ear piercing shriek and feel your senses go dull!</b></font></span>")
		T.Weaken(5)
		T.ear_deaf = 20
		T.stuttering = 20
		T.Stun(5)

		victims += T

	for (var/obj/structure/window/W in view(7))
		W.shatter()

	for (var/obj/machinery/light/L in view(7))
		L.broken()

	playsound(src.loc, 'sound/effects/creepyshriek.ogg', 100, 1)
	vampire.use_blood(90)

	if (victims.len)
		admin_attacker_log_many_victims(src, victims, "used chriopteran screech to stun", "was stunned by [key_name(src)] using chriopteran screech", "used chiropteran screech to stun")
	else
		log_and_message_admins("used chiropteran screech.")

	verbs -= /mob/living/carbon/human/proc/vampire_screech
	ADD_VERB_IN_IF(src, 3600, /mob/living/carbon/human/proc/vampire_screech, CALLBACK(src, .proc/finish_vamp_timeout))

// Heals the vampire at the cost of blood.
/mob/living/carbon/human/proc/vampire_bloodheal()
	set category = "Vampire"
	set name = "Blood Heal"
	set desc = "At the cost of blood and time, heal any injuries you have sustained."

	var/datum/vampire/vampire = vampire_power(0, 0)
	if (!vampire)
		return

	// Kick out of the already running loop.
	if (vampire.status & VAMP_HEALING)
		vampire.status &= ~VAMP_HEALING
		return
	else if (vampire.blood_usable < 15)
		to_chat(src, "<span class='warning'>You do not have enough usable blood. 15 needed.</span>")
		return

	vampire.status |= VAMP_HEALING
	to_chat(src, "<span class='notice'>You begin the process of blood healing. Do not move, and ensure that you are not interrupted.</span>")

	log_and_message_admins("activated blood heal.")

	while (do_after(src, 20, 5, 0))
		if (!(vampire.status & VAMP_HEALING))
			to_chat(src, "<span class='warning'>Your concentration is broken! You are no longer regenerating!</span>")
			break

		var/tox_loss = getToxLoss()
		var/oxy_loss = getOxyLoss()
		var/ext_loss = getBruteLoss() + getFireLoss()
		var/clone_loss = getCloneLoss()

		var/blood_used = 0
		var/to_heal = 0

		if (tox_loss)
			to_heal = min(10, tox_loss)
			adjustToxLoss(0 - to_heal)
			blood_used += round(to_heal * 1.2)
		if (oxy_loss)
			to_heal = min(10, oxy_loss)
			adjustOxyLoss(0 - to_heal)
			blood_used += round(to_heal * 1.2)
		if (ext_loss)
			to_heal = min(20, ext_loss)
			heal_overall_damage(min(10, getBruteLoss()), min(10, getFireLoss()))
			blood_used += round(to_heal * 1.2)
		if (clone_loss)
			to_heal = min(10, clone_loss)
			adjustCloneLoss(0 - to_heal)
			blood_used += round(to_heal * 1.2)

		var/list/organs = get_damaged_organs(1, 1)
		if (organs.len)
			// Heal an absurd amount, basically regenerate one organ.
			heal_organ_damage(50, 50)
			blood_used += 12

		var/list/emotes_lookers = list("[src]'s skin appears to liquefy for a moment, sealing up their wounds.",
									"[src]'s veins turn black as their damaged flesh regenerates before your eyes!",
									"[src]'s skin begins to split open. It turns to ash and falls away, revealing the wound to be fully healed.",
									"Whispering arcane things, [src]'s damaged flesh appears to regenerate.",
									"Thick globs of blood cover a wound on [src]'s body, eventually melding to be one with \his flesh.",
									"[src]'s body crackles, skin and bone shifting back into place.")
		var/list/emotes_self = list("Your skin appears to liquefy for a moment, sealing up your wounds.",
									"Your veins turn black as their damaged flesh regenerates before your eyes!",
									"Your skin begins to split open. It turns to ash and falls away, revealing the wound to be fully healed.",
									"Whispering arcane things, your damaged flesh appears to regenerate.",
									"Thick globs of blood cover a wound on your body, eventually melding to be one with your flesh.",
									"Your body crackles, skin and bone shifting back into place.")

		if (prob(20))
			visible_message("<span class='danger'>[pick(emotes_lookers)]</span>", "<span class='notice'>[pick(emotes_self)]</span>")

		if (vampire.blood_usable <= blood_used)
			vampire.blood_usable = 0
			vampire.status &= ~VAMP_HEALING
			to_chat(src, "<span class='warning'>You ran out of blood, and are unable to continue!</span>")
			break
		else if (!blood_used)
			vampire.status &= ~VAMP_HEALING
			to_chat(src, "<span class='notice'>Your body has finished healing. You are ready to continue.</span>")
			break

	// We broke out of the loop naturally. Gotta catch that.
	if (vampire.status & VAMP_HEALING)
		vampire.status &= ~VAMP_HEALING
		to_chat(src, "<span class='warning'>Your concentration is broken! You are no longer regenerating!</span>")

	return

// Dominate a victim, imbed a thought into their mind.
/mob/living/carbon/human/proc/vampire_dominate()
	set category = "Vampire"
	set name = "Dominate (25)"
	set desc = "Dominate the mind of a victim, make them obey your will."

	var/datum/vampire/vampire = vampire_power(25, 0)
	if (!vampire)
		return

	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(7))
		if (H == src)
			continue
		victims += H

	if (!victims.len)
		to_chat(src, "<span class='warning'>No suitable targets.</span>")
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims

	if (!vampire_can_affect_target(T, 1, 1))
		return

	if (!(vampire.status & VAMP_FULLPOWER))
		to_chat(src, "<span class='notice'>You begin peering into [T]'s mind, looking for a way to gain control.</span>")

		if (!do_mob(src, T, 50))
			to_chat(src, "<span class='warning'>Your concentration is broken!</span>")
			return

		to_chat(src, "<span class='notice'>You succeed in dominating [T]'s mind. They are yours to command.</span>")
	else
		to_chat(src, "<span class='notice'>You instantly dominate [T]'s mind, forcing them to obey your command.</span>")

	var/command = input(src, "Command your victim.", "Your command.") as text|null

	if (!command)
		to_chat(src, "<span class='alert'>Cancelled.</span>")
		return

	command = sanitizeSafe(command, extra = 0)

	admin_attack_log(src, T, "used dominate on [key_name(T)]", "was dominated by [key_name(src)]", "used dominate and issued the command of '[command]' to")

	show_browser(T, "<center>You feel a strong presence enter your mind. For a moment, you hear nothing but what it says, <b>and are compelled to follow its direction without question or hesitation:</b><br>[command]</center>", "window=vampiredominate")
	to_chat(src, "<span class='notice'>You command [T], and they will obey.</span>")
	emote("me", 1, "whispers.")

	vampire.use_blood(25)
	verbs -= /mob/living/carbon/human/proc/vampire_dominate
	ADD_VERB_IN_IF(src, 1800, /mob/living/carbon/human/proc/vampire_dominate, CALLBACK(src, .proc/finish_vamp_timeout))

// Enthralls a person, giving the vampire a mortal slave.
/mob/living/carbon/human/proc/vampire_enthrall()
	set category = "Vampire"
	set name = "Enthrall (150)"
	set desc = "Bind a mortal soul with a bloodbond to obey your every command."

	var/datum/vampire/vampire = vampire_power(150, 0)
	if (!vampire)
		return

	var/obj/item/weapon/grab/G = get_active_hand()
	if (!istype(G))
		to_chat(src, "<span class='warning'>You must be grabbing a victim in your active hand to enthrall them.</span>")
		return

	if (G.state == GRAB_PASSIVE || G.state == GRAB_UPGRADING)
		to_chat(src, "<span class='warning'>You must have the victim pinned to the ground to enthrall them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting
	if (!istype(T))
		to_chat(src, "<span class='warning'>[T] is not a creature you can enthrall.</span>")
		return

	if (!T.client || !T.mind)
		to_chat(src, "<span class='warning'>[T]'s mind is empty and useless. They cannot be forced into a blood bond.</span>")
		return

	if (vampire.status & VAMP_DRAINING)
		to_chat(src, "<span class='warning'>Your fangs are already sunk into a victim's neck!</span>")
		return

	visible_message("<span class='danger'>[src] tears the flesh on their wrist, and holds it up to [T]. In a gruesome display, [T] starts lapping up the blood that's oozing from the fresh wound.</span>", "<span class='warning'>You inflict a wound upon yourself, and force them to drink your blood, thus starting the conversion process.</span>")
	to_chat(T, "<span class='warning'>You feel an irresistable desire to drink the blood pooling out of [src]'s wound. Against your better judgement, you give in and start doing so.</span>")

	if (!do_mob(src, T, 50))
		visible_message("<span class='danger'>[src] yanks away their hand from [T]'s mouth as they're interrupted, the wound quickly sealing itself!</span>", "<span class='danger'>You are interrupted!</span>")
		return

	to_chat(T, "<span class='danger'>Your mind blanks as you finish feeding from [src]'s wrist.</span>")
	vampire_thrall.add_antagonist(T.mind, 1, 1, 0, 1, 1)

	T.mind.vampire.master = src
	vampire.thralls += T
	to_chat(T, "<span class='notice'>You have been forced into a blood bond by [T.mind.vampire.master], and are thus their thrall. While a thrall may feel a myriad of emotions towards their master, ranging from fear, to hate, to love; the supernatural bond between them still forces the thrall to obey their master, and to listen to the master's commands.<br><br>You must obey your master's orders, you must protect them, you cannot harm them.</span>")
	to_chat(src, "<span class='notice'>You have completed the thralling process. They are now your slave and will obey your commands.</span>")
	admin_attack_log(src, T, "enthralled [key_name(T)]", "was enthralled by [key_name(src)]", "successfully enthralled")

	vampire.use_blood(150)
	verbs -= /mob/living/carbon/human/proc/vampire_enthrall
	ADD_VERB_IN_IF(src, 2800, /mob/living/carbon/human/proc/vampire_enthrall, CALLBACK(src, .proc/finish_vamp_timeout))

// Gives a lethal disease to the target.
/mob/living/carbon/human/proc/vampire_diseasedtouch()
	set category = "Vampire"
	set name = "Diseased Touch (200)"
	set desc = "Infects the victim with corruption from the Veil, causing their organs to fail."

	var/datum/vampire/vampire = vampire_power(200, 0)
	if (!vampire)
		return

	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(1))
		if (H == src)
			continue
		victims += H

	if (!victims.len)
		to_chat(src, "<span class='warning'>No suitable targets.</span>")
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims

	if (!vampire_can_affect_target(T))
		return

	to_chat(src, "<span class='notice'>You infect [T] with a deadly disease. They will soon fade away.</span>")

	T.help_shake_act(src)

	var/datum/disease2/disease/lethal = new
	lethal.makerandom(3)
	lethal.infectionchance = 1
	lethal.stage = lethal.max_stage
	lethal.spreadtype = "None"

	infect_mob(T, lethal)

	admin_attack_log(src, T, "used diseased touch on [key_name(T)]", "was given a lethal disease by [key_name(src)]", "used diseased touch (<a href='?src=\ref[lethal];info=1'>virus info</a>) on")

	vampire.use_blood(200)
	verbs -= /mob/living/carbon/human/proc/vampire_diseasedtouch
	ADD_VERB_IN_IF(src, 1800, /mob/living/carbon/human/proc/vampire_diseasedtouch, CALLBACK(src, .proc/finish_vamp_timeout))

// Makes the vampire appear 'friendlier' to others.
/mob/living/carbon/human/proc/vampire_presence()
	set category = "Vampire"
	set name = "Presence (10)"
	set desc = "Influences those weak of mind to look at you in a friendlier light."

	var/datum/vampire/vampire = vampire_power(0, 0)
	if (!vampire)
		return

	if (vampire.status & VAMP_PRESENCE)
		vampire.status &= ~VAMP_PRESENCE
		to_chat(src, "<span class='warning'>You are no longer influencing those weak of mind.</span>")
		return
	else if (vampire.blood_usable < 15)
		to_chat(src, "<span class='warning'>You do not have enough usable blood. 15 needed.</span>")
		return

	to_chat(src, "<span class='notice'>You begin passively influencing the weak minded.</span>")
	vampire.status |= VAMP_PRESENCE

	var/list/mob/living/carbon/human/affected = list()
	var/list/emotes = list("[src] looks trusthworthy.",
							"You feel as if [src] is a relatively friendly individual.",
							"You feel yourself paying more attention to what [src] is saying.",
							"[src] has your best interests at heart, you can feel it.",
							"A quiet voice tells you that [src] should be considered a friend.")

	vampire.use_blood(10)

	log_and_message_admins("activated presence.")

	while (vampire.status & VAMP_PRESENCE)
		// Run every 20 seconds
		sleep(200)

		if (stat)
			to_chat(src, "<span class='warning'>You cannot influence people around you while [stat == 1 ? "unconcious" : "dead"].</span>")
			vampire.status &= ~VAMP_PRESENCE
			break

		for (var/mob/living/carbon/human/T in view(5))
			if (T == src)
				continue

			if (!vampire_can_affect_target(T, 0, 1))
				continue

			if (!T.client)
				continue

			var/probability = 50
			if (!(T in affected))
				affected += T
				probability = 80

			if (prob(probability))
				to_chat(T, "<font color='green'><i>[pick(emotes)]</i></font>")

		vampire.use_blood(5)

		if (vampire.blood_usable < 5)
			vampire.status &= ~VAMP_PRESENCE
			to_chat(src, "<span class='warning'>You are no longer influencing those weak of mind.</span>")
			break

// Convert a human into a vampire.
/mob/living/carbon/human/proc/vampire_embrace()
	set category = "Vampire"
	set name = "The Embrace"
	set desc = "Spread your corruption to an innocent soul, turning them into a spawn of the Veil, much akin to yourself."

	var/datum/vampire/vampire = vampire_power(0, 0)
	if (!vampire)
		return

	// Re-using blood drain code.
	var/obj/item/weapon/grab/G = get_active_hand()
	if (!istype(G))
		to_chat(src, "<span class='warning'>You must be grabbing a victim in your active hand to drain their blood.</span>")
		return

	if (G.state == GRAB_PASSIVE || G.state == GRAB_UPGRADING)
		to_chat(src, "<span class='warning'>You must have the victim pinned to the ground to drain their blood.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting
	if (!vampire_can_affect_target(T))
		return

	if (!T.client)
		to_chat(src, "<span class='warning'>[T] is a mindless husk. The Veil has no purpose for them.</span>")
		return

	if (T.stat == 2)
		to_chat(src, "<span class='warning'>[T]'s body is broken and damaged beyond salvation. You have no use for them.</span>")
		return

	if (vampire.status & VAMP_DRAINING)
		to_chat(src, "<span class='warning'>Your fangs are already sunk into a victim's neck!</span>")
		return

	if (T.mind.vampire)
		var/datum/vampire/draining_vamp = T.mind.vampire

		if (draining_vamp.status & VAMP_ISTHRALL)
			var/choice_text = ""
			var/denial_response = ""
			if (draining_vamp.master == src)
				choice_text = "[T] is your thrall. Do you wish to release them from the blood bond and give them the chance to become your equal?"
				denial_response = "You opt against giving [T] a chance to ascend, and choose to keep them as a servant."
			else
				choice_text = "You can feel the taint of another master running in the veins of [T]. Do you wish to release them of their blood bond, and convert them into a vampire, in spite of their master?"
				denial_response = "You choose not to continue with the Embrace, and permit [T] to keep serving their master."

			if (alert(src, choice_text, "Choices", "Yes", "No") == "No")
				to_chat(src, "<span class='notice'>[denial_response]</span>")
				return

			vampire_thrall.remove_antagonist(T.mind, 0, 0)
			qdel(draining_vamp)
			draining_vamp = null
		else
			to_chat(src, "<span class='warning'>You feel corruption running in [T]'s blood. Much like yourself, \he[T] is already a spawn of the Veil, and cannot be Embraced.</span>")
			return

	vampire.status |= VAMP_DRAINING

	visible_message("<span class='danger'>[src] bites [T]'s neck!</span>", "<span class='danger'>You bite [T]'s neck and begin to drain their blood, as the first step of introducing the corruption of the Veil to them.</span>", "<span class='notice'>You hear a soft puncture and a wet sucking noise.</span>")

	to_chat(T, "<span class='notice'><br>You are currently being turned into a vampire. You will die in the course of this, but you will be revived by the end. Please do not ghost out of your body until the process is complete.</span>")

	while (do_mob(src, T, 50))
		if (!mind.vampire)
			to_chat(src, "<span class='alert'>Your fangs have disappeared!</span>")
			return

		if (!T.vessel.get_reagent_amount("blood"))
			to_chat(src, "<span class='alert'>[T] is now drained of blood. You begin forcing your own blood into their body, spreading the corruption of the Veil to their body.</span>")
			break

		T.vessel.remove_reagent("blood", 50)

	T.revive()

	// You ain't goin' anywhere, bud.
	if (!T.client && T.mind)
		for (var/mob/dead/observer/ghost in player_list)
			if (ghost.mind == T.mind)
				ghost.can_reenter_corpse = 1
				ghost.reenter_corpse()

				to_chat(T, "<span class='danger'>A dark force pushes you back into your body. You find yourself somehow still clinging to life.</span>")

	T.Weaken(15)
	vamp.add_antagonist(T.mind, 1, 1, 0, 0, 1)

	admin_attack_log(src, T, "successfully embraced [key_name(T)]", "was successfully embraced by [key_name(src)]", "successfully embraced and turned into a vampire")

	to_chat(T, "<span class='danger'>You awaken. Moments ago, you were dead, your conciousness still forced stuck inside your body. Now you live. You feel different, a strange, dark force now present within you. You have an insatiable desire to drain the blood of mortals, and to grow in power.</span>")
	to_chat(src, "<span class='warning'>You have corrupted another mortal with the taint of the Veil. Beware: they will awaken hungry and maddened; not bound to any master.</span>")

	T.mind.vampire.blood_usable = 0
	T.mind.vampire.frenzy = 250
	T.vampire_check_frenzy()

	vampire.status &= ~VAMP_DRAINING

// Grapple a victim by leaping onto them.
/mob/living/carbon/human/proc/grapple()
	set category = "Vampire"
	set name = "Grapple"
	set desc = "Lunge towards a target like an animal, and grapple them."

	if (status_flags & LEAPING)
		return

	if (stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "<span class='warning'>You cannot lean in your current state.</span>")
		return

	var/list/targets = list()
	for (var/mob/living/carbon/human/H in view(4, src))
		targets += H

	targets -= src

	if (!targets.len)
		to_chat(src, "<span class='warning'>No valid targets visible or in range.</span>")
		return

	var/mob/living/carbon/human/T = pick(targets)

	visible_message("<span class='danger'>[src] leaps at [T]!</span>")
	throw_at(get_step(get_turf(T), get_turf(src)), 4, 1, src)

	status_flags |= LEAPING

	sleep(5)

	if (status_flags & LEAPING)
		status_flags &= ~LEAPING

	if (!src.Adjacent(T))
		to_chat(src, "<span class='warning'>You miss!</span>")
		return

	T.Weaken(3)

	admin_attack_log(src, T, "lept at and grappled [key_name(T)]", "was lept at and grappled by [key_name(src)]", "lept at and grappled")

	var/use_hand = "left"
	if (l_hand)
		if (r_hand)
			to_chat(src, "<span class='danger'>You need to have one hand free to grab someone.</span>")
			return
		else
			use_hand = "right"

	src.visible_message("<span class='warning'><b>\The [src]</b> seizes [T] aggressively!</span>")

	var/obj/item/weapon/grab/G = new(src, T)
	if (use_hand == "left")
		l_hand = G
	else
		r_hand = G

	G.state = GRAB_AGGRESSIVE
	G.icon_state = "grabbed1"
	G.synch()

	verbs -= /mob/living/carbon/human/proc/grapple
	ADD_VERB_IN_IF(src, 800, /mob/living/carbon/human/proc/grapple, CALLBACK(src, .proc/finish_vamp_timeout, VAMP_FRENZIED))
