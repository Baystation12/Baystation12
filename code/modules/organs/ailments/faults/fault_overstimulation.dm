/datum/ailment/fault/overstimulation
	name = "motor control overstimulation"

/datum/ailment/fault/overstimulation/on_ailment_event()
	organ.owner.emote("collapse")
	SET_STATUS_MAX(organ.owner, STAT_STUN, rand(2, 4))