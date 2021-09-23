/obj/effect/manifest
	name = "manifest"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	unacidable = TRUE

/obj/effect/manifest/New()

	src.invisibility = 101
	return

/obj/effect/manifest/proc/manifest()
	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/living/carbon/human/M in SSmobs.mob_list)
		dat += text("    <B>[]</B> -  []<BR>", M.name, M.get_assignment())
	var/obj/item/paper/P = new /obj/item/paper( src.loc )
	P.info = dat
	P.SetName("paper- 'Crew Manifest'")
	//SN src = null
	qdel(src)
	return