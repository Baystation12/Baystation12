/*
	Default russian localisation
	Стандартная русская локализация
*/
/datum/lang/ru_RU
	name = "default russian"

	yes = "Да"
	no = "Нет"
	yesno = list("Да"="Yes","Нет"="No")

	directions = list("Север"="North","Восток"="East","Юг"="South","Запад"="West","Отмена"="Cancel")

	area/name = null
	mob/name = null
	obj/name = null
	datum/name = null

	examine(args = null)
		var/result = "\icon[refObj] Это "
		if(refObj:blood_DNA && !istype(refObj, /obj/effect/decal))
			if(refObj:blood_color != "#030303")
				result += "<span class='danger'>окровавленн[GenderForm(gender,"ый","ая","ое","ые")]</span> [GetVar()][args["infix"]]!"
			else
				result += "замасленн[GenderForm(gender,"ый","ая","ое","ые")] [GetVar()][args["infix"]]."
		else
			result += "[GetVar()][args["infix"]]. [args["suffix"]]"

		return result