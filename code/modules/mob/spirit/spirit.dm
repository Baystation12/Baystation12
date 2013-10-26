/*
This mob type is used for entities that exist within the Cult's spirit world. They share the same visibility network and are intangible.


NOTES

- make chunks generic
	- subclass them for camerachunks and for cultchunks
- do the same thing with visibility networks
	- cultnet and cameraNetwork etc.
*/

mob/spirit
	name = "spirit"
	desc = "A spirit"
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	layer = 4
	stat = CONSCIOUS
	status_flags = GODMODE // spirits cannot be killed
	density = 0
	canmove = 0
	blinded = 0
	anchored = 1
	invisibility = INVISIBILITY_SPIRIT

	// pseudo-movement values
	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1
	var/follow_target = null

mob/spirit/New()
	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_SPIRITS
	see_in_dark = 100

	loc = pick(latejoin)

	// no nameless spirits
	if (!name)
		name = "Boogyman"