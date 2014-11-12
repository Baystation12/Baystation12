/var/global/rad_storm = 0

/datum/event/radiation_storm
	announceWhen	= 1
	oneShot			= 1


/datum/event/radiation_storm/announce()
	// Don't do anything, we want to pack the announcement with the actual event

/datum/event/radiation_storm/start()
	spawn()
		command_announcement.Announce("High levels of radiation detected near the station. Please evacuate into one of the shielded maintenance tunnels.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')
		make_maint_all_access()
		rad_storm = 1
		world << sound('sound/misc/bloblarm.ogg')

		for(var/obj/machinery/light/emergency/EL in world)
			EL.update()


		sleep(600)


		command_announcement.Announce("The station has entered the radiation belt. Please remain in a sheltered area until we have passed the radiation belt.", "Anomaly Alert")

		world << sound('sound/misc/notice2.ogg')

		for(var/i = 0, i < 10, i++)
			for(var/mob/living/carbon/human/H in living_mob_list)
				var/turf/T = get_turf(H)
				if(!T)
					continue
				if(T.z != 1)
					continue
				if(istype(T.loc, /area/maintenance) || istype(T.loc, /area/crew_quarters) || istype(T.loc, /area/security/prison))
					continue

				if(istype(H,/mob/living/carbon/human))
					H.apply_effect((rand(15,35)),IRRADIATE,0)
					if(prob(5))
						H.apply_effect((rand(40,70)),IRRADIATE,0)
						if (prob(75))
							randmutb(H) // Applies bad mutation
							domutcheck(H,null,MUTCHK_FORCED)
						else
							randmutg(H) // Applies good mutation
							domutcheck(H,null,MUTCHK_FORCED)


			for(var/mob/living/carbon/monkey/M in living_mob_list)
				var/turf/T = get_turf(M)
				if(!T)
					continue
				if(T.z != 1)
					continue
				M.apply_effect((rand(5,25)),IRRADIATE,0)
			sleep(100)


		command_announcement.Announce("The station has passed the radiation belt. Please report to medbay if you experience any unusual symptoms. Maintenance will lose all access again shortly.", "Anomaly Alert")

		world << sound('sound/misc/notice2.ogg')

		sleep(600) // Want to give them time to get out of maintenance.

		world << sound('sound/misc/notice2.ogg')
		revoke_maint_all_access()
		rad_storm = 0
		for(var/obj/machinery/light/emergency/EL in world)
			EL.update()

