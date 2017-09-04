/mob/living/Logout()
	..()
	if (mind)	
		//Per BYOND docs key remains set if the player DCs, becomes null if switching bodies.
		if(!key)	//key and mind have become seperated. 
			mind.active = 0	//This is to stop say, a mind.transfer_to call on a corpse causing a ghost to re-enter its body.
