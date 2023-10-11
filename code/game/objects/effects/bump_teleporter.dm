var/global/list/obj/bump_teleporter/BUMP_TELEPORTERS = list()

/obj/bump_teleporter
	name = "bump-teleporter"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	var/id = null			//id of this bump_teleporter.
	var/id_target = null	//id of bump_teleporter which this moves you to.
	invisibility = INVISIBILITY_ABSTRACT //nope, can't see this
	anchored = TRUE
	density = TRUE
	opacity = 0

/obj/bump_teleporter/New()
	..()
	BUMP_TELEPORTERS += src

/obj/bump_teleporter/Destroy()
	BUMP_TELEPORTERS -= src
	return ..()

/obj/bump_teleporter/Bumped(atom/user)
	if(!ismob(user))
		//user.loc = src.loc	//Stop at teleporter location
		return

	if(!id_target)
		//user.loc = src.loc	//Stop at teleporter location, there is nowhere to teleport to.
		return

	for(var/obj/bump_teleporter/BT in BUMP_TELEPORTERS)
		if(BT.id == src.id_target)
			usr.forceMove(BT.loc)	//Teleport to location with correct id.
			return
