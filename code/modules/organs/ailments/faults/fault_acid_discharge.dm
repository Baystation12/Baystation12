/datum/ailment/fault/acid
	name = "acidic discharge"
	diagnosis_string = "$USER_HIS$ $ORGAN$ is leaking some kind of chemical."

/datum/ailment/fault/acid/on_ailment_event()
	organ.owner.custom_pain("A burning sensation spreads through your [organ].", 5, affecting = organ.owner)
	var/datum/reagents/metabolism/bloodstr_reagents = organ.owner.get_reagent_amount()
	if(bloodstr_reagents)
		bloodstr_reagents.add_reagent(/datum/reagent/acid, rand(1, 3))