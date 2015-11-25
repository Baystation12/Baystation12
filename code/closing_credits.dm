/proc/showcredits()
	var/crname
//	var/crjob
	var/crckey
	var/list/players = list()
	for (var/mob/living/carbon/human/player in world)
		if(player.client)
			players += player.real_name
	var/random_player = "The Captain"
	if(players.len)
		random_player = pick(players)

	var/dat={"<html>
<body>
<center>
	<font color="white" face="Courier New">
    <marquee behavior="up" bgcolor="black" direction="up" height="800" loop="1" width="1000" scrollamount="2">"}


	var/title=pick("Black ", "White ", "Green ", "The Lord Of The ", "Smell Of ", "Captain Of ", "Alien In ", "Robust ", "[random_player] In ")
	title+=pick("Kitchen", "Brig", "Clown", "Mine", "Toilet", "Coffe", "Toolbox", "Asshole", "Tunnel", "Singularity")
	dat += "<center><h1>"
	dat+=title
	dat+="</h1></center><br><br><center><h3> CAST </h3></center><br>"
	for(var/mob/H in world)
		if(H.ckey)
			crname = "[H.real_name]"
			//crjob = "[H.get_assignment()]"
			crckey = "[H.key]"
			dat += "<center>"
			dat += crname
		//	dat+=" as "
		//	dat+=crjob
			var/i=0
			while(i<(60-length(crname)-length(crckey)))
				dat+= "."
				i++
			dat+=crckey
			dat+="</center><br>"
	dat+="<center>Thanks for watching <br> Stay robust </center>"
	dat+={"</marquee></center>
	</font>
</html>
</body>"}
	for(var/client/C)
		C << browse(dat,"window=credits;size=1040x840")