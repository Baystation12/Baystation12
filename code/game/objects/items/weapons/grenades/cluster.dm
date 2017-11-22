/obj/item/weapon/grenade/cluster //Created by Polymorph, fixed by Sieve, refactored by Chaoko99.
	name = "clusterbomb"
	desc = "Use of this weapon may constiute a breach in Sapient Rights."
	name = "clusterbang"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang"
	var/grenadetospawn = /obj/item/weapon/grenade/ //Change this to a grenade path and the clusterbomb does the rest.

	var/risking_recursion = 0 //Set to 1 for MAYHEM. Means that up to ten grenades can be spawned by one cluster.
	var/amountspawned = 0 //Don't allow this to ever go higher than ten or the server might explode.

/obj/item/weapon/grenade/cluster/New()
	name = "cluster[grenadetospawn.truncated_name]"
	..()


/obj/item/weapon/grenade/cluster/detonate()
	playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	if(!banglet)
		new var/obj/item/weapon/grenade/cluster/bomblet/B(src)
		B.grenadetospawn = src.grenadetospawn
	else
		new var/grenadetospawn/B
		B.grenadetospawn = src.grenadetospawn
		B.banglet = 1

	if (risking_recursion)
		while ((amountspawned <= 10) || prob(75))
			amountspawned++
			new B(src.loc)
		else
	else //Just spawn three if we're not going to up to ten spawned.
		while(amountspawned <= 3)
			new B(src)
			amountspawned++
	return

/obj/item/weapon/grenade/cluster/bomblet //bomblets should never exist except part of the clusterbang, since these immediately 'do their thing' and asplode
	name = "clusterbang segment"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang_segment"
	banglet = 1
	grenadetospawn = /obj/item/weapon/grenade

///////////////////////
///Clusternade Types///
///////////////////////

/obj/item/weapon/grenade/cluster/flashbang
	grenadetospawn = /obj/item/weapon/grenade/flashbang
	risking_recursion = 1 //Should deafen and blind.

/obj/item/weapon/grenade/cluster/frag
	grenadetospawn = /obj/item/weapon/grenade/frag

/obj/item/weapon/grenade/cluster/frag
	grenadetospawn = /obj/item/weapon/grenade/frag/high_yield

/obj/item/weapon/grenade/cluster/emp
	grenadetospawn = /obj/item/weapon/grenade/empgrenade

/obj/item/weapon/grenade/cluster/emp/low_yield
	grenadetospawn = /obj/item/weapon/grenade/empgrenade/low_yield
	risking_recursion = 1 //Make this cheaper in the uplink than the former, or omit it.

obj/item/weapon/grenade/cluster/supermatter
	grenadetospawn = /obj/item/weapon/grenade/supermatter

obj/item/weapon/grenade/cluster/manhack
	grenadetospawn = /obj/item/weapon/grenade/spawnergrenade/manhacks

obj/item/weapon/grenade/cluster/carp
	grenadetospawn = /obj/item/weapon/grenade/spawnergrenade/carp