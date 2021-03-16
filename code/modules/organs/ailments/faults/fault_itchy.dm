/datum/ailment/fault/itchy
	name = "itchy prosthetic"

/datum/ailment/fault/itchy/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Something inside your [organ.name] itches badly!"))