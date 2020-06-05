
/obj/structure/faction_banner
	icon = 'code/modules/halo/misc/capture_node.dmi'
	icon_state = "sign"
	anchored = 1

/obj/structure/faction_banner/unsc
	icon_state = "UNSC"

/obj/structure/faction_banner/insurrection
	icon_state = "Insurrection"

/obj/structure/faction_banner/covenant
	icon_state = "Covenant"

/obj/structure/faction_banner/ex_act(var/severity)
	qdel(src)
