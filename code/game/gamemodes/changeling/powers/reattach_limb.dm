//Change this to just regrowing it honestly
/datum/power/changeling/reattach_limb
	name = "Regrow Limb"
	desc = "We reform a lost or damaged appendage."
	helptext = "To select the body part to regrow, target the area on the health doll and click the ability."
	ability_icon_state = "ling_sting_extract"
	genomecost = 1
	power_category = CHANGELING_POWER_INHERENT
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_reattach_limb

/mob/proc/changeling_reattach_limb()
	set category = "Changeling"
	set name = "Regrow Limb (25)"
	set desc="Regrow a limb that we have lost."

	var/datum/changeling/changeling = changeling_power(25,0,100,CONSCIOUS)
	if(src.mind && src.mind.changeling)
		changeling = src.mind.changeling
	if(!changeling || (src.mind.changeling.chem_charges < 25))
		//to_chat(src,SPAN_WARNING("We require at least 25 chemicals to regenerate a limb!"))
		return FALSE

	var/mob/living/carbon/human/C = src
	//zone_sel.selecting gets string
	var/obj/item/organ/external/target_limb = C.zone_sel.selecting
	var/list/organ_data = C.species.has_limbs[target_limb]
	var/obj/item/organ/external/limb_path = organ_data["path"]
	var/obj/item/organ/external/current_limb = C.get_organ(C.zone_sel.selecting)
	if((current_limb.organ_tag == BP_HEAD) || (current_limb.organ_tag == BP_CHEST))
		to_chat(C,SPAN_WARNING("That part of our body is too complex for us to simply regrow. We must enter hibernating stasis to regrow it."))
		return FALSE
	if (!current_limb || current_limb.is_stump())
		var/obj/item/organ/external/regrown_limb = new limb_path(C)
		var/obj/item/organ/external/parent_limb = (C.get_organ(regrown_limb.parent_organ))
		if(!parent_limb || parent_limb.is_stump())
			to_chat(C,SPAN_WARNING("We cannot regrow this limb without regrowing the limb it attaches to first!"))
			qdel(regrown_limb)
			return
		if(current_limb)
			qdel(current_limb)
		regrown_limb.replaced(C)
		regrown_limb.forceMove(C)
		regrown_limb = null
		C.update_body()
		C.updatehealth()
		C.UpdateDamageIcon()
		C.visible_message(SPAN_DANGER("\The [C] regenerates the tissue of their limb with a sickening squelch!"))
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
		changeling.chem_charges -= 25
	else
		current_limb.rejuvenate(ignore_prosthetic_prefs = FALSE)
		C.update_body()
		C.updatehealth()
		C.UpdateDamageIcon()
		C.visible_message(SPAN_DANGER("\The [C] regenerates the tissue of their limb with a sickening squelch!"))
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
		changeling.chem_charges -= 25



	if(!C)
		return




	return TRUE
