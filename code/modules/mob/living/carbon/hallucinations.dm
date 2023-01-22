/mob/living/carbon/var/hallucination_power = 0
/mob/living/carbon/var/hallucination_duration = 0
/mob/living/carbon/var/next_hallucination
/mob/living/carbon/var/list/hallucinations = list()

/mob/living/carbon/proc/hallucination(duration, power)
	hallucination_duration = max(hallucination_duration, duration)
	hallucination_power = max(hallucination_power, power)

/mob/living/carbon/proc/adjust_hallucination(duration, power)
	hallucination_duration = max(0, hallucination_duration + duration)
	hallucination_power = max(0, hallucination_power + power)

/mob/living/carbon/proc/handle_hallucinations()
	//Tick down the duration
	hallucination_duration = max(0, hallucination_duration - 1)
	if(chem_effects[CE_MIND] > 0)
		hallucination_duration = max(0, hallucination_duration - 1)

	//Adjust power if we have some chems that affect it
	if(chem_effects[CE_MIND] < 0)
		hallucination_power = min(hallucination_power++, 50)
	if(chem_effects[CE_MIND] < -1)
		hallucination_power = hallucination_power++
	if(chem_effects[CE_MIND] > 0)
		hallucination_power = max(hallucination_power - chem_effects[CE_MIND], 0)

	//See if hallucination is gone
	if(!hallucination_power)
		hallucination_duration = 0
		return
	if(!hallucination_duration)
		hallucination_power = 0
		return

	if(!client || stat || world.time < next_hallucination)
		return
	if(chem_effects[CE_MIND] > 0 && prob(chem_effects[CE_MIND]*40)) //antipsychotics help
		return
	var/hall_delay = rand(10,20) SECONDS

	if(hallucination_power < 50)
		hall_delay *= 2
	next_hallucination = world.time + hall_delay
	var/list/candidates = list()
	for(var/T in subtypesof(/datum/hallucination))
		var/datum/hallucination/H = new T
		if(H.can_affect(src))
			candidates += H
	if(candidates.len)
		var/datum/hallucination/H = pick(candidates)
		H.holder = src
		H.activate()

//////////////////////////////////////////////////////////////////////////////////////////////////////
//Hallucination effects datums
//////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/hallucination
	var/mob/living/carbon/holder
	var/allow_duplicates = 1
	var/duration = 0
	var/min_power = 0 //at what levels of hallucination power mobs should get it
	var/max_power = INFINITY

/datum/hallucination/proc/start()

/datum/hallucination/proc/end()

/datum/hallucination/proc/can_affect(var/mob/living/carbon/C)
	if(!C.client)
		return 0
	if(min_power > C.hallucination_power)
		return 0
	if(max_power < C.hallucination_power)
		return 0
	if(!allow_duplicates && (locate(type) in C.hallucinations))
		return 0
	return 1

/datum/hallucination/Destroy()
	. = ..()
	holder = null

/datum/hallucination/proc/activate()
	if(!holder || !holder.client)
		return
	holder.hallucinations += src
	start()
	spawn(duration)
		if(holder)
			end()
			holder.hallucinations -= src
		qdel(src)


//Playing a random sound
/datum/hallucination/sound
	var/list/sounds = list('sound/machines/airlock.ogg','sound/effects/explosionfar.ogg','sound/machines/windowdoor.ogg','sound/machines/twobeep.ogg')

/datum/hallucination/sound/start()
	var/turf/T = locate(holder.x + rand(6,11), holder.y + rand(6,11), holder.z)
	holder.playsound_local(T,pick(sounds),70)

/datum/hallucination/sound/tools
	sounds = list('sound/items/Ratchet.ogg','sound/items/Welder.ogg','sound/items/Crowbar.ogg','sound/items/Screwdriver.ogg')

/datum/hallucination/sound/danger
	min_power = 30
	sounds = list('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg','sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg','sound/weapons/smash.ogg')

/datum/hallucination/sound/spooky
	min_power = 50
	sounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
	'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
	'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
	'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
	'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')

//Hearing someone being shot twice
/datum/hallucination/gunfire
	var/gunshot
	var/turf/origin
	duration = 15
	min_power = 30

/datum/hallucination/gunfire/start()
	gunshot = pick('sound/weapons/gunshot/gunshot_strong.ogg', 'sound/weapons/gunshot/gunshot2.ogg', 'sound/weapons/gunshot/shotgun.ogg', 'sound/weapons/gunshot/gunshot.ogg','sound/weapons/Taser.ogg')
	origin = locate(holder.x + rand(4,8), holder.y + rand(4,8), holder.z)
	holder.playsound_local(origin,gunshot,50)

/datum/hallucination/gunfire/end()
	holder.playsound_local(origin,gunshot,50)

//Hearing someone talking to/about you.
/datum/hallucination/talking/can_affect(var/mob/living/carbon/C)
	if(!..())
		return 0
	for(var/mob/living/M in oview(C))
		return TRUE

