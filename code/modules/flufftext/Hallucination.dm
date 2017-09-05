/*
Ideas for the subtle effects of hallucination:

Light up oxygen/phoron indicators (done)
Cause health to look critical/dead, even when standing (done)
Characters silently watching you
Brief flashes of fire/space/bombs/c4/dangerous shit (done)
Items that are rare/traitorous/don't exist appearing in your inventory slots (done)
Strange audio (should be rare) (done)
Gunshots/explosions/opening doors/less rare audio (done)

*/

mob/living/carbon/var
	image/halimage
	image/halbody
	obj/halitem
	hal_screwyhud = 0 //1 - critical, 2 - dead, 3 - oxygen indicator, 4 - toxin indicator
	handling_hal = 0
	hal_crit = 0

mob/living/carbon/proc/handle_hallucinations()
	if(handling_hal) return
	handling_hal = 1
	while(client && hallucination > 20)
		sleep(rand(200,500)/(hallucination/25))
		var/halpick = rand(1,100)
		switch(halpick)
			if(0 to 15)
				//Screwy HUD
//				to_chat(src, "Screwy HUD")
				hal_screwyhud = pick(1,2,3,3,4,4)
				spawn(rand(100,250))
					hal_screwyhud = 0
			if(16 to 25)
				//Strange items
//				to_chat(src, "Traitor Items")
				if(!halitem)
					halitem = new
					var/list/slots_free = list(ui_lhand,ui_rhand)
					if(l_hand) slots_free -= ui_lhand
					if(r_hand) slots_free -= ui_rhand
					if(istype(src,/mob/living/carbon/human))
						var/mob/living/carbon/human/H = src
						if(!H.belt) slots_free += ui_belt
						if(!H.l_store) slots_free += ui_storage1
						if(!H.r_store) slots_free += ui_storage2
					if(slots_free.len)
						halitem.screen_loc = pick(slots_free)
						halitem.plane = FULLSCREEN_PLANE
						halitem.layer = HALLUCINATION_LAYER
						switch(rand(1,6))
							if(1) //revolver
								halitem.icon = 'icons/obj/gun.dmi'
								halitem.icon_state = "revolver"
								halitem.name = "Revolver"
							if(2) //c4
								halitem.icon = 'icons/obj/assemblies.dmi'
								halitem.icon_state = "plastic-explosive0"
								halitem.name = "Mysterious Package"
								if(prob(25))
									halitem.icon_state = "c4small_1"
							if(3) //sword
								halitem.icon = 'icons/obj/weapons.dmi'
								halitem.icon_state = "sword1"
								halitem.name = "Sword"
							if(4) //stun baton
								halitem.icon = 'icons/obj/weapons.dmi'
								halitem.icon_state = "stunbaton"
								halitem.name = "Stun Baton"
							if(5) //emag
								halitem.icon = 'icons/obj/card.dmi'
								halitem.icon_state = "emag"
								halitem.name = "Cryptographic Sequencer"
							if(6) //flashbang
								halitem.icon = 'icons/obj/grenade.dmi'
								halitem.icon_state = "flashbang1"
								halitem.name = "Flashbang"
						if(client) client.screen += halitem
						spawn(rand(100,250))
							if(client)
								client.screen -= halitem
							halitem = null
			if(26 to 40)
				//Flashes of danger
//				to_chat(src, "Danger Flash")
				if(!halimage)
					var/list/possible_points = list()
					for(var/turf/simulated/floor/F in view(src,world.view))
						possible_points += F
					if(possible_points.len)
						var/turf/simulated/floor/target = pick(possible_points)

						switch(rand(1,3))
							if(1)
//								to_chat(src, "Space")
								halimage = image('icons/turf/space.dmi',target,"[rand(1,25)]",TURF_LAYER)
							if(2)
//								to_chat(src, "Fire")
								halimage = image('icons/effects/fire.dmi',target,"1",TURF_LAYER)
							if(3)
//								to_chat(src, "C4")
								halimage = image('icons/obj/assemblies.dmi',target,"plastic-explosive2",OBJ_LAYER+0.01)


						if(client) client.images += halimage
						spawn(rand(10,50)) //Only seen for a brief moment.
							if(client) client.images -= halimage
							halimage = null


			if(41 to 65)
				//Strange audio
