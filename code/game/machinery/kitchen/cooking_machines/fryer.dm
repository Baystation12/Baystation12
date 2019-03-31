/obj/machinery/cooker/fryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon_state = "fryer_off"
	can_cook_mobs = 1
	cook_type = "deep fried"
	on_icon = "fryer_on"
	off_icon = "fryer_off"
	food_color = "#ffad33"
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

	var/target_zone = user.zone_sel.selecting
	if(ishuman(victim) && !(target_zone in list(BP_GROIN, BP_CHEST)))
		var/mob/living/carbon/human/H = victim
		var/obj/item/organ/external/E = H.get_organ(target_zone)
		if(!E)
			to_chat(user, "<span class='warning'>They are missing that body part!</span>")
		else
			visible_message("<span class='danger'>\The [user] shoves \the [victim][E ? "'s [E.name]" : ""] into \the [src]!</span>")
			H.apply_damage(rand(20,30), BURN, target_zone)

	else
		victim.apply_damage(rand(30,40), BURN)

	if(victim)
		admin_attack_log(user, victim, "Has [cook_type] their victim in \a [src]", "Has been [cook_type] in \a [src] by the attacker.", "[cook_type], in \a [src], ")

	icon_state = off_icon
	cooking = 0
	return
