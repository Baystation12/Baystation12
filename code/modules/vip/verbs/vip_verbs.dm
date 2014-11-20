//vip verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless

var/list/vip_verbs_vip = list(
	/client/proc/cmd_vip_say,
	/client/proc/de_vip_self)
	///client/proc/hidevsay)

/client/proc/add_vip_verbs()
	if(vipholder)
		if(vipholder.rights & V_EVENT)				verbs += vip_verbs_vip
		if(vipholder.rights & V_DONATE)				verbs += vip_verbs_vip

/client/proc/remove_vip_verbs()
	verbs.Remove(
		vip_verbs_vip
		)

/client/proc/de_vip_self()
	set name = "Remove Event Status"
	set category = "Event"

	if(vipholder)
		if(alert("Confirm remove event status for the round? You can't give it back to yourself without someone promoting you.",,"Yes","No") == "Yes")
			log_admin("[src] removed the event status from themself.")
			message_admins("[src] removed the event status from themself.", 1)
			de_vip()
			src << "<span class='interface'>You are now a normal player.</span>"


