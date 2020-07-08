
/obj/machinery/research/protolathe
	var/accepting_reagents = TRUE

/obj/machinery/research/protolathe/proc/toggle_reagent_mode(var/mob/user)
	accepting_reagents = !accepting_reagents
	to_chat(user,"\icon[src] <span class='info'>[src] is now [accepting_reagents ? "accepting" : "ejecting"] \
		chemicals [accepting_reagents ? "from" : "to"] a beaker.</span>")
