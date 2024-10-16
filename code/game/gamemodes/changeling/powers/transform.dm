/datum/power/changeling/transform
	name = "Transform"
	desc = "We take on the appearance and voice of one we have absorbed."
	ability_icon_state = "ling_transform"
	genomecost = 0
	power_category = CHANGELING_POWER_INHERENT
	verbpath = /mob/proc/changeling_transform
/mob/proc/transform_cooldown()
	src.verbs += /mob/proc/changeling_transform
	src.regenerate_icons()
	src.update_hud()
//Change our DNA to that of somebody we've absorbed.
/mob/proc/changeling_transform()
	set category = "Changeling"
	set name = "Transform (5)"

	var/datum/changeling/changeling = changeling_power(5,1,0)
	if(!changeling)	return

	if(!isturf(loc) || !(/mob/proc/changeling_transform in src.verbs))
		to_chat(src, "<span class='warning'>Transforming here would be a bad idea.</span>")
		return 0

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		names += "[DNA.name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)	return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	changeling.chem_charges -= 5
	src.visible_message("<span class='warning'>[src] transforms!</span>")
	changeling.geneticdamage = 5

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/newSpecies = chosen_dna.speciesName
		H.set_species(newSpecies,1)
		H.ability_master.toggle_open(forced_state = 2)
		for(var/obj/item/organ/internal/augment/ling_organ in H.mind.changeling.purchased_organs)
			var/obj/item/organ/external/parent = H.get_organ(BP_CHEST)
			ling_organ.forceMove(src)
			ling_organ.replaced(src, parent)
			ling_organ = null
	src.dna.b_type = "AB+" //This is needed to avoid blood rejection bugs.  The fact that the blood type might not match up w/ records could be a *FEATURE* too.
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.dna = chosen_dna.dna.Clone()
		H.b_type = "AB+" //For some reason we have two blood types on the mob.
		H.gender = chosen_dna.gender
		H.pronouns = chosen_dna.pronouns
		H.flavor_texts = chosen_dna.flavour_texts ? chosen_dna.flavour_texts.Copy() : null
		if(H.descriptors)
			H.descriptors = chosen_dna.descriptors.Copy()
		H.sync_organ_dna()
		H.icon_render_keys = chosen_dna.icon_render_details
	src.real_name = chosen_dna.name
	domutcheck(src, null)

	src.UpdateAppearance()

	changeling_update_languages(changeling.absorbed_languages)

	src.verbs -= /mob/proc/changeling_transform
	addtimer(new Callback(src,/mob/.proc/transform_cooldown), 10 SECONDS)
