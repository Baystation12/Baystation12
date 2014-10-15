/client/proc/clean()
	set category = "Special Verbs"
	set name = "Clean"


	var/i = 0
	for(var/obj/Obj in world)
		if(istype(Obj,/obj/effect/decal/cleanable))
			i++

	if(!i)
		usr << "No objects of this type exist"
		return
	if(alert("There are [i] cleanable objects in the world. Do you still want to delete?",,"Yes", "No") == "Yes")
		world << "<br><br><font color = red size = 2><b>Admin [usr] is cleaning the station.<br>Expect some lag</b></font><br>"
		sleep 15
		for(var/obj/Obj in world)
			if(istype(Obj,/obj/effect/decal/cleanable))
				del(Obj)
		log_admin("[key_name_admin(usr)] cleaned the world ([i] objects deleted) ")
		message_admins("\blue [key_name_admin(usr)] cleaned the world ([i] objects deleted) ")

