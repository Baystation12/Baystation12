
/turf/unsimulated/floor/chasm
	name = "bottomless chasm"
	desc = "Strange glyphs line walls of mysterious alloy. You don't see the bottom."
	icon = 'chasm.dmi'
	icon_state = "chasm"

/turf/unsimulated/floor/chasm/Entered(atom/movable/Obj,atom/OldLoc)
	var/loseme = 0
	if(isliving(Obj))
		loseme = 1

		var/mob/living/M = Obj
		M.death(0, "disappears into the darkness...", "You have fallen into a bottomless pit! You're not coming back...")
		M.ghost()

	else if(isitem(Obj))
		loseme = 1

	if(loseme)
		src.visible_message("\icon[Obj]<span class='danger'>[Obj] has fallen into the depths of [src]!</span>")
		qdel(Obj)
