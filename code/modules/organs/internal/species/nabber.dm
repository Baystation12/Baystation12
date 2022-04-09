/obj/item/organ/internal/voicebox/nabber
	name = "vocal synthesiser"
	assists_languages = list(LANGUAGE_HUMAN_RUSSIAN, LANGUAGE_GUTTER, LANGUAGE_HUMAN_EURO, LANGUAGE_EAL)

/obj/item/organ/internal/voicebox/nabber/Initialize()
	. = ..()
	robotize()

/obj/item/organ/internal/eyes/insectoid/nabber
	name = "compound eyes"
	innate_flash_protection = FLASH_PROTECTION_VULNERABLE
	phoron_guard = 1
	action_button_name = "Toggle Eye Shields"
	eye_icon = 'icons/mob/human_races/species/nabber/eyes.dmi'
	var/eyes_shielded

/obj/item/organ/internal/eyes/insectoid/msq
	name = "compound eyes"
	eye_icon = 'icons/mob/human_races/species/nabber/msq/eyes.dmi'

/obj/item/organ/internal/eyes/insectoid/nabber/get_special_overlay()
	var/icon/I = get_onhead_icon()
	if(I)
		var/image/eye_overlay = image(I)
		if(owner && owner.is_cloaked())
			eye_overlay.alpha = 100
		if(eyes_shielded)
			eye_overlay.color = "#aaaaaa"
		return eye_overlay

/obj/item/organ/internal/eyes/insectoid/nabber/additional_flash_effects(var/intensity)
	if(!eyes_shielded)
		take_internal_damage(max(0, 4 * (intensity)))
		return 1
	else
		return -1

/obj/item/organ/internal/eyes/insectoid/nabber/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "nabber-shield-[eyes_shielded ? 1 : 0]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/internal/eyes/insectoid/nabber/attack_self(var/mob/user)
	. = ..()
	if(.)
		eyes_shielded = !eyes_shielded
		if(eyes_shielded)
			to_chat(owner, "<span class='notice'>Nearly opaque lenses slide down to shield your eyes.</span>")
			innate_flash_protection = FLASH_PROTECTION_MAJOR
			owner.overlay_fullscreen("eyeshield", /obj/screen/fullscreen/blind)
			owner.update_icons()
		else
			to_chat(owner, "<span class='notice'>Your protective lenses retract out of the way.</span>")
			innate_flash_protection = FLASH_PROTECTION_VULNERABLE
			addtimer(CALLBACK(src, .proc/remove_shield), 1 SECONDS)
			owner.update_icons()
		refresh_action_button()

/obj/item/organ/internal/eyes/insectoid/nabber/proc/remove_shield()
	owner.clear_fullscreen("eyeshield")

/obj/item/organ/internal/eyes/nabber/New(var/mob/living/carbon/holder)
	. = ..()
	if(dna)
		color = rgb(dna.GetUIValue(DNA_UI_EYES_R), dna.GetUIValue(DNA_UI_EYES_G), dna.GetUIValue(DNA_UI_EYES_B))

/obj/item/organ/internal/eyes/insectoid/nabber/set_dna(var/datum/dna/new_dna)
	. = ..()
	color = rgb(new_dna.GetUIValue(DNA_UI_EYES_R), new_dna.GetUIValue(DNA_UI_EYES_G), new_dna.GetUIValue(DNA_UI_EYES_B))

/obj/item/organ/internal/phoron
	name = "phoron storage"
	icon_state = "stomach"
	color = "#ed81f1"
	organ_tag = BP_PHORON
	parent_organ = BP_CHEST
	can_be_printed = FALSE
	var/dexalin_level = 10
	var/phoron_level = 5
	var/raw_amount = 0.1

/obj/item/organ/internal/phoron/Process()
	if(owner)
		var/amount = raw_amount
		if(is_broken())
			amount *= 0.5
		else if(is_bruised())
			amount *= 0.8

		var/phoron_volume_raw = owner.reagents.get_reagent_amount(/datum/reagent/toxin/phoron)

		if(phoron_volume_raw < phoron_level || !phoron_volume_raw)
			owner.reagents.add_reagent(/datum/reagent/toxin/phoron, amount)
	..()

/obj/item/organ/internal/phoron/can_recover()
	return TRUE

/obj/item/organ/internal/liver/insectoid/nabber
	name = "toxin filter"
	color = "#66ff99"
	organ_tag = BP_LIVER
	parent_organ = BP_CHEST

