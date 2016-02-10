/*
	Default russian localisation
	����������� ������� �����������
*/
/datum/lang/ru_RU
	name = "default russian"

	yes = "��"
	no = "���"
	yesno = list("��"="Yes","���"="No")

	directions = list("�����"="North","������"="East","��"="South","�����"="West","������"="Cancel")

	area/name = null
	mob/name = null
	obj/name = null
	datum/name = null

	examine(args = null)
		var/result = "\icon[refObj] ��� "
		if(refObj:blood_DNA && !istype(refObj, /obj/effect/decal))
			if(refObj:blood_color != "#030303")
				result += "<span class='danger'>�����������[GenderForm(gender,"��","��","��","��")]</span> [GetVar()][args["infix"]]!"
			else
				result += "���������[GenderForm(gender,"��","��","��","��")] [GetVar()][args["infix"]]."
		else
			result += "[GetVar()][args["infix"]]. [args["suffix"]]"

		return result