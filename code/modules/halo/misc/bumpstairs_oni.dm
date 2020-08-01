
//see code/modules/halo/misc/bumpstairs_road.dm

/obj/structure/bumpstairs/road/gem_oni
	id_self = "gem_oni"
	id_target = "oni_gem"
	faction_restrict = "UNSC"
	blocked_types = list(/obj/machinery/artifact)

/obj/structure/bumpstairs/road/oni_gem
	id_self = "oni_gem"
	id_target = "gem_oni"
	faction_restrict = "UNSC"
