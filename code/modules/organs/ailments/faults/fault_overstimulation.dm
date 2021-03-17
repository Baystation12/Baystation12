/datum/ailment/fault/overstimulation
	name = "motor control overstimulation"

/datum/ailment/fault/overstimulation/on_ailment_event()
	organ.owner.audible_message(SPAN_DANGER("[organ.owner]'s [organ.name] abruptly stops."), hearing_distance = 7)
	organ.owner.emote("collapse")
	organ.owner.Stun(rand(2, 4))