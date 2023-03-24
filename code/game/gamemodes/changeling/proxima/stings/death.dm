/datum/stings/death
	name = "Death Sting (40)"
	desc = "Stops the heart - causes death."
	icon_state = "sting_death"
	chemical_cost = 40
	no_lesser = 1
	visible = 2

/datum/stings/death/sting_action(mob/user, mob/living/carbon/human/T)
	. = ..()
//	T.silent = 10
//	T.Paralyse(10)
//	T.make_jittery(40)
	var/obj/item/organ/external/target_limb = T.get_organ(user.zone_sel.selecting)
	if(!target_limb)
		to_chat(user, SPAN_WARNING("[T] is missing that limb."))
		return
	T.stun_effect_act(0, 65, target_limb, "large organic needle") // a small present
//	if(T.reagents)	T.reagents.add_reagent("cyanide", 5) // too op
//	if(T.reagents)	T.reagents.add_reagent(/datum/reagent/lexorin, 40) // too useless
	if(T.reagents)	T.reagents.add_reagent(/datum/reagent/toxin/batrachotoxin, 10) // fine(?)
