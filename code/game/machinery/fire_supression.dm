// Automatic Fire Supression System
// Basically, ceiling-mounted fire extinguisher triggered by remote button. Used for burn chambers, etc.

/obj/machinery/sprinkler
	name = "Sprinkler"
	desc = "Water sprinkler used to extinguish fires. Remotely controlled."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "gsensor1" // Icon of gas sensor. TODO: Actual icon
	anchored = 1
	var/id = "" 			// Our ID tag
	var/max_water = 60		// Water remaining for this activation cycle
	var/activated = 0
	var/efficiency = 3			// Basically, how much water we put out every few ticks. Larger = Higher chance to put out the fire.
	var/datum/reagents/R

/obj/machinery/sprinkler/New()
	..()
	R = new/datum/reagents(max_water)
	R.my_atom = src
	refill()

/obj/machinery/sprinkler/proc/refill()
	R.add_reagent("water", max_water)

/obj/machinery/sprinkler/proc/trigger()
	if (activated)
		return
	activated = 1

	// Shamelessly stolen from extinguisher.dm and modified for our purposes
	spawn(0)
		while(R.total_volume > 0) // Not empty yet. Play sound only every five ticks.
			playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)
			for(var/a=0, a<5, a++)
				sleep(4) // This will hopefully make nice, consistent sprinkler effect.
				for(var/b=0, b<efficiency, b++)
					spawn(0)
						var/obj/effect/effect/water/W = new /obj/effect/effect/water( get_turf(src) )
						var/my_target = pick(1,2,4,8,5,9,6,10,0) //Tiles around us. 0 is turf this object is on
						var/datum/reagents/RE = new/datum/reagents(5)
						if(!W) return
						W.reagents = RE
						RE.my_atom = W
						if(!W || !src) return
						src.R.trans_to(W,1)
						for(var/c=0, c<5, c++)
							if(my_target != 0) // If target is 0 stay on this turf
								step(W,my_target)
							if(!W) return
							W.reagents.reaction(get_turf(W))
							for(var/atom/atm in get_turf(W))
								if(!W) return
								W.reagents.reaction(atm)
							sleep(2)
						W.delete()
		sleep(300) // Recharging or something. 30s
		refill()
		activated = 0 // Refill and unlock
