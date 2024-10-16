/datum/power/changeling/panacea
	name = "Anatomic Panacea"
	desc = "Expels impurifications from our form; curing diseases, removing toxins, chemicals, radiation, and resetting our genetic code completely."
	helptext = "Can be used while unconscious.  This will also purge any reagents inside ourselves, both harmful and beneficial."
	enhancedtext = "We heal more toxins."
	ability_icon_state = "ling_anatomic_panacea"
	genomecost = 1
	verbpath = /mob/proc/changeling_panacea

//Heals the things that the other regenerative abilities don't.
/mob/proc/changeling_panacea()
	set category = "Changeling"
	set name = "Anatomic Panacea (20)"
	set desc = "Clense ourselves of impurities."

	var/datum/changeling/changeling = changeling_power(20,0,100,UNCONSCIOUS)
	if(!changeling)
		return FALSE
	src.mind.changeling.chem_charges -= 20

	to_chat(src, "<span class='notice'>We cleanse impurities from our form.</span>")

	var/mob/living/carbon/human/C = src

	C.radiation = 0
	C.sdisabilities = 0
	C.disabilities = 0
	C.reagents.clear_reagents()
	C.empty_stomach()


	var/heal_amount = 5
	if(src.mind.changeling.recursive_enhancement)
		src.mind.changeling.recursive_enhancement = FALSE
		heal_amount = heal_amount * 2
		to_chat(src, "<span class='notice'>We will heal much faster.</span>")


	for(var/obj/item/organ/external/E in C.organs)
		var/obj/item/organ/external/G = E
		if(G.germ_level)
			var/germ_heal = heal_amount * 100
			G.germ_level = min(0, G.germ_level - germ_heal)

	for(var/obj/item/organ/internal/I in C.internal_organs)
		var/obj/item/organ/internal/G = I
		if(G.germ_level)
			var/germ_heal = heal_amount * 100
			G.germ_level = min(0, G.germ_level - germ_heal)

	return TRUE
