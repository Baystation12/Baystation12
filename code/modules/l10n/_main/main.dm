/*
	Default text for all
*/
/datum/lang/main
	name = "basic english language"
	gender = NEUTER

	area/name = null
	mob/name = null
	obj/name = null
	datum/name = null

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