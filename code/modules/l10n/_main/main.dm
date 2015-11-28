/*
	Default text for all
*/
/datum/lang/main
	name = "basic english language"

	area/name = null
	mob/name = null
	obj/name = null
	datum/name = null

	examine(args = null)
		switch(args)
			if("name")
				return "\a [GetVar()]"
			if("That's")
				return "That's"
			if("stained")
				if(refObj:blood_color != "#030303")
					return "[GenderForm(gender,"a","a","a","some")] <span class='danger'>blood-stained [GetVar()]</span>"
				else
					return "[GenderForm(gender,"a","a","a","some")] <span class='danger'>oil-stained [GetVar()]</span>"