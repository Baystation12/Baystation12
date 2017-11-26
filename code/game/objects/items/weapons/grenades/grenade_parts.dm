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

//We will boom with the range and detonative force easing smoothly outwards based on trait_power.
obj/item/grenadepart/high_explosives


//We will explode with range and detonative dissipating rapidly outwards based on trait_power. MUTUALLY EXCLUSIVE TO high_explosives!
/obj/item/grenadepart/concussion




//Supermatter grenade. Exclusive to a lot of things, for a real damn good reason: Dragging people into a grenade's epicenter is a damn good way to kill instantly.
/obj/item/grenadepart/grav
	name = "supermatter-sliver microcontainment unit"
	exclusive_to = list(obj/item/grenadepart/high_explosives,
						/obj/item/grenadepart/makesathing/shrapnel_rack,
						/obj/item/grenadepart/makesathing/sting_rack,
						/obj/item/grenadepart/concussion,
						/obj/item/grenadepart/tesla)

.
//Grenades that make a thing. That thing can be a projectile, a mob, or a /movable/obj. Please don't try to use this to spawn unmovable atoms. They will just spray out runtimes.

/obj/item/grenadepart/makesathing
	name = "grenade that makes a thing"
	var/thingtomake //What are we going to make?

//We will shoot shrapnel, with the amount varying on trait_power.
obj/item/grenadepart/shrapnel_rack
	name = "fragmentation holder"
	complexity = //Note: Figure out the ratio required to make a similar explosion to oldfrags and newfrags.

/obj/item/grenadepart/makesathing/sting_rack
	name = "rubber bullet launcher"
	exclusive_to = list(/obj/item/grenadepart/grav) //See shrapnel rack.
	thingtomake = /obj/item/projectile/bullet/pistol/rubber

//Shoots lasers everywhere
/obj/item/grenadepart/makesathing/laser
	name = "omni-laser projector"
	complexity = 3  //One bolt per power.
	exclusive_to = list(/obj/item/grenadepart/grav) //Will evicerate you if you're standing on it. No bueno.
	thingtomake = /obj/item/projectile/beam

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

/obj/item/grenadepart/makesathing/scatter
	name = "caltrop container"
	exclusive_to = list(/obj/item/grenadepart/grav) //Otherwise RIP feet.
	thingtomake = //TODO: make or find caltrops.


/*
Tactical grenades: Flash; Sonic; Daze; EMP; Anti-Photon
*/

/obj/item/grenadepart/flash

/obj/item/grenadepart/sonic

/obj/item/grenadepart/daze

/obj/item/grenadepart/EMP

/obj/item/grenadepart/dark


