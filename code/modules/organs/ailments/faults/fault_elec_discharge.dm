/datum/ailment/fault/elec_discharge
	name = "electrical discharge"
	diagnosis_string = "$USER_HIS$ $ORGAN$ gives you a static shock when you touch it!"

/datum/ailment/fault/elec_discharge/on_ailment_event()
	organ.owner.custom_pain("Shock jolts through your [organ], staggering you!", 50, affecting = organ.owner)
	spark_at(get_turf(organ.owner))
	SET_STATUS_MAX(organ.owner, STAT_STUN, 2)
