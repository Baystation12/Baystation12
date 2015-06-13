/mob/living/Logout()
	..()
	if (mind)
		if(!key)	//key and mind have become seperated. I believe this is for when a staff member aghosts.
			mind.active = 0	//This is to stop say, a mind.transfer_to call on a corpse causing a ghost to re-enter its body.
		//This tags a player as SSD. See appropriate life.dm files for furthering SSD effects such as falling asleep.
		if(mind.active)
			player_logged = 1 
