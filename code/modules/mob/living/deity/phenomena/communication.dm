/datum/phenomena/communicate
	name = "Direct Communication"
	cost = 0
	flags = PHENOMENA_FOLLOWER
	expected_type = /mob/living

/datum/phenomena/communicate/activate(var/mob/living/L)
	var/text_to_send = sanitize(input(linked, "Subjugate a member to your will", "Message a Believer") as text)
	if(text_to_send)
		to_chat(L, "<span class='cult'><font size='4'>[text_to_send]</font></span>") //Note to self: make this go to ghosties
		to_chat(linked, "<span class='notice'>You send the message [text_to_send] to \the [L]</span>")
		log_and_message_admins("communicated the message \"[text_to_send]\" to [key_name(L)]", linked)

/datum/phenomena/point
	name = "Point"
	cost = 0
	flags = PHENOMENA_MUNDANE|PHENOMENA_FOLLOWER|PHENOMENA_NONFOLLOWER
	expected_type = /atom
	var/image/arrow

/datum/phenomena/point/activate(var/atom/a)
	..()
	if(!arrow)
		arrow = image('icons/mob/screen1.dmi', icon_state = "arrow", layer = POINTER_LAYER)
	var/turf/T = get_turf(a)
	arrow.loc = T
	var/list/view = view(7,T)
	for(var/m in linked.minions)
		var/datum/mind/mind = m
		if(mind.current)
			var/mob/M = mind.current
			if((M in view) && M.client)
				to_chat(M, "<span class='cult'>Your attention is eerily drawn to \the [a].</span>")
				M.client.images += arrow
				GLOB.logged_out_event.register(M, src, /datum/phenomena/point/proc/remove_image)
				spawn(20)
					if(M.client)
						remove_image(M)

/datum/phenomena/point/proc/remove_image(var/mob/living/L)
	L.client.images -= arrow
	GLOB.logged_out_event.unregister(L, src)

/datum/phenomena/punish
	name = "Punish"
	cost = 0
	flags = PHENOMENA_FOLLOWER
	expected_type = /mob/living
	var/static/list/punishment_list = list("Pain (0)" = 0, "Light Wound (5)" = 5, "Brain Damage (10)" = 10, "Heavy Wounds (20)" = 20)

/datum/phenomena/punish/activate(var/mob/living/L)
	var/pain = input(linked, "Choose their punishment.", "Punishment") as anything in punishment_list
	if(!pain)
		return
	if(linked.mob_uplink.uses < punishment_list[pain])
		to_chat(linked, "<span class='warning'>[pain] costs too much power for you to use on \the [L]</span>")
		return
	..()
	linked.take_cost(punishment_list[pain])
	switch(pain)
		if("Pain (0)")
			L.adjustHalLoss(15)
			to_chat(L, "<span class='warning'>You feel intense disappointment coming at you from beyond the veil.</span>")
		if("Light Wound (5)")
			L.adjustBruteLoss(5)
			to_chat(L, "<span class='warning'>You feel an ethereal whip graze your very soul!</span>")
		if("Brain Damage (10)")
			L.adjustBrainLoss(5)
			to_chat(L, "<span class='danger'>You feel your mind breaking under a otherwordly hammer...</span>")
		if("Heavy Wounds (20)")
			L.adjustBruteLoss(25)
			to_chat(L, "<span class='danger'>You feel your master turn its destructive potential against you!</span>")
	to_chat(linked, "<span class='notice'>You punish \the [L].</span>")
	log_admin("[key_name(linked)] used Punishment [pain] on \the [key_name(L)]")