//				to_chat(src, "Strange Audio")
				switch(rand(1,12))
					if(1) sound_to(src, 'sound/machines/airlock.ogg')
					if(2)
						if(prob(50)) sound_to(src, 'sound/effects/Explosion1.ogg')
						else sound_to(src, 'sound/effects/Explosion2.ogg')
					if(3) sound_to(src, 'sound/effects/explosionfar.ogg')
					if(4) sound_to(src, 'sound/effects/Glassbr1.ogg')
					if(5) sound_to(src, 'sound/effects/Glassbr2.ogg')
					if(6) sound_to(src, 'sound/effects/Glassbr3.ogg')
					if(7) sound_to(src, 'sound/machines/twobeep.ogg')
					if(8) sound_to(src, 'sound/machines/windowdoor.ogg')
					if(9)
						//To make it more realistic, I added two gunshots (enough to kill)
						var/gunshot = pick('sound/weapons/gunshot/gunshot_strong.ogg', 'sound/weapons/gunshot/gunshot2.ogg', 'sound/weapons/gunshot/shotgun.ogg', 'sound/weapons/gunshot/gunshot.ogg')
						sound_to(src, gunshot)
						spawn(rand(10,30))
							sound_to(src, gunshot)
					if(10) sound_to(src, 'sound/weapons/smash.ogg')
					if(11)
						//Same as above, but with tasers.
						sound_to(src, 'sound/weapons/Taser.ogg')
						spawn(rand(10,30))
							sound_to(src, 'sound/weapons/Taser.ogg')
				//Rare audio
					if(12)
//These sounds are (mostly) taken from Hidden: Source
						var/list/creepyasssounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
							'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
							'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
							'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
							'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')
						sound_to(src, pick(creepyasssounds))

			if(66 to 70)
				//Flashes of danger
//				to_chat(src, "Danger Flash")
				if(!halbody)
					var/list/possible_points = list()
					for(var/turf/simulated/floor/F in view(src,world.view))
						possible_points += F
					if(possible_points.len)
						var/turf/simulated/floor/target = pick(possible_points)
						switch(rand(1,4))
							if(1)
								halbody = image('icons/mob/human.dmi',target,"husk_l",TURF_LAYER)
							if(2,3)
								halbody = image('icons/mob/human.dmi',target,"husk_s",TURF_LAYER)
							if(4)
								halbody = image('icons/mob/alien.dmi',target,"alienother",TURF_LAYER)
	//						if(5)
	//							halbody = image('xcomalien.dmi',target,"chryssalid",TURF_LAYER)

						if(client) client.images += halbody
						spawn(rand(50,80)) //Only seen for a brief moment.
							if(client) client.images -= halbody
							halbody = null
			if(71 to 72)
				//Fake death
//				src.sleeping_willingly = 1
				src.sleeping = 20
				hal_crit = 1
				hal_screwyhud = 1
				spawn(rand(50,100))
//					src.sleeping_willingly = 0
					src.sleeping = 0
					hal_crit = 0
					hal_screwyhud = 0
	handling_hal = 0




/*obj/machinery/proc/mockpanel(list/buttons,start_txt,end_txt,list/mid_txts)

	if(!mocktxt)

		mocktxt = ""

		var/possible_txt = list("Launch Escape Pods","Self-Destruct Sequence","\[Swipe ID\]","De-Monkify",\
		"Reticulate Splines","Plasma","Open Valve","Lockdown","Nerf Airflow","Kill Traitor","Nihilism",\
		"OBJECTION!","Arrest Stephen Bowman","Engage Anti-Trenna Defenses","Increase Captain IQ","Retrieve Arms",\
		"Play Charades","Oxygen","Inject BeAcOs","Ninja Lizards","Limit Break","Build Sentry")

		if(mid_txts)
			while(mid_txts.len)
				var/mid_txt = pick(mid_txts)
				mocktxt += mid_txt
				mid_txts -= mid_txt

		while(buttons.len)

			var/button = pick(buttons)

			var/button_txt = pick(possible_txt)

			mocktxt += "<a href='?src=\ref[src];[button]'>[button_txt]</a><br>"

			buttons -= button
			possible_txt -= button_txt

	return start_txt + mocktxt + end_txt + "</TT></BODY></HTML>"

proc/check_panel(mob/M)
	if (istype(M, /mob/living/carbon/human) || istype(M, /mob/living/silicon/ai))
		if(M.hallucination < 15)
			return 1
	return 0*/

/obj/effect/fake_attacker
	icon = null
	icon_state = null
	name = ""
	desc = ""
	density = 0
	anchored = 1
	opacity = 0
	var/mob/living/carbon/human/my_target = null
	var/weapon_name = null
	var/mob/living/clone = null

	var/RunAttackLoop = 1

	var/CurrentDir
	var/image/left
	var/image/right
	var/image/up
	var/image/down

	var/image/FakeImage

/obj/effect/fake_attacker/New(var/loc, var/mob/living/target, var/mob/living/carbon/human/clone)
	..()

	if(clone.l_hand)
		if(!(locate(clone.l_hand) in non_fakeattack_weapons))
			weapon_name = clone.l_hand.name
	else if(clone.r_hand)
		if(!(locate(clone.r_hand) in non_fakeattack_weapons))
			weapon_name = clone.r_hand.name

	name = clone.name
	my_target = target
	target.hallucinations += src

	left = image(clone, src, dir = WEST)
	right = image(clone, src, dir = EAST)
	up = image(clone, src, dir = NORTH)
	down = image(clone, src, dir = SOUTH)

	step_away(src, my_target, 2)

	updateimage()

	spawn attack_loop()
	spawn(300)
		qdel(src)

