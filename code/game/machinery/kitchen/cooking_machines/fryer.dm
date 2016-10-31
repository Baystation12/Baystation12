/obj/machinery/cooker/fryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon_state = "fryer_off"
	can_cook_mobs = 1
	cook_type = "deep fried"
	on_icon = "fryer_on"
	off_icon = "fryer_off"
	food_color = "#FFAD33"
	cooked_sound = 'sound/machines/ding.ogg'

/obj/machinery/cooker/fryer/cook_mob(var/mob/living/victim, var/mob/user)

	if(!istype(victim))
		return

	user.visible_message("<span class='danger'>\The [user] starts pushing \the [victim] into \the [src]!</span>")
	icon_state = on_icon
	cooking = 1

	if(!do_mob(user, victim, 20))
		cooking = 0
		icon_state = off_icon
		return

	if(!victim || !victim.Adjacent(user))
		to_chat(user, "<span class='danger'>Your victim slipped free!</span>")
		cooking = 0
		icon_state = off_icon
		return

	var/obj/item/organ/external/E
	var/nopain
	if(ishuman(victim) && user.zone_sel.selecting != BP_GROIN && user.zone_sel.selecting != BP_CHEST)
		var/mob/living/carbon/human/H = victim
		E = H.get_organ(user.zone_sel.selecting)
		if(!E || !E.can_feel_pain())
			nopain = 2
		else if(E.robotic >= ORGAN_ROBOT)
			nopain = 1

	user.visible_message("<span class='danger'>\The [user] shoves \the [victim][E ? "'s [E.name]" : ""] into \the [src]!</span>")

	if(E)
		E.take_damage(0, rand(20,30))
		if(E.children && E.children.len)
			for(var/obj/item/organ/external/child in E.children)
				if(nopain && nopain < 2 && !(child.robotic >= ORGAN_ROBOT))
					nopain = 0
				child.take_damage(0, rand(20,30))
	else
		victim.apply_damage(rand(30,40), BURN, user.zone_sel.selecting)

	if(!nopain)
		to_chat(victim, "<span class='danger'>Agony consumes you as searing hot oil scorches your [E ? E.name : "flesh"] horribly!</span>")
		victim.emote("scream")
	else
		to_chat(victim, "<span class='danger'>Searing hot oil scorches your [E ? E.name : "flesh"]!</span>")
	if(victim)
		admin_attack_log("Has [cook_type] their victim in \a [src]", "Has been [cook_type] in \a [src] by the attacker.", "[cook_type], in \a [src], ")

	icon_state = off_icon
	cooking = 0
	return
