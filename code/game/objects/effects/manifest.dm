/obj/manifest
	name = "manifest"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	unacidable = TRUE

/obj/manifest/Initialize()
	. = ..()
	invisibility = INVISIBILITY_ABSTRACT

/obj/manifest/proc/manifest()
	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/living/carbon/human/M in SSmobs.mob_list)
		dat += "    <B>[M.name]</B> -  [M.get_assignment()]<BR>"
	var/obj/item/paper/P = new /obj/item/paper( src.loc )
	P.info = dat
	P.SetName("paper- 'Crew Manifest'")
	//SN src = null
	qdel(src)
	return