/obj/effect/fake_attacker/Destroy()
	RunAttackLoop = 0
	my_target.client.images -= up
	my_target.client.images -= down
	my_target.client.images -= right
	my_target.client.images -= left
	QDEL_NULL(left)
	QDEL_NULL(right)
	QDEL_NULL(up)
	QDEL_NULL(down)
	if(my_target)
		my_target.hallucinations -= src
	. = ..()

/obj/effect/fake_attacker/attackby(var/obj/item/weapon/P as obj, mob/user as mob)
	step_away(src, my_target, 2)
	my_target.visible_message("<span class='danger'>\The [my_target] flails around wildly.</span>", "<span class='danger'>\The [src] has been attacked by \the [my_target] with \the [P]!</span>")
	return

/obj/effect/fake_attacker/Crossed(var/mob/M)
	if(M == my_target)
		step_away(src, my_target, 2)
		if(prob(30))
			my_target.visible_message("<span class='danger'>\The [my_target] stumbles around.</span>")

/obj/effect/fake_attacker/proc/updateimage()
	if(!my_target.client || !RunAttackLoop)
		return

	switch(CurrentDir)
		if(NORTH, NORTHEAST)
			my_target.client.images -= up
		if(SOUTH, SOUTHWEST)
			my_target.client.images -= down
		if(EAST, SOUTHEAST)
			my_target.client.images -= right
		if(WEST, NORTHWEST)
			my_target.client.images -= left

	switch(dir)
		if(NORTH, NORTHEAST)
			my_target.client.images += up
		if(SOUTH, SOUTHWEST)
			my_target.client.images += down
		if(EAST, SOUTHEAST)
			my_target.client.images += right
		if(WEST, NORTHWEST)
			my_target.client.images += left

	CurrentDir = dir

/obj/effect/fake_attacker/proc/attack_loop()
	while(RunAttackLoop)
		sleep(rand(5, 10))
		if(get_dist(src, my_target) > 1)
			src.set_dir(get_dir(src, my_target))
			updateimage()
			step_towards(src, my_target)
		else
			if(prob(15))
				if(weapon_name)
					sound_to(my_target, sound(pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')))
					to_chat(my_target, "<span class='danger'>\The [my_target] has been attacked with \the [weapon_name] by \the [src]!</span>")
					my_target.adjustHalLoss(8)
					if(prob(20))
						my_target.eye_blurry += 3
					if(prob(33))
						fake_blood(my_target)
				else
					sound_to(my_target, sound(pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')))
					to_chat(my_target, "<span class='danger'>\The [src] has punched \the [my_target]!</span>")
					my_target.adjustHalLoss(4)
					if(prob(33))
						fake_blood(my_target)

		if(prob(15))
			step_away(src, my_target, 2)

/proc/fake_blood(var/mob/target)
	var/obj/effect/overlay/O = new/obj/effect/overlay(target.loc)
	O.name = "blood"
	var/image/I = image('icons/effects/blood.dmi',O,"floor[rand(1,7)]",O.dir,1)
	target << I
	spawn(300)
		qdel(O)
	return

var/list/non_fakeattack_weapons = list(/obj/item/weapon/gun/projectile, /obj/item/ammo_magazine/a357,\
	/obj/item/weapon/gun/energy/crossbow, /obj/item/weapon/melee/energy/sword,\
	/obj/item/weapon/storage/box/syndie_kit, /obj/item/weapon/storage/box/emps,\
	/obj/item/weapon/cartridge/syndicate, /obj/item/clothing/under/chameleon,\
	/obj/item/clothing/shoes/syndigaloshes, /obj/item/weapon/card/id/syndicate,\
	/obj/item/clothing/mask/gas/voice, /obj/item/clothing/glasses/thermal,\
	/obj/item/device/chameleon, /obj/item/weapon/card/emag,\
	/obj/item/weapon/storage/toolbox/syndicate, /obj/item/weapon/aiModule,\
	/obj/item/device/radio/headset/syndicate,	/obj/item/weapon/plastique,\
	/obj/item/device/powersink, /obj/item/weapon/storage/box/syndie_kit,\
	/obj/item/toy/balloon, /obj/item/weapon/gun/energy/captain,\
	/obj/item/weapon/rcd, /obj/item/weapon/tank/jetpack,\
	/obj/item/clothing/under/rank/captain, /obj/item/weapon/aicard,\
	/obj/item/clothing/shoes/magboots, /obj/item/blueprints, /obj/item/weapon/disk/nuclear,\
	/obj/item/clothing/suit/space/void, /obj/item/weapon/tank)

/proc/fake_attack(var/mob/living/target)
	var/mob/living/carbon/human/clone = null
	var/list/PossibleClones = list()

	for(var/mob/living/carbon/human/H in GLOB.living_mob_list_)
		PossibleClones += H

	if(!PossibleClones.len)
		return

	clone = pick(PossibleClones)

	new /obj/effect/fake_attacker(target.loc, target, clone)
