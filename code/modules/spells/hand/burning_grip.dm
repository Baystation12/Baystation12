/spell/hand/burning_grip
	name = "Burning Grip"
	desc = "Cause someone to drop a held object by causing it to heat up intensly."
	school = "transmutation"
	feedback = "bg"
	range = 5
	spell_flags = 0
	invocation_type = SpI_NONE
	show_message = " throws sparks from their hands"
	spell_delay = 120
	hud_state = "wiz_burn"
	compatible_targets = list(/mob/living/carbon/human)

/spell/hand/burning_grip/valid_target(var/mob/living/L, var/mob/user)
	if(!..())
		return 0
	if(!L.l_hand && !L.r_hand)
		return 0
	return 1

/spell/hand/burning_grip/cast_hand(var/mob/living/carbon/human/H, var/mob/user)
	var/list/targets = list()
	if(H.l_hand)
		targets += BP_L_HAND
	if(H.r_hand)
		targets += BP_R_HAND

	for(var/organ in targets)
		var/obj/item/organ/external/E = H.get_organ(organ)
		E.take_damage(burn=10, used_weapon = "hot iron")
		if(E.can_feel_pain())
			H.grasp_damage_disarm(E)
		else
			E.take_damage(burn=6, used_weapon = "hot iron")
			to_chat(H, "<span class='warning'>You look down to notice that your [E] is burned.</span>")