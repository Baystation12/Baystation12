/*
	Both english and russian, for those, who wanna learn language in game.
	Английский и русский текст одновременно, для тех, кто хочет подучить язык в игре.
*/
/datum/lang/en_RU
	name = "combined russian"

	examine(args = null)
		var/result = "\icon[refObj] That's [GenderForm(gender,"a","a","a","some")] "
		if(refObj:blood_DNA && !istype(refObj, /obj/effect/decal))
			if(refObj:blood_color != "#030303")
				result += "<span class='danger'>blood-stained</span> [GetVar()][args["infix"]]!"
			else
				result += "oil-stained [GetVar()][args["infix"]]."
		else
			result += "[GetVar()][args["infix"]]. [args["suffix"]]"

		return result