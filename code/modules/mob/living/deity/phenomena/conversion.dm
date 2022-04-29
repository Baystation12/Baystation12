/datum/phenomena/conversion
	name = "Conversion"
	desc = "Ask a non-follower to convert to your cult. This is completely voluntary. Requires the subject to be close to an altar."
	cost = 20
	flags = PHENOMENA_NONFOLLOWER
	expected_type = /mob/living

/datum/phenomena/conversion/can_activate(atom/target)
	if(!..())
		return 0
	var/is_good = 0
	for(var/obj/structure/deity/altar/A in linked.structures)
		if(get_dist(target, A) < 2)
			is_good = 1
			break
	if(!is_good)
		to_chat(linked,SPAN_WARNING("\The [target] needs to be near \a [linked.get_type_name(/obj/structure/deity/altar)]."))
		return 0
	return 1

/datum/phenomena/conversion/activate(mob/living/L)
	to_chat(src,SPAN_NOTICE("You give \the [L] a chance to willingly convert. May they choose wisely."))
	var/choice = alert(L, "You feel a weak power enter your mind attempting to convert it.", "Conversion", "Allow Conversion", "Deny Conversion")
	if(choice == "Allow Conversion")
		GLOB.godcult.add_antagonist_mind(L.mind,1, "Servant of [linked]", "You willingly give your mind to it, may it bring you fortune", specific_god=linked)
	else
		to_chat(L, SPAN_WARNING("With little difficulty you force the intrusion out of your mind. May it stay that way."))
		to_chat(src, SPAN_WARNING("\The [L] decides not to convert."))

/datum/phenomena/forced_conversion
	name = "Forced Conversion"
	desc = "Force a non-follower to join you. They need to be on top of an altar and conscious for this to work. They may resist, but that will hurt them."
	cost = 100
	flags = PHENOMENA_NONFOLLOWER
	expected_type = /mob/living

/datum/phenomena/forced_conversion/can_activate(mob/living/L)
	if(!..())
		return FALSE
	var/obj/structure/deity/altar/A = locate() in get_turf(L)
	if(!A || A.linked_god != linked)
		to_chat(linked,SPAN_WARNING("\The [L] needs to be on \a [linked.get_type_name(/obj/structure/deity/altar)] to be forcefully converted.."))
		return FALSE

	return TRUE

/datum/phenomena/forced_conversion/activate(mob/living/L)
	var/obj/structure/deity/altar/A = locate() in get_turf(L)
	A.set_target(L)
	to_chat(linked, SPAN_NOTICE("You imbue \the [A] with your power, setting forth to force \the [L] to your will."))
