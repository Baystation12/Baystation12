/*
	Helper proc and basic phenomena
*/

/mob/living/deity
	var/static/list/punishment_list = list("Pain (0)" = 0, "Light Wound (5)" = 5, "Brain Damage (10)" = 10, "Heavy Wounds (20)" = 20)

/mob/living/deity/proc/can_use_phenomena(var/cost, var/mob/living/target, var/use_on_follower = 0, var/check_location = 1)
	if(!target)
		to_chat(src, "<span class='warning'>You require a target to do that!</span>")
		return 0

	if(!form)
		to_chat(src, "<span class='warning'>You must choose a form before doing that!</span>")
		return 0

	if(target == src)
		to_chat(src, "<span class='warning'>You can't do that to yourself!</span>")
		return 0

	if(mob_uplink.uses < cost)
		to_chat(src, "<span class='warning'>You do not have enough faith to do that.</span>")
		return 0

	if(is_follower(target,silent=1) != use_on_follower)
		to_chat(src, "<span class='warning'>You cannot use this phenomena on \the [target].</span>")
		return 0

	if(!target.mind || !target.client)
		to_chat(src, "<span class='warning'>\The [target]'s mind is too mundane for you to control.</span>")
		return 0

	if(!check_location || near_structure(target))
		take_cost(cost)
		return 1

	to_chat(src, "<span class='warning'>\The [target] is too far from a holy structure to be within your influence.</span>")
	return 0

/mob/living/deity/proc/take_cost(var/amount)
	if(amount)
		nanomanager.update_uis(mob_uplink)
		mob_uplink.uses -= amount
		mob_uplink.used_TC += amount

/mob/living/deity/verb/conversion(var/mob/living/L)
	set name = "Conversion (20)"
	set desc = "Spend a paltry amount of power to convert someone. This can fail."
	set category = "Phenomena"

	if(!can_use_phenomena(20,L))
		return

	to_chat(src,"<span class='notice'>You give \the [L] a chance to willingly convert. May they choose wisely.</span>")
	var/choice = alert(L, "You feel a weak power enter your mind attempting to convert it.", "Conversion", "Allow Conversion", "Deny Conversion")
	if(choice == "Allow Conversion")
		godcult.add_antagonist_mind(L.mind,1,"a servant of [src]. You willingly give your mind to it, may it bring you fortune", "Servant of [src]", specific_god=src)
	else
		to_chat(L, "<span class='warning'>With little difficulty you force the intrusion out of your mind. May it stay that way.</span>")
		to_chat(src, "<span class='warning'>\The [L] decides not to convert.</span>")

/mob/living/deity/verb/conversion_forced(var/mob/living/L)
	set name = "Conversion - Forced (50)"
	set desc = "Force your power into someone's mind. Requires them to be on a place of power."
	set category = "Phenomena"

	if(!can_use_phenomena(50,L, check_location = 0))
		return


	var/turf/T = get_turf(L)

	var/obj/structure/deity/altar/A = locate() in T
	if(!A || !A.linked_god != src)
		var/list/V = form.struct_vars[/obj/structure/deity/altar]
		to_chat(src,"<span class='warning'>They need to be on a [V["name"]] to be forced to convert!</span>")

	A.set_target(L)
	to_chat(src, "<span class='notice'>You embue \the [A] with your power, setting forth to force \the [L] to your will.</span>")

/mob/living/deity/verb/punish(var/mob/living/L)
	set name = "Punish Follower (0-20)"
	set desc = "Punish an unruly follower with pain unimaginable. Cost depends on the damage inflicted."
	set category = "Phenomena"

	var/pain = input(src, "Choose their punishment.", "Punishment") as anything in punishment_list
	if(!can_use_phenomena(punishment_list[pain], L, 1, 0))
		return

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

/mob/living/deity/verb/direct_communication(var/mob/living/L)
	set name = "Communicate (0)"
	set category = "Phenomena"

	if(!is_follower(L))
		return

	var/text_to_send = sanitize(input(src, "Subjugate a member to your will", "Message a Believer") as text)
	if(text_to_send)
		to_chat(L, "<span class='cult'><font size='4'>[text_to_send]</font></span>") //Note to self: make this go to ghosties