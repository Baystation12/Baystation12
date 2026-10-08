/turf/simulated/wall/malign
	icon_state = "malign"

/turf/simulated/wall/malign/New(newloc)
	..(newloc, MATERIAL_MALIGN)

/turf/simulated/wall/malign/update_material()
	..()
	desc = "Eerie, shifting inscriptions dot the walls."

/client/verb/dump_overlays(atom/A in world)
	set category = "Debug"
	set name = "Dump Overlays"
	for (var/image/O as anything in A.overlays)
		to_chat(usr, "[icon2html(O, usr)] / [O.icon] / [O.icon_state] / layer=[O.layer] plane=[O.plane] color=[O.color] dir=[O.dir]")
