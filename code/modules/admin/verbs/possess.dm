/proc/possess(obj/O as obj)
	set name = "Possess Obj"
	set category = "Object"

	if(istype(O,/obj/singularity))
		if(config.forbid_singulo_possession)
			to_chat(usr, "It is forbidden to possess singularities.")
			return

	var/turf/T = get_turf(O)

	if(T)
		log_admin("[key_name(usr)] has possessed [O] ([O.type]) at ([T.x], [T.y], [T.z])")
		message_admins("[key_name(usr)] has possessed [O] ([O.type]) at ([T.x], [T.y], [T.z])", 1)
	else
		log_admin("[key_name(usr)] has possessed [O] ([O.type]) at an unknown location")
		message_admins("[key_name(usr)] has possessed [O] ([O.type]) at an unknown location", 1)

	if(!usr.control_object) //If you're not already possessing something...
		usr.name_archive = usr.real_name

	usr.forceMove(O)
	usr.real_name = O.name
	usr.SetName(O.name)
	usr.client.eye = O
	usr.control_object = O
	feedback_add_details("admin_verb","PO") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/release(obj/O)
	set name = "Release Obj"
	set category = "Object"
	//usr.loc = get_turf(usr)

	if(usr.control_object && usr.name_archive) //if you have a name archived and if you are actually relassing an object
		usr.real_name = usr.name_archive
		usr.SetName(usr.real_name)
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.SetName(H.get_visible_name())
//		usr.regenerate_icons() //So the name is updated properly

	usr.forceMove(O.loc) // Appear where the object you were controlling is -- TLE
	usr.client.eye = usr
	usr.control_object = null
	feedback_add_details("admin_verb","RO") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/givetestverbs(mob/M as mob in SSmobs.mob_list)
	set desc = "Give this guy possess/release verbs"
	set category = "Debug"
	set name = "Give Possessing Verbs"
	M.verbs += /proc/possess
	M.verbs += /proc/release
	feedback_add_details("admin_verb","GPV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!