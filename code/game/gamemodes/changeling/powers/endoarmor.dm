/datum/power/changeling/endoarmor
	name = "Endoarmor"
	desc = "We grow hard plating underneath our skin, granting us subtle armor organics will not notice."
	helptext = "The armor will not provide us any protection from lasers or fire."
	genomecost = 1
	isVerb = 0
	verbpath = /mob/proc/changeling_endoarmor

/mob/proc/changeling_endoarmor()
	if(ishuman(src))

		var/mob/living/carbon/human/H = src
		var/obj/item/organ/internal/augment/armor = new /obj/item/organ/internal/augment/armor/changeling
		//H.add_modifier(/datum/modifier/endoarmor)
		var/obj/item/organ/external/parent = H.get_organ(BP_CHEST)
		armor.forceMove(src)
		armor.replaced(src, parent)
		src.mind.changeling.purchased_organs.Add(armor)
		armor = null
		playsound(src, 'sound/effects/corpsecube.ogg',35,1)
		to_chat(src, SPAN_NOTICE("Our flesh knits and cracks as the endoarmor forms beneath our skin."))

	return TRUE
