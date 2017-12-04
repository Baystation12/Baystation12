/*NewGrenade assembly parts.
Note: I am going to use cheesy-ass names for the se components and you cannot stop me. Please be kind and do the same if possible.

*/


/*
Offensive grenades: Concussion; HE; Fragmentation; Incendiary; Shock; Tesla; Gravitating; Laser; Scatter (Caltrops); STING
*/


obj/item/grenadepart
	name = "grenade part"
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "grenade" //Todo: Unique states.
	desc = "A [src.name] for use in grenade construction."
	var/list/exclusive_to = list() //What grenades are not allowed to cross with this one?
	var/complexity = 10000 //The complexity cost for the grenade itself. It's massive here to keep this base-type part from being used.
	var/power_bonus //How many points does this item add to the trait power of a grenade? Used by trait enhancers, but can be added to other parts too.
	var/flag_to_add_1 //What flag does this part add to the grenade assembly?
	var/flag_to_add_2 //Because we ran out of bitflags in the first list of them. Used exclusively by smokes. Refer to the _defines file; add a third list of flags if needed.


.
/*
Grenades that make a thing. That thing can be a projectile, a mob, or a /movable/obj.
Please don't try to use this to spawn unmovable atoms. They will just spray out runtimes.
IMPORTANT NOTE: Do not use more than three thingspawners. You're just wasting your resources. It won't work, and you'll waste a thingspawner. Note: These will be denied in construction.

*/
/obj/item/grenadepart/makesathing
	name = "grenade that makes a thing"
	var/thingtomake //What are we going to make?



//We will boom with the range and detonative force easing smoothly outwards based on trait_power.
obj/item/grenadepart/high_explosives
	name = "high explosive charge"
	complexity = 1
	exclusive_to = list(/obj/item/grenadepart/grav)
	flag_to_add = EXPLOSIVE


//We will explode with range and detonative dissipating rapidly outwards based on trait_power. MUTUALLY EXCLUSIVE TO high_explosives!
/obj/item/grenadepart/concussion
	name = "concussive charge"
	complexity = 1
	exclusive_to = list(/obj/item/grenadepart/grav)
	flag_to_add = CONCUSSIVE


//Supermatter grenade. Exclusive to a lot of things, for a real damn good reason: Dragging people into a grenade's epicenter is a damn good way to kill instantly.
/obj/item/grenadepart/grav
	name = "supermatter-sliver microcontainment unit"
	exclusive_to = list(obj/item/grenadepart/high_explosives,
						/obj/item/grenadepart/makesathing/shrapnel_rack,
						/obj/item/grenadepart/makesathing/sting_rack,
						/obj/item/grenadepart/concussion,
						/obj/item/grenadepart/tesla)
	flag_to_add =

//We will shoot shrapnel, with the amount varying on trait_power.
obj/item/grenadepart/shrapnel_rack
	name = "fragmentation holder"
	complexity = //Note: Figure out the ratio required to make a similar explosion to oldfrags and newfrags.
	flag_to_add =

/obj/item/grenadepart/makesathing/sting_rack
	name = "rubber bullet launcher"
	exclusive_to = list(/obj/item/grenadepart/grav) //See shrapnel rack.
	thingtomake = /obj/item/projectile/bullet/pistol/rubber
	flag_to_add =

//Shoots lasers everywhere
/obj/item/grenadepart/makesathing/laser
	name = "omni-laser projector"
	complexity = 3  //One bolt per power.
	exclusive_to = list(/obj/item/grenadepart/grav) //Will evicerate you if you're standing on it. No bueno.
	thingtomake = /obj/item/projectile/beam
	flag_to_add =

//Shoots taser bolts everywhere.
/obj/item/grenadepart/taser
	name = "megastunning omni-bolt projector"
	complexity = 1 //One bolt per power.
	thingtomake = /obj/item/projectile/beam/stun/heavy


//Wandering ball of death.
/obj/item/grenadepart/makesathing/tesla
	name = "miniature tesla-ball generator"
	exclusive_to = list(/obj/item/grenadepart/grav) //This seriously hurts people. Don't tug people towards it.
	thingtomake = //TODO: MAKE THE TESLABALL OBJECT.

//What it says on the tin.
/obj/item/grenadepart/makesathing/scatter
	name = "caltrop container"
	exclusive_to = list(/obj/item/grenadepart/grav) //Otherwise RIP feet.
	thingtomake = //TODO: make or find caltrops.


/*
Tactical grenades: Flash; Sonic; Daze; EMP; Anti-Photon, smoke.
*/


//Flashbomb
/obj/item/grenadepart/flash
	name = "ultrablinding module"
	complexity = 3

//Bangbomb.
/obj/item/grenadepart/sonic
	name = "hyperdeafening module"
	complexity = 3

//Applies clumsy for a bit.
/obj/item/grenadepart/daze
	name = "megadazing module"

//What it says on the tin.
/obj/item/grenadepart/EMP
	name = "electro-magnetic pulsar"
	complexity = 1

//Light subtraction.
/obj/item/grenadepart/dark
	name = "anti-photon dispersal suite"
	complexity = 1

//Smokescreen. While technically, it does make a thing, it has its own handling for that.
/obj/item_grenadepart/smokescreen
	name = "smokescreen module"
	complexity = 3

/*
Spawner grenades: Carp; Holocarp; Viscerator; Spiderling
Spawns a mob. Not exclusive to anything; because I won't save you from your stupidity (AKA: Explosive carp grenade.)
*/


/obj/item/grenadepart/makesathing/carp
	name = "dehydrated space carp"
	complexity = 5
	thingtomake = /mob/living/simple_animal/hostile/carp

/obj/item/grenadepart/makesathing/carp/holo
	name = "space carp nananoprojector"
	thingtomake = /mob/living/simple_animal/hostile/carp/holodeck

/obj/item/grenadepart/makesathing/viscerator
	thingtomake = /mob/living/simple_animal/hostile/viscerator
	complexity = 5

//Spawn like thirty of these. Statistically speaking at least one of them will be a nurse. Have dealing with that.
/obj/item/grenadepart/makesathing/spiderling
	name = "dehydrated spider eggs"



/*
Trait enhancers; fills the grenade's complexity while addiing trait_power

*/
/obj/item/grenadepart/traitenhancer
	power = 1