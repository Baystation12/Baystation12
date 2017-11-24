/obj/item/weapon/grenade/cluster
	name = "clusterbomb"
	desc = "Use of this weapon may constitute a breach in Sapient Rights."
	icon_state = "cluster"
	truncated_name = "cluster-bomb" //In case a clusterbomb clusterbomb is made.
	var/splitrange = 5  //Splitting explosively, after all.
	var/product_path = /obj/item/weapon/grenade //Change this to a grenade path and the clusterbomb does the rest. Can any movable atom, not just a grenade.
	var/products_per_stage = 3 //Total products = products_per_stage²

/obj/item/weapon/grenade/cluster/New()
	..()
	var/obj/item/weapon/grenade/G = new product_path()

	name = istype(G) ? "cluster[G.truncated_name]" : "cluster-[G.name]"

	update_icon()

/obj/item/weapon/grenade/cluster/proc/handle_clustering(var/nothing)
	var/atoms = list()
	for (var/atom/A in orange(splitrange, src))
		atoms += A
	var/target = pick(atoms)

	var/list/products

	products = create_many(/obj/item/weapon/grenade/cluster/bomblet, products_per_stage, loc)

	for (var/atom/movable/thing in products)
		target = pick(atoms)
		if(istype(thing, /obj/item/weapon/grenade))
			var/obj/item/weapon/grenade/G = thing
			if(istype(thing, /obj/item/weapon/grenade/cluster/bomblet))
				var/obj/item/weapon/grenade/cluster/bomblet/B = thing
				B.product_path = product_path
				B.products_per_stage = src.products_per_stage
				B.splitrange = src.splitrange
				B.update_icon() //Probably not needed, but let's be sure.
			G.det_time = rand(15,30)
			G.activate(src)
		thing.throw_at(target,splitrange,8,src)

/obj/item/weapon/grenade/cluster/update_icon()
	var/obj/item/weapon/grenade/G = new product_path()
	var/image/I = new()
	var/matrix/M = matrix()
	I.layer = FLOAT_LAYER
	I.plane = FLOAT_PLANE

	M.Turn(180) //Center grenade
	I.appearance = G.appearance
	I.transform = M
	underlays += I

	reset_matrix(M)
	M.Scale(-1,1) //Left grenade
	M.Translate(6,0)
	I.appearance = G.appearance
	I.transform = M
	underlays += I

	reset_matrix(M)
	M.Translate(5,0)//Right grenade
	I.appearance = G.appearance
	I.transform = M
	underlays += I


/obj/item/weapon/grenade/cluster/detonate()
	playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	handle_clustering()
	qdel(src)

/obj/item/weapon/grenade/cluster/bomblet
	name = "clusterbang segment"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "bomblet"
	throwforce = 8 //It's splitting explosively. Should hit you pretty goddamn hard.



/obj/item/weapon/grenade/cluster/bomblet/update_icon()

	var/image/L = new()

	var/matrix/M = new/matrix()
	var/obj/item/weapon/grenade/B = new product_path()

	L.appearance = B.appearance
	M.Turn(-90)
	M.Translate(0,3)
	L.transform = M
	underlays += L
	L.layer = FLOAT_LAYER
	L.plane = FLOAT_PLANE

	reset_matrix(M)
	M.Turn(90)
	M.Translate(0,-6)
	L.transform = M
	underlays += L
	L.layer = FLOAT_LAYER
	L.plane = FLOAT_PLANE

/obj/item/weapon/grenade/cluster/bomblet/handle_clustering()
	var/atoms = list()
	for (var/atom/A in orange(splitrange, src))
		atoms += A
	var/target = pick(atoms)

	var/list/products

	products = create_many(product_path, products_per_stage, loc)

	for (var/atom/movable/thing in products)
		target = pick(atoms)
		if(istype(thing, /obj/item/weapon/grenade))
			var/obj/item/weapon/grenade/G = thing
			G.det_time = rand(15,30)
			G.activate(src)
		thing.throw_at(target,rand(5,(splitrange + rand(-3,5))),8,src)








///////////////////////
///Clusternade Types///
///////////////////////

/obj/item/weapon/grenade/cluster/flashbang
	product_path = /obj/item/weapon/grenade/flashbang


/obj/item/weapon/grenade/cluster/frag
	product_path = /obj/item/weapon/grenade/frag

/obj/item/weapon/grenade/cluster/frag/high_yield
	product_path = /obj/item/weapon/grenade/frag/high_yield

/obj/item/weapon/grenade/cluster/emp
	product_path = /obj/item/weapon/grenade/empgrenade

/obj/item/weapon/grenade/cluster/emp/low_yield
	product_path = /obj/item/weapon/grenade/empgrenade/low_yield
	products_per_stage = 4

obj/item/weapon/grenade/cluster/supermatter //Extremely user-dangerous. Beware.
	product_path = /obj/item/weapon/grenade/supermatter
	splitrange = 8 //GET THE HELL OUT OF THERE.

obj/item/weapon/grenade/cluster/manhack
	product_path = /obj/item/weapon/grenade/spawnergrenade/manhacks

obj/item/weapon/grenade/cluster/carp
	product_path = /obj/item/weapon/grenade/spawnergrenade/carp

obj/item/weapon/grenade/cluster/cluster //Spawns many decoy grenades that do not detonate. Sprite will look very odd.
	product_path = /obj/item/weapon/grenade/cluster

obj/item/weapon/grenade/cluster/fuck
	product_path = /obj/item/weapon/grenade/fake

obj/item/weapon/grenade/cluster/carp/fake
	product_path = /obj/item/weapon/grenade/spawnergrenade/fake_carp

obj/item/weapon/grenade/cluster/cash
	product_path = /obj/item/weapon/spacecash/bundle/c1000
	products_per_stage = 10 // Get PAAAIIID.