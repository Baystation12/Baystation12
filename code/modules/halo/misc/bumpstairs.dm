
/obj/structure/bumpstairs
	name = "stairs"
	desc = "On and on and on, they lead somewhere else..."
	density = 0
	anchored = 1
	icon = 'code/modules/halo/misc/ramps.dmi'
	icon_state = "rampbottom"
	var/id_self
	var/id_target
	var/obj/effect/bump_teleporter/my_bump
	var/faction_restrict
	var/list/blocked_types = list()

/obj/structure/bumpstairs/New()
	. = ..()

	my_bump = new(src.loc)
	my_bump.id = id_self
	my_bump.id_target = id_target
	my_bump.name = src.name
	my_bump.faction_restrict = faction_restrict
	my_bump.blocked_types = blocked_types
