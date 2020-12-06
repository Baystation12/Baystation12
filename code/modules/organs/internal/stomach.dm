/obj/item/organ/internal/stomach
	name = "stomach"
	desc = "Gross. This is hard to stomach."
	icon_state = "stomach"
	dead_icon = "stomach"
	organ_tag = BP_STOMACH
	parent_organ = BP_GROIN
	var/datum/reagents/metabolism/ingested
	var/next_cramp = 0

/obj/item/organ/internal/stomach/Destroy()
	QDEL_NULL(ingested)
	. = ..()

/obj/item/organ/internal/stomach/New()
	..()
	ingested = new/datum/reagents/metabolism(240, owner, CHEM_INGEST)
	if(!ingested.my_atom) ingested.my_atom = src

/obj/item/organ/internal/stomach/removed()
	. = ..()
	ingested.my_atom = src
	ingested.parent = null

/obj/item/organ/internal/stomach/replaced()
	. = ..()
	ingested.my_atom = owner
	ingested.parent = owner

/obj/item/organ/internal/stomach/Process()

	..()

	if(owner)
		if(damage >= min_broken_damage || (damage >= min_bruised_damage && prob(damage)))
			if(world.time >= next_cramp)
				next_cramp = world.time + rand(200,800)
				owner.custom_pain("Your stomach cramps agonizingly!",1)
		else
			ingested.metabolize()

		var/alcohol_threshold_met = (ingested.get_reagent_amount(/datum/reagent/ethanol) > 60)
		if(alcohol_threshold_met && (owner.disabilities & EPILEPSY) && prob(20))
			owner.seizure()

		if(ingested.total_volume > 60 || ((alcohol_threshold_met || ingested.total_volume > 35) && prob(15)))
			owner.vomit()