/mob/living/carbon/var/hallucination_power = 0
/mob/living/carbon/var/next_hallucination
/mob/living/carbon/var/list/hallucinations
/mob/living/carbon/var/hallucination = 0 //Directly affects how long a mob will hallucinate for

/mob/living/carbon/proc/handle_hallucinations()
	hallucination_power++
	if(!stat)
		return
	if (world.time < next_hallucination)
		return
	next_hallucination = world.time + rand(20,50)
	var/T = pick(typesof(/datum/hallucination/) - /datum/hallucination/)
	var/datum/hallucination/H = new T
	H.activate()

/datum/hallucination
	var/mob/living/carbon/holder
	var/duration = 0

/datum/hallucination/proc/activate(var/mob/living/carbon/victim)
	if(!istype(victim))
		return
	if(!victim.client)
		return
	victim.hallucinations += src
	holder = victim
	start()
	spawn(duration)
		if(holder)
			end()
			holder.hallucinations -= src
		qdel(src)

/datum/hallucination/proc/start()
/datum/hallucination/proc/end()


//Playing a random sound
/datum/hallucination/sound
	var/list/sounds = list('sound/machines/airlock.ogg','sound/effects/explosionfar.ogg','sound/machines/windowdoor.ogg','sound/machines/twobeep.ogg')

/datum/hallucination/sound/start()
	holder << pick(sounds)

/datum/hallucination/sound/danger
	sounds = list('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg','sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg','sound/weapons/smash.ogg')

/datum/hallucination/sound/spooky
	sounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
	'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
	'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
	'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
	'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')


//Hearing someone being shot twice
/datum/hallucination/gunfire
	var/gunshot
	duration = 20

/datum/hallucination/gunfire/start()
	gunshot = pick('sound/weapons/gunshot/gunshot_strong.ogg', 'sound/weapons/gunshot/gunshot2.ogg', 'sound/weapons/gunshot/shotgun.ogg', 'sound/weapons/gunshot/gunshot.ogg','sound/weapons/Taser.ogg')
	holder << gunshot

/datum/hallucination/gunfire/end()
	holder << gunshot


//Hearing someone talking to/about you.
/datum/hallucination/talking/start()
	for(var/mob/living/carbon/human/talker in view())
		if(talker.stat)
			continue
		var/message
		if(prob(60))
			var/list/phrases = list("Get out!","Go away.","What are you doing?","Put on some clothes.","What did you come here for?","Don't touch me.","You're not getting out of here","Where's your ID?","Take off your clothes.")
			message = pick(phrases)
			holder << "<span class='game say'><span class='name'>[talker.name]</span> [holder.say_quote(message)], <span class='message'><span class='body'>\"[message]\"</span></span></span>"
		else
			holder << "<B>[talker.name]</B> points at [holder.name]"
			holder << "<span class='game say'><span class='name'>[talker.name]</span> says something softly.</span>"
		var/image/speech_bubble = image('icons/mob/talk.dmi',talker,"h[holder.say_test(message)]")
		spawn(30) qdel(speech_bubble)
		holder << speech_bubble


//Spiderling skitters
/datum/hallucination/skitter/start()
	holder << "<span class='notice'>The spiderling skitters[pick(" away"," around","")].</span>"


//Seeing stuff
/datum/hallucination/mirage
	duration = 35
	var/image/mirage

/datum/hallucination/mirage/start()
	var/list/possible_points = list()
	for(var/turf/simulated/floor/F in view(src))
		possible_points += F
	if(possible_points.len)
		mirage = image(pick(possible_points))
		holder.client.images += mirage

/datum/hallucination/mirage/end()
	if(holder.client) holder.client.images -= mirage

//View spin
/datum/hallucination/spin
	duration = 20
	var/old_dir

/datum/hallucination/spin/start()
	old_dir = holder.client.dir
	holder.client.dir = turn(holder.client.dir, pick(90,270,180))

/datum/hallucination/spin/end()
	if(holder.client) holder.client.dir = old_dir

/datum/hallucination/telepahy
	duration = 20 MINUTES

/datum/hallucination/telepahy/activate()
	if(locate(/datum/hallucination/telepahy) in holder.hallucinations)
		return
	..()

/datum/hallucination/telepahy/start()
	holder << "<span class = 'notice'>You expand your mind outwards.</span>"
	holder.verbs += /mob/living/carbon/human/proc/fakeremotesay

/mob/living/carbon/human/proc/fakeremotesay()
	set name = "Telepathic Message"
	set category = "Superpower"

	if(!hallucination)
		src.verbs -= /mob/living/carbon/human/proc/fakeremotesay
		return

	if(!stat)
		return

	var/list/creatures
	for(var/mob/living/carbon/C in mob_list)
		creatures += C
	var/mob/target = input("Who do you want to project your mind to ?") as null|anything in creatures
	if (isnull(target))
		return

	var/msg = sanitize(input("What do you wish to say"))
	show_message("<span class = 'notice'>You project your mind into [target.name]: [msg]</span>")
	if(!stat && prob(20))
		say(msg)

