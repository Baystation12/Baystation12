//STRIKE TEAMS
var/const/commandos_possible = 6 //if more Commandos are needed in the future

/client/proc/strike_team()
	set category = "Fun"
	set name = "Spawn Strike Team"
	set desc = "Spawns a strike team if you want to run an admin event."

	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(!ticker)
		to_chat(usr, "<font color='red'>The game hasn't started yet!</font>")
		return

	if(world.time < 6000)
		to_chat(usr, "<font color='red'>There are [(6000-world.time)/10] seconds remaining before it may be called.</font>")
		return

	var/datum/antagonist/deathsquad/team

	var/choice = input(usr, "Select type of strike team:") as null|anything in list("Heavy Asset Protection", "Mercenaries")
	if(!choice)
		return

	switch(choice)
		if("Heavy Asset Protection")
			team = deathsquad
		if("Mercenaries")
			team = commandos
		else
			return

	if(team.deployed)
		to_chat(usr, "<font color='red'>Someone is already sending a team.</font>")
		return

	if(alert("Do you want to send in a strike team? Once enabled, this is irreversible.",,"Yes","No")!="Yes")
		return

	alert("This 'mode' will go on until everyone is dead or the installation is destroyed. You may also admin-call the evac shuttle when appropriate. Spawned commandos have internals cameras which are viewable through a monitor inside the Spec. Ops. Office. Assigning the team's detailed task is recommended from there. While you will be able to manually pick the candidates from active ghosts, their assignment in the squad will be random.")

	choice = null
	while(!choice)
		choice = sanitize(input(src, "Please specify which mission the strike team shall undertake.", "Specify Mission", ""))
		if(!choice)
			if(alert("Error, no mission set. Do you want to exit the setup process?",,"Yes","No")=="Yes")
				return

	if(team.deployed)
		to_chat(usr, "Looks like someone beat you to it.")
		return

	team.attempt_random_spawn()
