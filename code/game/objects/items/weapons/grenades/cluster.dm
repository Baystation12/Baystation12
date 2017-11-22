
//defines for readibility's sake.
#define SPLITINTOBOMBLETS TRUE

#define SPLITINTOPRODUCTS FALSE

/obj/item/weapon/grenade/cluster
	name = "clusterbomb"
	desc = "Use of this weapon may constiute a breach in Sapient Rights."
	name = "clusterbang"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang"
	truncated_name = "cluster-bomb" //In case a clusterbomb clusterbomb is made.
	var/splitrange = 5  //Splitting explosively, after all.
	var/path_to_desired_product_grenade = /obj/item/weapon/grenade //Change this to a grenade path and the clusterbomb does the rest. Can any movable atom, not just a grenade.
	var/products_per_stage = 3 //Total products = products_per_stage²

/obj/item/weapon/grenade/cluster/New()
	..()
	var/obj/item/weapon/grenade/G = new path_to_desired_product_grenade()
	G.name = istype(G) ? "cluster[G.truncated_name]" : "cluster-[G.name]"

/obj/item/weapon/grenade/cluster/proc/resolve_clustering(var/WeAreMakingABomblet)
	var/atoms = list()
	for (var/atom/A in orange(splitrange, src))
		atoms += A
	var/target = pick(atoms)

	if(WeAreMakingABomblet)
		for (var/thing in create_many(/obj/item/weapon/grenade/cluster/bomblet, products_per_stage, loc))
			var/obj/item/weapon/grenade/cluster/bomblet/B = thing
			target = pick(atoms)
			B.path_to_desired_product_grenade = path_to_desired_product_grenade
			B.products_per_stage = src.products_per_stage
			B.splitrange = src.splitrange
			B.det_time  = rand(15,30)
			B.activate(src)
			B.throw_at(target, splitrange, 8, src)
	else
		for (var/thing in create_many(path_to_desired_product_grenade, products_per_stage, loc))
			target = pick(atoms)
			if(istype(thing, /obj/item/weapon/grenade)) //Does not have to actually be a grenade. The clusterbomb can spawn any movable atom (Handled below.)
				var/obj/item/weapon/grenade/G = thing
				G.det_time = rand(15,30)
				G.activate(src)
				G.throw_at(target,splitrange,8,src)
			else //For anything that isn't a grenade.
				var/atom/movable/O = thing
				O.throw_at(target,splitrange,8,src)

/obj/item/weapon/grenade/cluster/detonate()
	playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	resolve_clustering(!istype(src, /obj/item/weapon/grenade/cluster/bomblet)) // True when we are a full cluster, thus creating bomblets. False as a bomblet, thus creating products.
	qdel(src)

/obj/item/weapon/grenade/cluster/bomblet //bomblets should never exist except part of the clusterbang, since these immediately 'do their thing' and asplode
	name = "clusterbang segment"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang_segment"
	throwforce = 8 //It's splitting explosively. Should hit you pretty goddamn hard.

///////////////////////
///Clusternade Types///
///////////////////////

/obj/item/weapon/grenade/cluster/flashbang
	path_to_desired_product_grenade = /obj/item/weapon/grenade/flashbang


/obj/item/weapon/grenade/cluster/frag
	path_to_desired_product_grenade = /obj/item/weapon/grenade/frag

/obj/item/weapon/grenade/cluster/frag
	path_to_desired_product_grenade = /obj/item/weapon/grenade/frag/high_yield

/obj/item/weapon/grenade/cluster/emp
	path_to_desired_product_grenade = /obj/item/weapon/grenade/empgrenade

/obj/item/weapon/grenade/cluster/emp/low_yield
	path_to_desired_product_grenade = /obj/item/weapon/grenade/empgrenade/low_yield
	products_per_stage = 4

obj/item/weapon/grenade/cluster/supermatter
	path_to_desired_product_grenade = /obj/item/weapon/grenade/supermatter
	splitrange = 8 //GET THE HELL OUT OF THERE.

obj/item/weapon/grenade/cluster/manhack
	path_to_desired_product_grenade = /obj/item/weapon/grenade/spawnergrenade/manhacks

obj/item/weapon/grenade/cluster/carp
	path_to_desired_product_grenade = /obj/item/weapon/grenade/spawnergrenade/carp

obj/item/weapon/grenade/cluster/cluster //Probably not a good idea to use thiiis!


#undef SPLITINTOBOMBLETS

#undef SPLITINTOPRODUCTS