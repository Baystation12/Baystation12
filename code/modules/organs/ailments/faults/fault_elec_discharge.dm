/datum/ailment/fault/elec_discharge
	name = "electrical discharge"
	diagnosis_string = "$USER_HIS$ $ORGAN$ gives you a static shock when you touch it!"

/datum/ailment/fault/elec_discharge/on_ailment_event()
	organ.owner.custom_pain("Shock jolts through your [organ], staggering you!", 50, affecting = organ.owner)
	playsound(organ.owner, 'sound/effects/snap.ogg', 50, 1)
	organ.owner.audible_message(SPAN_DANGER("An arc of electricity flies over [organ.owner]'s [organ.name]!"), hearing_distance = 7)

	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, get_turf(organ.owner))
	spark_system.attach(organ.owner)
	spark_system.start()
	spawn(10)
		qdel(spark_system)

	organ.owner.Stun(2)
