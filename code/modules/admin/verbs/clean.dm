/client/proc/clean()
	set category = "Special Verbs"
	set name = "Clean Station"


	var/i = 0
	for(var/obj/Obj in world)
		if(istype(Obj,/obj/effect/decal/cleanable))
			i++

	if(!i)
		usr << "No /obj/effect/decal/cleanable located in world."
		return
	if(alert("There are [i] cleanable objects in the world. Do you want to delete them?",,"Yes", "No") == "Yes")
		world << "<br><br><font color = red size = 2><b>A Staff member is cleaning the world.<br>Expect a tad bit of lag.</b></font><br>"
		sleep 15
		for(var/obj/Obj in world)
			if(istype(Obj,/obj/effect/decal/cleanable))
				del(Obj)
		log_admin("[key_name(usr)] cleaned the world ([i] objects deleted) ")
		message_admins("\blue [key_name(usr)] cleaned the world ([i] objects deleted) ")