/obj/item/organ/internal/acetone
	name = "acetone reactor"
	icon_state = "vox lung"
	color = "#ff6699"
	organ_tag = BP_ACETONE
	parent_organ = BP_GROIN
	var/dexalin_level = 12
	var/acetone_level = 20
	var/raw_amount = 0.8

/obj/item/organ/internal/acetone/Process()
	..()
	if(!owner)
		return

	var/blood_level = owner.get_blood_circulation()
	var/amount = raw_amount * (blood_level / 100)
	if(is_broken())
		amount *= 0.5
	else if(is_bruised())
		amount *= 0.8

	// If there's barely any blood, can't properly make dexalin
	if(blood_level < BLOOD_VOLUME_SURVIVE && prob(50))
		return

	var/dexalin_volume_raw = owner.reagents.get_reagent_amount(/datum/reagent/dexalin)
	var/acetone_volume_raw = owner.reagents.get_reagent_amount(/datum/reagent/acetone)
	var/breath_fail_ratio = 1
	var/obj/item/organ/internal/lungs/insectoid/nabber/totally_not_lungs_I_swear = owner.internal_organs_by_name[BP_TRACH]
	if(totally_not_lungs_I_swear)
		breath_fail_ratio = totally_not_lungs_I_swear.breath_fail_ratio
	if((dexalin_volume_raw < dexalin_level * (blood_level / 100) || !dexalin_volume_raw) && (acetone_volume_raw < acetone_level || !acetone_volume_raw) && breath_fail_ratio < 0.25)
		owner.reagents.add_reagent(/datum/reagent/acetone, amount)

// These are not actually lungs and shouldn't be thought of as such despite the claims of the parent.
/obj/item/organ/internal/lungs/insectoid/nabber
	name = "tracheae"
	gender = PLURAL
	organ_tag = BP_TRACH
	parent_organ = BP_GROIN
	active_breathing = 0
	safe_toxins_max = 10

/obj/item/organ/internal/lungs/insectoid/nabber/rupture()
	to_chat(owner, "<span class='danger'>You feel air rushing through your trachea!</span>")

/obj/item/organ/internal/lungs/insectoid/nabber/handle_failed_breath()
	var/mob/living/carbon/human/H = owner

	H.adjustOxyLoss(-(HUMAN_MAX_OXYLOSS * owner.chem_effects[CE_OXYGENATED]))

	if(breath_fail_ratio < 0.25 && owner.chem_effects[CE_OXYGENATED])
		H.oxygen_alert = 0
	if(breath_fail_ratio >= 0.25 && (damage || world.time > last_successful_breath + 2 MINUTES))
		H.adjustOxyLoss(HUMAN_MAX_OXYLOSS * breath_fail_ratio)
		if(owner.chem_effects[CE_OXYGENATED])
			H.oxygen_alert = 1
		else
			H.oxygen_alert = 2

/obj/item/organ/internal/brain/insectoid/nabber
	var/lowblood_tally = 0
	name = "distributed nervous system"
	parent_organ = BP_CHEST

/obj/item/organ/internal/brain/insectoid/nabber/Process()
	if(!owner || !owner.should_have_organ(BP_HEART))
		return

	var/blood_volume = owner.get_blood_circulation()

	//Effects of bloodloss
	switch(blood_volume)
		if (BLOOD_VOLUME_FULL)
			lowblood_tally = 0
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			lowblood_tally = 2
			if(prob(1))
				to_chat(owner, "<span class='warning'>You're finding it difficult to move.</span>")
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			lowblood_tally = 4
			if(prob(1))
				to_chat(owner, "<span class='warning'>Moving has become very difficult.</span>")
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			lowblood_tally = 6
			if(prob(15))
				to_chat(owner, "<span class='warning'>You're almost unable to move!</span>")
				if(!owner.pulling_punches)
					var/datum/species/nabber/nab = species
					nab.arm_swap(owner, TRUE)
		if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
			lowblood_tally = 10
			if(prob(30) && !owner.pulling_punches)
				var/datum/species/nabber/nab = species
				nab.arm_swap(owner, TRUE)
			if(prob(10))
				to_chat(owner, "<span class='warning'>Your body is barely functioning and is starting to shut down.</span>")
				owner.Paralyse(1)
				var/obj/item/organ/internal/I = pick(owner.internal_organs)
				I.take_internal_damage(5)
	..()
