
/obj/structure/faction_banner
	icon = 'code/modules/halo/misc/capture_node.dmi'
	icon_state = "sign"
	anchored = 1

/obj/structure/faction_banner/unsc
	name = "UNSC banner"
	desc = "A sign indicating this area is under control of the UNSC."
	icon_state = "UNSC"

/obj/structure/faction_banner/insurrection
	name = "Insurrection banner"
	desc = "A sign indicating this area is under control of the Insurrection."
	icon_state = "Insurrection"

/obj/structure/faction_banner/covenant
	name = "Covenant banner"
	desc = "A sign indicating this area is under control of the Covenant."
	icon_state = "Covenant"

/obj/structure/faction_banner/ex_act(var/severity)
	qdel(src)
