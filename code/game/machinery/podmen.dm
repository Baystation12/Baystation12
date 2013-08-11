/* Moved all the plant people code here for ease of reference and coherency.
Injecting a pod person with a blood sample will grow a pod person with the memories and persona of that mob.
Growing it to term with nothing injected will grab a ghost from the observers. */

/obj/item/seeds/replicapod
	name = "pack of dionaea-replicant seeds"
	desc = "These seeds grow into 'replica pods' or 'dionaea', a form of strange sapient plantlife."
	icon_state = "seed-replicapod"
	mypath = "/obj/item/seeds/replicapod"
	species = "replicapod"
	plantname = "Dionaea"
	productname = "/mob/living/carbon/human" //verrry special -- Urist
	lifespan = 50 //no idea what those do
	endurance = 8
	maturation = 5
	production = 10
	yield = 1 //seeds if there isn't a dna inside
	oneharvest = 1
	potency = 30
	plant_type = 0
	growthstages = 6
	var/ckey = null
	var/realName = null
	var/mob/living/carbon/human/source //Donor of blood, if any.
	gender = MALE

/obj/item/seeds/replicapod/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W,/obj/item/weapon/reagent_containers))

		user << "You inject the contents of the syringe into the seeds."

		var/datum/reagent/blood/B

		//Find a blood sample to inject.
		for(var/datum/reagent/R in W:reagents.reagent_list)
			if(istype(R,/datum/reagent/blood))
				B = R
				break
		if(B)
			source = B.data["donor"]
			user << "The strange, sluglike seeds quiver gently and swell with blood."
			if(!source.client && source.mind)
				for(var/mob/dead/observer/O in player_list)
					if(O.mind == source.mind && config.revival_pod_plants)
						O << "<b><font color = #330033><font size = 3>Your blood has been placed into a replica pod seed. Return to your body if you want to be returned to life as a pod person!</b> (Verbs -> Ghost -> Re-enter corpse)</font color>"
						break
		else
			user << "Nothing happens."
			return

		if (!istype(source))
			return

		if(source.ckey)
			realName = source.real_name
			ckey = source.ckey

		W:reagents.clear_reagents()
		return

	return ..()

/obj/item/seeds/replicapod/harvest(mob/user = usr)

	var/obj/machinery/hydroponics/parent = loc
	var/mob/ghost
	var/list/candidates = list()

	user.visible_message("\blue You carefully begin to open the pod...","[user] carefully begins to open the pod...")

	//If a sample is injected (and revival is allowed) the plant will be controlled by the original donor.
	if(source && source.mind && source.ckey && config.revival_pod_plants)
		ghost = source
	else // If no sample was injected or revival is not allowed, we grab an interested observer.
		for(var/mob/dead/observer/O in player_list)
			if(O.client)
				var/response = alert(O, "Someone is harvesting a replica pod. Would you like to play as a Dionaea?", "Replica pod harvest", "Yes", "No")
				if(response == "Yes")
					candidates += O

	if(!do_after(user, 100))
		return

	if(!src || !user)
		return

	if(candidates.len)
		ghost = pick(candidates)

	 //If we don't have a ghost or the ghost is now unplayed, we just give the harvester some seeds.
	if(!ghost || !(ghost.ckey))
		user << "The pod has formed badly, and all you can do is salvage some of the seeds."
		var/seed_count = 1

		if(prob(yield * parent.yieldmod * 20))
			seed_count++

		for(var/i=0,i<seed_count,i++)
			new /obj/item/seeds/replicapod(user.loc)

		parent.update_tray()
		return

	var/mob/living/carbon/human/podman = new /mob/living/carbon/human(parent.loc)

	podman.ckey = ghost.ckey

	if(ghost.mind)
		ghost.mind.transfer_to(podman)

	if(realName)
		podman.real_name = realName
	else
		podman.real_name = "Diona [rand(0,999)]"

	podman.gender = NEUTER
	podman.dna = new /datum/dna()
	podman.dna.real_name = podman.real_name
	podman.set_species("Diona")
	podman.dna.mutantrace = "plant"
	podman.update_mutantrace()

	// Update mode specific HUD icons.
	switch(ticker.mode.name)
		if ("revolution")
			if (podman.mind in ticker.mode:revolutionaries)
				ticker.mode:add_revolutionary(podman.mind)
				ticker.mode:update_all_rev_icons() //So the icon actually appears
			if (podman.mind in ticker.mode:head_revolutionaries)
				ticker.mode:update_all_rev_icons()
		if ("nuclear emergency")
			if (podman.mind in ticker.mode:syndicates)
				ticker.mode:update_all_synd_icons()
		if ("cult")
			if (podman.mind in ticker.mode:cult)
				ticker.mode:add_cultist(podman.mind)
				ticker.mode:update_all_cult_icons() //So the icon actually appears
		// -- End mode specific stuff

	visible_message("\blue The pod disgorges a fully-formed plant person!")

	spawn(0)
		podman << "\green <B>You awaken slowly, feeling your sap stir into sluggish motion as the warm air caresses your bark.</B>"
		if(source && ckey && podman.ckey == ckey)
			podman << "<B>Memories of a life as [source] drift oddly through a mind unsuited for them, like a skin of oil over a fathomless lake.</B>"
		podman << "<B>You are now one of the Dionaea, a race of drifting interstellar plantlike creatures that sometimes share their seeds with human traders.</B>"
		podman << "<B>Too much darkness will send you into shock and starve you, but light will help you heal.</B>"

		if(!realName)
			var/newname = input(podman,"Enter a name, or leave blank for the default name.", "Name change","") as text
			if (newname != "")
				podman.real_name = newname
		parent.update_tray()