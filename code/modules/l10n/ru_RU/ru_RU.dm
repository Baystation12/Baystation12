/*
	Default russian localisation
	Стандартная русская локализация
*/
/datum/lang/ru_RU
	name = "default russian"

	area/name = null
	mob/name = null
	obj/name = null
	turf/name = "пол"
	datum/name = null

	examine(args = null)
		switch(args)
			if("name")
				return "[GetVar()]"
			if("That's")
				return "Это"
			if("stained")
				if(refObj:blood_color != "#030303")
					return "<span class='danger'>окровавленн[GenderForm(gender,"ый","а&#255;","ое","ые")] [GetVar()]</span>"
				else
					return "<span class='danger'>измазанн[GenderForm(gender,"ый","а&#255;","ое","ые")] маслом [GetVar()]</span>"