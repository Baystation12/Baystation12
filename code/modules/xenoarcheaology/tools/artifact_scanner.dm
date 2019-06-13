/obj/machinery/artifact_scanpad
	name = "Anomaly Scanner Pad"
	desc = "Place things here for scanning."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "xenoarch_scanner"
	anchored = 1
	density = 0

/obj/machinery/artifact_scanpad/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return TRUE
	if(default_deconstruction_crowbar(user, O))
		return TRUE
	return ..()