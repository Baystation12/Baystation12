/datum/ailment/fault/leaky
	name = "leaky prosthetic"
	diagnosis_string = "$USER_HIS$ $ORGAN$ is leaking some kind of chemical."
	var/global/list/chemicals = list(
		/datum/reagent/coolant,
		/datum/reagent/oil,
		/datum/reagent/nanitefluid
	)

/datum/ailment/fault/leaky/on_ailment_event()
	var/reagent = pick(chemicals)
	var/datum/reagents/bloodstr_reagents = organ.owner.reagents.get_reagent_amount()
	if(bloodstr_reagents)
		bloodstr_reagents.add_reagent(reagent, rand(1, 3))