/datum/hallucination/talking/start()
	var/sanity = 5 //even insanity needs some sanity
	for(var/mob/living/talker in oview(holder))
		if(talker.stat)
			continue
		var/message
		var/display_name = talker.fake_name ? talker.fake_name : talker.real_name
		if(prob(80))
			var/list/names = list()
			var/lastname = copytext_char(holder.real_name, findtext(holder.real_name, " ")+1)
			var/firstname = copytext_char(holder.real_name, 1, findtext(holder.real_name, " "))
			if(lastname) names += lastname
			if(firstname) names += firstname
			if(!names.len)
				names += holder.real_name
			var/add = prob(20) ? ", [pick(names)]" : ""
			var/list/phrases = list("[prob(50) ? "Hey, " : ""][pick(names)]!","[prob(50) ? "Hey, " : ""][pick(names)]?","Get out[add]!","Go away[add].","What are you doing[add]?","Where's your ID[add]?")
			if(holder.hallucination_power > 50)
				phrases += list("What did you come here for[add]?","Don't touch me[add].","You're not getting out of here[add].", "You are a failure, [pick(names)].","Just kill yourself already, [pick(names)]")
			message = pick(phrases)
			to_chat(holder,"<span class='game say'><span class='name'>[display_name]</span> [holder.say_quote(message)], <span class='message'><span class='body'>\"[message]\"</span></span></span>")
		else
			to_chat(holder,"<B>[display_name]</B> points at [holder.name]")
			to_chat(holder,"<span class='game say'><span class='name'>[display_name]</span> says something softly.</span>")
		var/image/speech_bubble = image('icons/mob/talk.dmi',talker,"h[holder.say_test(message)]")
		spawn(30) qdel(speech_bubble)
		image_to(holder,speech_bubble)
		sanity-- //don't spam them in very populated rooms.
		if(!sanity)
			return

//Spiderling skitters
/datum/hallucination/skitter/start()
	to_chat(holder,"<span class='notice'>The spiderling skitters[pick(" away"," around","")].</span>")

//Spiders in your body
/datum/hallucination/spiderbabies
	min_power = 40

/datum/hallucination/spiderbabies/start()
	if(istype(holder,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = holder
		var/obj/O = pick(H.organs)
		to_chat(H,"<span class='warning'>You feel something [pick("moving","squirming","skittering")] inside of your [O.name]!</span>")

//Seeing stuff
/datum/hallucination/mirage
	duration = 30 SECONDS
	max_power = 30
	var/number = 1
	var/list/things = list() //list of images to display

/datum/hallucination/mirage/Destroy()
	end()
	. = ..()

/datum/hallucination/mirage/proc/generate_mirage()
	var/icon/T = new('icons/obj/trash.dmi')
	return image(T, pick(T.IconStates()), layer = BELOW_TABLE_LAYER)

/datum/hallucination/mirage/start()
	var/list/possible_points = list()
	for(var/turf/simulated/floor/F in view(holder, world.view+1))
		possible_points += F
	if(possible_points.len)
		for(var/i = 1 to number)
			var/image/thing = generate_mirage()
			things += thing
			thing.loc = pick(possible_points)
		holder.client.images += things

/datum/hallucination/mirage/end()
	if(holder.client)
		holder.client.images -= things

//LOADSEMONEY
/datum/hallucination/mirage/money
	min_power = 20
	max_power = 45
	number = 2

/datum/hallucination/mirage/money/generate_mirage()
	return image('icons/obj/items.dmi', "spacecash[pick(1000,500,200,100,50)]", layer = BELOW_TABLE_LAYER)

//Blood and aftermath of firefight
/datum/hallucination/mirage/carnage
	min_power = 50
	number = 10

/datum/hallucination/mirage/carnage/generate_mirage()
	if(prob(50))
		var/image/I = image('icons/effects/blood.dmi', pick("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7"), layer = BELOW_TABLE_LAYER)
		I.color = COLOR_BLOOD_HUMAN
		return I
	else
		var/image/I = image('icons/obj/ammo.dmi', "s-casing-spent", layer = BELOW_TABLE_LAYER)
		I.layer = BELOW_TABLE_LAYER
		I.dir = pick(GLOB.alldirs)
		I.pixel_x = rand(-10,10)
		I.pixel_y = rand(-10,10)
		return I

//Fake attack
/datum/hallucination/fakeattack
	min_power = 30

/datum/hallucination/fakeattack/can_affect(var/mob/living/carbon/C)
	if(!..())
		return 0
	for(var/mob/living/M in oview(C,1))
		return TRUE

/datum/hallucination/fakeattack/start()
	for(var/mob/living/M in oview(holder,1))
		to_chat(holder, "<span class='danger'>[M] has punched [holder]!</span>")
		holder.playsound_local(get_turf(holder),"punch",50)

//Fake injection
/datum/hallucination/fakeattack/hypo
	min_power = 30

/datum/hallucination/fakeattack/hypo/start()
	holder.custom_pain(SPAN_WARNING("You feel a tiny prick!"), 1, TRUE)
