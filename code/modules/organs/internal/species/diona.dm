/obj/item/organ/internal/diona
	name = "diona nymph"
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"
	organ_tag = "special" // Turns into a nymph instantly, no transplanting possible.

/obj/item/organ/internal/diona/removed(var/mob/living/user, var/skip_nymph)
	if(BP_IS_ROBOTIC(src))
		return ..()
	var/mob/living/carbon/human/H = owner
	..()
	if(istype(H) && !LAZYLEN(H.organs))
		H.death()
	if(prob(50) && !skip_nymph && spawn_diona_nymph(get_turf(src)))
		qdel(src)

/obj/item/organ/internal/diona/Process()
	return PROCESS_KILL

/obj/item/organ/internal/diona/strata
	name = "neural strata"
	parent_organ = BP_CHEST
	organ_tag = "neural strata"


/obj/item/organ/internal/diona/bladder
	name = "gas bladder"
	parent_organ = BP_HEAD
	organ_tag = "gas bladder"

/obj/item/organ/internal/diona/polyp
	name = "polyp segment"
	parent_organ = BP_GROIN
	organ_tag = "polyp segment"

/obj/item/organ/internal/diona/ligament
	name = "anchoring ligament"
	parent_organ = BP_GROIN
	organ_tag = "anchoring ligament"

/obj/item/organ/internal/diona/node
	name = "receptor node"
	parent_organ = BP_HEAD

/obj/item/organ/internal/diona/nutrients
	name = BP_NUTRIENT
	parent_organ = BP_CHEST

// These are different to the standard diona organs as they have a purpose in other
// species (absorbing radiation and light respectively)
/obj/item/organ/internal/diona/nutrients
	name = BP_NUTRIENT
	parent_organ = BP_CHEST
	organ_tag = BP_NUTRIENT
	icon = 'icons/obj/alien.dmi'
	icon_state = "claw"

/obj/item/organ/internal/diona/nutrients/removed(var/mob/user)
	return ..(user, 1)

/obj/item/organ/internal/diona/node
	name = "response node"
	parent_organ = BP_HEAD
	organ_tag = "response node"
	icon = 'icons/obj/alien.dmi'
	icon_state = "claw"

/obj/item/organ/internal/diona/node/Process()
	..()
	if(is_broken() || !owner)
		return
	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(owner.loc)) //else, there's considered to be no light
		var/turf/T = owner.loc
		light_amount = T.get_lumcount() * 10
	owner.set_nutrition(Clamp(owner.nutrition + light_amount, 0, 550))
	owner.shock_stage -= light_amount

/obj/item/organ/internal/diona/node/removed(var/mob/user)
	return ..(user, 1)
