
/obj/machinery/autosurgeon/process()
	if(active)
		if(world.time >= next_autosurgeon_action)
			next_autosurgeon_action = world.time + autosurgeon_action_delay

			if(autosurgeon_stage == AUTOSURGEON_START)
				autosurgeon_stage = AUTOSURGEON_INTERNAL
				autosurgeon_timeout = world.time + 100
				icon_state = "[icon_state_base]1"
				playsound(src.loc, 'sound/machines/copier.ogg', 15, 1)
				if(buckled_mob)
					src.visible_message("<span class='notice'>\The [src] whirrs to life and begins tending to [buckled_mob].</span>")
				else
					src.visible_message("<span class='notice'>\The [src] whirrs to life.</span>")
					botch_surgery = 1
				return

			if(buckled_mob)
				if(buckled_mob.stat == 2)
					set_active(0)

				if(botch_surgery)
					if(prob(66))
						buckled_mob.apply_damage(rand(1,10))
						src.visible_message("<span class='danger'>\The [src] botches up tending to [buckled_mob], whacking them with its tools!</span>")
						playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 15, 1)
					else
						src.visible_message("<span class='warning'>\The [src] botches up tending to [buckled_mob].</span>")
						playsound(src.loc, 'sound/machines/buzz-two.ogg', 15, 1)
				else
					switch(autosurgeon_stage)
						if(AUTOSURGEON_INTERNAL)
							if(surgery_internal())
								increase_dirtiness()
							else
								autosurgeon_stage = AUTOSURGEON_EXTERNAL
						if(AUTOSURGEON_EXTERNAL)
							if(surgery_external())
								increase_dirtiness()
							else
								autosurgeon_stage = AUTOSURGEON_FIRST_AID
						if(AUTOSURGEON_FIRST_AID)
							if(first_aid())
								increase_dirtiness()
							else
								autosurgeon_stage = AUTOSURGEON_SPLINT
						if(AUTOSURGEON_SPLINT)
							if(first_aid_splint())
								increase_dirtiness()
							else
								autosurgeon_stage = AUTOSURGEON_FINISH
						if(AUTOSURGEON_FINISH)
							set_active(0)
			else
				if(world.time >= autosurgeon_timeout)
					playsound(src.loc, 'sound/machines/buttonbeep.ogg', 15, 1)
					set_active(0)
				else if(prob(10))
					src.visible_message("<span class='notice'>\The [src] whirrs and clicks.</span>")

/obj/machinery/autosurgeon/proc/increase_dirtiness()
	if(prob(5))
		dirtiness++
