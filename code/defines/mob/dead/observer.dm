/mob/dead/observer
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'mob.dmi'
	icon_state = "ghost"
	layer = 4
	density = 0
	stat = 2
	canmove = 0
	blinded = 0
	anchored = 1	//  don't get pushed around
	var/mob/corpse = null	//	observer mode
	var/datum/hud/living/carbon/hud = null // hud