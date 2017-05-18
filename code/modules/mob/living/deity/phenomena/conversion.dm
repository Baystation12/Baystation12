/datum/phenomena/conversion
	name = "Conversion"
	cost = 20
	flags = 0
	expected_type = /mob/living

/datum/phenomena/conversion/can_activate(var/atom/target)
	if(!..())
		return 0
	var/is_good = 0
	for(var/obj/structure/deity/altar/A in linked.structures)
		if(get_dist(target, A) < 2)
			is_good = 1
			break
	if(!is_good)
		to_chat(linked,"<span class='warning'>\The [target] needs to be near \a [linked.get_type_name(/obj/structure/deity/altar)].</span>")
		return 0
	return 1

/datum/phenomena/conversion/activate(var/mob/living/L)
	to_chat(src,"<span class='notice'>You give \the [L] a chance to willingly convert. May they choose wisely.</span>")
	var/choice = alert(L, "You feel a weak power enter your mind attempting to convert it.", "Conversion", "Allow Conversion", "Deny Conversion")
	if(choice == "Allow Conversion")
		godcult.add_antagonist_mind(L.mind,1,"a servant of [src]. You willingly give your mind to it, may it bring you fortune", "Servant of [src]", specific_god=src)
	else
		to_chat(L, "<span class='warning'>With little difficulty you force the intrusion out of your mind. May it stay that way.</span>")
		to_chat(src, "<span class='warning'>\The [L] decides not to convert.</span>")

/datum/phenomena/forced_conversion
	name = "Forced Conversion"
	cost = 50
	flags = 0
	expected_type = /mob/living

/datum/phenomena/forced_conversion/can_activate(var/mob/living/L)
	if(!..())
		return 0
	var/obj/structure/deity/altar/A = locate() in get_turf(L)
	if(!A || A.linked_god != linked)
		to_chat(linked,"<span class='warning'>\The [L] needs to be on \a [linked.get_type_name(/obj/structure/deity/altar)] to be forcefully converted..</span>")
		return 0

	return 1

/datum/phenomena/forced_conversion/activate(var/mob/living/L)
	var/obj/structure/deity/altar/A = locate() in get_turf(L)
	A.set_target(L)
	to_chat(src, "<span class='notice'>You embue \the [A] with your power, setting forth to force \the [L] to your will.</span>")