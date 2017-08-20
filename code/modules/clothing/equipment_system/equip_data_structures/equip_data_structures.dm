/mob/living/carbon/human
	var/obj/item/clothing/list/equipped = list()

/mob/living/carbon/human/proc/get_outermost_equip_interfere(var/obj/item/clothing/to_equip)
	var/obj/item/organ/external/list/affected_organs = list()

	for(var/obj/item/clothing/C in equipped)
		var/testvat = 2

/mob/living/carbon/human/proc/get_organs_worn_on(var/obj/item/clothing/to_check)
	var/testvar = 2