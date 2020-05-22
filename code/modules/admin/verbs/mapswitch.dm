/client/proc/adminmapswitch()
	set category = "Server"
	set name = "Admin switch maps (restart required)"
	if(!check_rights(R_SERVER))
		return


	var/list/Lines = file2list("switchable_maps")

	if(!Lines)
		to_chat(usr, "<span class='warning'>ERROR: unable to find \'switchable_maps\'</span>")

	var/list/choices = list()
	for(var/t in Lines)
		if(t)
			choices.Add(t)
	choices.Add("Cancel")

	var/mapname = input("Select a mapname to switch to","Admin map switch", "Cancel") in choices
	if(mapname == "Cancel")
		return

	var/reveal = alert("Announce map name now?","Announce map name","Yes","No")

	to_world("<span class='danger'>>World restarting to [reveal == "Yes" ? "\'[mapname]\'" : "a secret"] map due to admin mapswitch...</span>")
	log_game("Rebooting due to admin map switch ([usr.ckey])")
	feedback_set_details("end_error","admin map switch ([usr.ckey])")

	sleep(50)
	switch_maps(mapname)