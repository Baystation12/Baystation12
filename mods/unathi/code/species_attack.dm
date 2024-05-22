#define VENOM_ON_ATTACK_LOWER_TRESHOLD	0.875

/datum/unarmed_attack/bite/venom/yeosa
	var/poison_per_bite = 8
	var/poison_type = /datum/reagent/toxin/yeosvenom
	attack_verb = list("bit", "sank their fangs into")
	attack_sound = 'sound/weapons/bite.ogg'
	attack_name = "venomous bite"
	damage = 1
	delay = 3 SECONDS

/datum/unarmed_attack/bite/venom/yeosa/apply_effects(mob/living/carbon/human/user, mob/living/carbon/human/target, armour, attack_damage, zone)
	..()
	if(istype(src) && target && ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/clothing/suit/space/S = H.get_covering_equipped_item_by_zone(zone)
		if(istype(S) && !length(S.breaches))
			return
		if(target.reagents)
			target.reagents.add_reagent(src.poison_type, rand(VENOM_ON_ATTACK_LOWER_TRESHOLD * src.poison_per_bite, src.poison_per_bite))
			if(prob(src.poison_per_bite))
				to_chat(H, SPAN_WARNING("You feel a tiny prick."))

/datum/unarmed_attack/bite/venom/yeosa/get_damage_type()
	return DAMAGE_BRUTE

#undef VENOM_ON_ATTACK_LOWER_TRESHOLD
