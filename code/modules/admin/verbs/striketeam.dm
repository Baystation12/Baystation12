//STRIKE TEAMS
var/const/commandos_possible = 6 //if more Commandos are needed in the future

/client/proc/strike_team()
	set category = "Fun"
	set name = "Spawn Strike Team"
	set desc = "Spawns a death squad if you want to run an admin event."

	if(!src.holder)
		src << "Only administrators may use this command."
		return

	if(!ticker)
		usr << "<font color='red'>The game hasn't started yet!</font>"
		return

	if(world.time < 6000)
		usr << "<font color='red'>There are [(6000-world.time)/10] seconds remaining before it may be called.</font>"
		return

	var/datum/antagonist/deathsquad/team

	var/choice = input(usr, "Select type of strike team:") as null|anything in list("Death Squad", "Mercenaries")
	if(!choice)
		return

	switch(choice)
		if("Death Squad")
			team = deathsquad
		if("Mercenaries")
			team = commandos
		else
			return

	if(team.deployed)
		usr << "<font color='red'>Someone is already sending a team.</font>"
		return

	if(alert("Do you want to send in a strike team? Once enabled, this is irreversible.",,"Yes","No")!="Yes")
		return

	alert("This 'mode' will go on until everyone is dead or the station is destroyed. You may also admin-call the evac shuttle when appropriate. Spawned commandos have internals cameras which are viewable through a monitor inside the Spec. Ops. Office. Assigning the team's detailed task is recommended from there. While you will be able to manually pick the candidates from active ghosts, their assignment in the squad will be random.")

	choice = null
	while(!choice)
		choice = sanitize(copytext(input(src, "Please specify which mission the strike team shall undertake.", "Specify Mission", ""),1,MAX_MESSAGE_LEN))
		if(!choice)
			if(alert("Error, no mission set. Do you want to exit the setup process?",,"Yes","No")=="Yes")
				return

	if(team.deployed)
		usr << "Looks like someone beat you to it."
		return

	team.attempt_spawn(1)
