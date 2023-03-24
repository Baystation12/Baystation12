/datum/stings/pain
	name = "Pain Sting (30)"
	desc = "Sting target"
	icon_state = "sting_mute"
	chemical_cost = 30
	no_lesser = 1
	visible = 2

/datum/stings/pain/sting_action(mob/user, mob/living/carbon/human/T)
	. = ..()
	var/obj/item/organ/external/target_limb = T.get_organ(user.zone_sel.selecting)
	if(!target_limb)
		to_chat(user, SPAN_WARNING("[T] is missing that limb."))
		return
	T.stun_effect_act(0, 150, target_limb, "large organic needle") //in stinged organ
	T.stun_effect_act(0, 150, null, "large organic needle") //in random organ
	to_chat(T, SPAN_DANGER("Your muscles begin to painfully tighten!"))
	T.agony_scream()
//	T.Weaken(20)
