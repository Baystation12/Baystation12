#define PLAYER_WEIGHT 5
#define HUMAN_DEATH -5000
#define OTHER_DEATH -5000
#define EXPLO_SCORE -10000 //boum

#define COOLDOWN_TIME 12000 // Twenty minutes
#define MIN_ROUND_TIME 18000


#define FLAT_PERCENT 0

//estimated stats
//80 minute round
//60 player server
//48k player-ticks

//60 deaths (ideally)
//20 explosions


var/global/datum/tension/tension_master

/datum/tension
	var/score

	var/deaths
	var/human_deaths
	var/explosions
	var/adminhelps
	var/air_alarms

	var/nuketeam = 0
	var/malfAI = 0
	var/wizard = 0

	var/forcenexttick = 0
	var/supress = 0
	var/eversupressed = 0
	var/cooldown = 0

	var/round1 = 0
	var/round2 = 0
	var/round3 = 0
	var/round4 = 0

	var/list/antagonistmodes = null



	var/list/potentialgames = list()

	New()
		score = 0
		deaths=0
		human_deaths=0
		explosions=0
		adminhelps=0
		air_alarms=0

		if(FLAT_PERCENT)						// I cannot into balance
			antagonistmodes = list (
			"POINTS_FOR_TRATIOR" 		=	6,
			"POINTS_FOR_CHANGLING"		=	6,
			"POINTS_FOR_REVS"			=	3,
			"POINTS_FOR_MALF"			=	1,
			"POINTS_FOR_WIZARD"			=	2,
		 	"POINTS_FOR_CULT"			=	3,
		 	"POINTS_FOR_NUKETEAM"		=	2,
		 	"POINTS_FOR_ALIEN"			=	5,
		 	"POINTS_FOR_NINJA"			=	3,
		 	"POINTS_FOR_DEATHSQUAD"		=	2,
		 	"POINTS_FOR_BORGDEATHSQUAD" =	2
			)

		else
			antagonistmodes = list (
			"POINTS_FOR_TRATIOR" 		=	100000,
			"POINTS_FOR_CHANGLING"		=	120000,
			"POINTS_FOR_REVS"			=	150000,
			"POINTS_FOR_MALF"			=	250000,
			"POINTS_FOR_WIZARD"			=	150000,
		 	"POINTS_FOR_CULT"			=	150000,
		 	"POINTS_FOR_NUKETEAM"		=	250000,
		 	"POINTS_FOR_ALIEN"			=	200000,
		 	"POINTS_FOR_NINJA"			=	200000,
		 	"POINTS_FOR_DEATHSQUAD"		=	500000,
		 	"POINTS_FOR_BORGDEATHSQUAD" =	500000
			)

	proc/process()
		score += get_num_players()*PLAYER_WEIGHT

		if(config.Tensioner_Active)
			if(world.time > MIN_ROUND_TIME)
				round1++
				if(!supress && !cooldown)
					if(prob(1) || forcenexttick)
						round2++
						if(prob(10) || forcenexttick)
							round3++
							if(forcenexttick)
								forcenexttick = 0

							for (var/client/C in admin_list)
								C << "<font color='red' size='3'><b> The tensioner wishes to create additional antagonists!  Press (<a href='?src=\ref[tension_master];Supress=1'>this</a>) in 60 seconds to abort!</b></font>"

							spawn(600)
								if(!supress)
									cooldown = 1
									spawn(COOLDOWN_TIME)
										cooldown = 0
									round4++

									if(!antagonistmodes.len)
										return

									var/thegame = null

									if(FLAT_PERCENT)
										thegame = pickweight(antagonistmodes)
										antagonistmodes.Remove(thegame)

									else
										for(var/V in antagonistmodes)			// OH SHIT SOMETHING IS GOING TO HAPPEN NOW
											if(antagonistmodes[V] < score)
												potentialgames.Add(V)
												antagonistmodes.Remove(V)
										if(potentialgames.len)
											thegame = pick(potentialgames)


									if(thegame)


										log_admin("The tensioner fired, and decided on [thegame]")

										switch(thegame)
											if("POINTS_FOR_TRATIOR")
												if(!makeTratiors())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)
											if("POINTS_FOR_CHANGLING")
												if(!makeChanglings())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)
											if("POINTS_FOR_REVS")
												if(!makeRevs())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)
											if("POINTS_FOR_MALF")
												if(!makeMalfAImode())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)
											if("POINTS_FOR_WIZARD")
												if(!makeWizard())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)

											if("POINTS_FOR_CULT")
												if(!makeCult())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)

											if("POINTS_FOR_NUKETEAM")
												if(!makeNukeTeam())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)

											if("POINTS_FOR_ALIEN")
												if(!makeAliens())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)

											if("POINTS_FOR_NINJA")
												if(!makeSpaceNinja())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)

											if("POINTS_FOR_DEATHSQUAD")
												if(!makeDeathsquad())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)

											if("POINTS_FOR_BORG_DEATHSQUAD")
												if(!makeBorgDeathsquad())
													forcenexttick = 1
												else
													potentialgames.Remove(thegame)


	proc/get_num_players()
		var/peeps = 0
		for (var/mob/M in player_list)
			if (!M.client)
				continue
			peeps += 1

		return peeps

	proc/death(var/mob/M)
		if (!M) return
		deaths++

		if (istype(M,/mob/living/carbon/human))
			score += HUMAN_DEATH
			human_deaths++
		else
			score += OTHER_DEATH


	proc/explosion()
		score += EXPLO_SCORE
		explosions++

	proc/new_adminhelp()
		adminhelps++

	proc/new_air_alarm()
		air_alarms++


	Topic(href, href_list)

		if(!usr || !usr.client)
			return //This shouldnt happen

		if(!usr.client.holder)
			message_admins("\red [key_name(usr)] tried to use the tensioner without authorization.")
			log_admin("[key_name(usr)] tried to use the tensioner without authorization.")
			return

		log_admin("[key_name(usr)] used a tensioner override.  The override was [href]")
		message_admins("[key_name(usr)] used a tensioner override.  The override was [href]")


		if(href_list["addScore"])
			score += 50000

		if (href_list["makeTratior"])
			makeTratiors()

		else if (href_list["makeChanglings"])
			makeChanglings()

		else if (href_list["makeRevs"])
			makeRevs()

		else if (href_list["makeWizard"])
			makeWizard()

		else if (href_list["makeCult"])
			makeCult()

		else if (href_list["makeMalf"])
			makeMalfAImode()

		else if (href_list["makeNukeTeam"])
			makeNukeTeam()

		else if (href_list["makeAliens"])
			makeAliens()

		else if (href_list["makeSpaceNinja"])
			makeSpaceNinja()

		else if (href_list["makeDeathsquad"])
			makeDeathsquad()

		else if (href_list["makeBorgDeathsquad"])
			makeBorgDeathsquad()

		else if (href_list["Supress"])
			supress = 1
			eversupressed++
			spawn(6000)
				supress = 0

		else if (href_list["ToggleStatus"])
			config.Tensioner_Active = !config.Tensioner_Active


	proc/makeMalfAImode()

		var/list/mob/living/silicon/AIs = list()
		var/mob/living/silicon/malfAI = null
		var/datum/mind/themind = null

		for(var/mob/living/silicon/ai/ai in player_list)
			if(ai.client)
				AIs += ai

		if(AIs.len)
			malfAI = pick(AIs)

		else
			return 0

		if(malfAI)
			themind = malfAI.mind
			themind.make_AI_Malf()
			return 1

/*
		if(BE_CHANGELING)	roletext="changeling"
		if(BE_TRAITOR)		roletext="traitor"
		if(BE_OPERATIVE)	roletext="operative"
		if(BE_WIZARD)		roletext="wizard"
		if(BE_REV)			roletext="revolutionary"
		if(BE_CULTIST)		roletext="cultist"


	for(var/mob/new_player/player in world)
		if(player.client && player.ready)
			if(player.preferences.be_special & role)
*/


	proc/makeTratiors()

		var/datum/game_mode/traitor/temp = new

		if(config.protect_roles_from_antagonist)
			temp.restricted_jobs += temp.protected_jobs

		var/list/mob/living/carbon/human/candidates = list()
		var/mob/living/carbon/human/H = null

		for(var/mob/living/carbon/human/applicant in player_list)

			var/datum/preferences/preferences = new

			if(applicant.stat < 2)
				if(applicant.mind)
					if (!applicant.mind.special_role)
						if(!jobban_isbanned(applicant, "traitor") && !jobban_isbanned(applicant, "Syndicate"))
							if(!(applicant.job in temp.restricted_jobs))
								if(applicant.client)
									if(preferences.savefile_load(applicant, 0))
										if(preferences.be_special & BE_TRAITOR)
											candidates += applicant

		if(candidates.len)
			var/numTratiors = min(candidates.len, 3)

			for(var/i = 0, i<numTratiors, i++)
				H = pick(candidates)
				H.mind.make_Tratior()
				candidates.Remove(H)

			return 1

		else
			return 0


	proc/makeChanglings()

		var/datum/game_mode/changeling/temp = new
		if(config.protect_roles_from_antagonist)
			temp.restricted_jobs += temp.protected_jobs

		var/list/mob/living/carbon/human/candidates = list()
		var/mob/living/carbon/human/H = null

		for(var/mob/living/carbon/human/applicant in player_list)

			var/datum/preferences/preferences = new

			if(applicant.stat < 2)
				if(applicant.mind)
					if (!applicant.mind.special_role)
						if(!jobban_isbanned(applicant, "changeling") && !jobban_isbanned(applicant, "Syndicate"))
							if(!(applicant.job in temp.restricted_jobs))
								if(applicant.client)
									if(preferences.savefile_load(applicant, 0))
										if(preferences.be_special & BE_CHANGELING)
											candidates += applicant

		if(candidates.len)
			var/numChanglings = min(candidates.len, 3)

			for(var/i = 0, i<numChanglings, i++)
				H = pick(candidates)
				H.mind.make_Changling()
				candidates.Remove(H)

			return 1

		else
			return 0

	proc/makeRevs()

		var/datum/game_mode/revolution/temp = new
		if(config.protect_roles_from_antagonist)
			temp.restricted_jobs += temp.protected_jobs

		var/list/mob/living/carbon/human/candidates = list()
		var/mob/living/carbon/human/H = null

		for(var/mob/living/carbon/human/applicant in player_list)

			var/datum/preferences/preferences = new

			if(applicant.stat < 2)
				if(applicant.mind)
					if (!applicant.mind.special_role)
						if(!jobban_isbanned(applicant, "revolutionary") && !jobban_isbanned(applicant, "Syndicate"))
							if(!(applicant.job in temp.restricted_jobs))
								if(applicant.client)
									if(preferences.savefile_load(applicant, 0))
										if(preferences.be_special & BE_REV)
											candidates += applicant

		if(candidates.len)
			var/numRevs = min(candidates.len, 3)

			for(var/i = 0, i<numRevs, i++)
				H = pick(candidates)
				H.mind.make_Rev()
				candidates.Remove(H)
			return 1

		else
			return 0

	proc/makeWizard()
		var/list/mob/dead/observer/candidates = list()
		var/mob/dead/observer/theghost = null
		var/time_passed = world.time

		for(var/mob/dead/observer/G in player_list)
			if(!jobban_isbanned(G, "wizard") && !jobban_isbanned(G, "Syndicate"))
				spawn(0)
					switch(alert(G, "Do you wish to be considered for the position of Space Wizard Foundation 'diplomat'?","Please answer in 30 seconds!","Yes","No"))
						if("Yes")
							if((world.time-time_passed)>300)//If more than 30 game seconds passed.
								return
							candidates += G
						if("No")
							return

		sleep(300)

		for(var/mob/dead/observer/G in candidates)
			if(!G.client)
				candidates.Remove(G)

		spawn(0)
			if(candidates.len)
				while((!theghost || !theghost.client) && candidates.len)
					theghost = pick(candidates)
					candidates.Remove(theghost)
				if(!theghost)
					return 0
				var/mob/living/carbon/human/new_character=makeBody(theghost)
				new_character.mind.make_Wizard()

		return 1 // Has to return one before it knows if there's a wizard to prevent the parent from automatically selecting another game mode.


	proc/makeCult()

		var/datum/game_mode/cult/temp = new
		if(config.protect_roles_from_antagonist)
			temp.restricted_jobs += temp.protected_jobs

		var/list/mob/living/carbon/human/candidates = list()
		var/mob/living/carbon/human/H = null

		for(var/mob/living/carbon/human/applicant in player_list)

			var/datum/preferences/preferences = new

			if(applicant.stat < 2)
				if(applicant.mind)
					if (!applicant.mind.special_role)
						if(!jobban_isbanned(applicant, "cultist") && !jobban_isbanned(applicant, "Syndicate"))
							if(!(applicant.job in temp.restricted_jobs))
								if(applicant.client)
									if(preferences.savefile_load(applicant, 0))
										if(preferences.be_special & BE_CULTIST)
											candidates += applicant

		if(candidates.len)
			var/numCultists = min(candidates.len, 4)
//			var/list/runeWords = list()

			for(var/i = 0, i<numCultists, i++)
				H = pick(candidates)
				H.mind.make_Cultist()
				candidates.Remove(H)
				temp.grant_runeword(H)
//				runeWords.Add(H)

//			for(var/i = 0, i < 4, i++) // Four rune words


			return 1

		else
			return 0



	proc/makeNukeTeam()

		var/list/mob/dead/observer/candidates = list()
		var/mob/dead/observer/theghost = null
		var/time_passed = world.time

		for(var/mob/dead/observer/G in player_list)
			if(!jobban_isbanned(G, "operative") && !jobban_isbanned(G, "Syndicate"))
				spawn(0)
					switch(alert(G,"Do you wish to be considered for a nuke team being sent in?","Please answer in 30 seconds!","Yes","No"))
						if("Yes")
							if((world.time-time_passed)>300)//If more than 30 game seconds passed.
								return
							candidates += G
						if("No")
							return

		sleep(300)

		for(var/mob/dead/observer/G in candidates)
			if(!G.client)
				candidates.Remove(G)

		spawn(0)
			if(candidates.len)
				var/numagents = 5
				syndicate_begin()

				for(var/i = 0, i<numagents,i++)
					while((!theghost || !theghost.client) && candidates.len)
						theghost = pick(candidates)
						candidates.Remove(theghost)
					if(!theghost)
						break
					var/mob/living/carbon/human/new_character=makeBody(theghost)
					new_character.mind.make_Nuke()


				var/obj/effect/landmark/nuke_spawn = locate("landmark*Nuclear-Bomb")
				var/obj/effect/landmark/closet_spawn = locate("landmark*Nuclear-Closet")

				var/nuke_code = "[rand(10000, 99999)]"

				if(nuke_spawn)
					var/obj/item/weapon/paper/P = new
					P.info = "Sadly, the Syndicate could not get you a nuclear bomb.  We have, however, acquired the arming code for the station's onboard nuke.  The nuclear authorization code is: <b>[nuke_code]</b>"
					P.name = "nuclear bomb code and instructions"
					P.loc = nuke_spawn.loc

				if(closet_spawn)
					new /obj/structure/closet/syndicate/nuclear(closet_spawn.loc)

				for (var/obj/effect/landmark/A in /area/syndicate_station/start)//Because that's the only place it can BE -Sieve
					if (A.name == "Syndicate-Gear-Closet")
						new /obj/structure/closet/syndicate/personal(A.loc)
						del(A)
						continue

					if (A.name == "Syndicate-Bomb")
						new /obj/effect/spawner/newbomb/timer/syndicate(A.loc)
						del(A)
						continue


				spawn(0)
					for(var/datum/mind/synd_mind in ticker.mode.syndicates)
						if(synd_mind.current)
							if(synd_mind.current.client)
								for(var/image/I in synd_mind.current.client.images)
									if(I.icon_state == "synd")
										del(I)

					for(var/datum/mind/synd_mind in ticker.mode.syndicates)
						if(synd_mind.current)
							if(synd_mind.current.client)
								for(var/datum/mind/synd_mind_1 in ticker.mode.syndicates)
									if(synd_mind_1.current)
										var/I = image('icons/mob/mob.dmi', loc = synd_mind_1.current, icon_state = "synd")
										synd_mind.current.client.images += I

					for (var/obj/machinery/nuclearbomb/bomb in world)
						bomb.r_code = nuke_code						// All the nukes are set to this code.

			return 1 // Has to return one before it knows if there's a wizard to prevent the parent from automatically selecting another game mode.





	proc/makeAliens()
		alien_infestation(3)
		return 1

	proc/makeSpaceNinja()
		space_ninja_arrival()
		return 1

	proc/makeDeathsquad()
		var/list/mob/dead/observer/candidates = list()
		var/mob/dead/observer/theghost = null
		var/time_passed = world.time
		var/input = "Purify the station."
		if(prob(10))
			input = "Save Runtime and any other cute things on the station."
	/*
		if (emergency_shuttle.direction == 1 && emergency_shuttle.online == 1)
			emergency_shuttle.recall()
			world << "\blue <B>Alert: The shuttle is going back!</B>"

		var/syndicate_commando_number = syndicate_commandos_possible //for selecting a leader

		*/
		var/syndicate_leader_selected = 0 //when the leader is chosen. The last person spawned.

	//Generates a list of commandos from active ghosts. Then the user picks which characters to respawn as the commandos.


		for(var/mob/dead/observer/G in player_list)
			spawn(0)
				switch(alert(G,"Do you wish to be considered for an elite syndicate strike team being sent in?","Please answer in 30 seconds!","Yes","No"))
					if("Yes")
						if((world.time-time_passed)>300)//If more than 30 game seconds passed.
							return
						candidates += G
					if("No")
						return
		sleep(300)

		for(var/mob/dead/observer/G in candidates)
			if(!G.key)
				candidates.Remove(G)

		if(candidates.len)
			var/numagents = 6
			//Spawns commandos and equips them.
			for (var/obj/effect/landmark/L in /area/syndicate_mothership/elite_squad)
				if(numagents<=0)
					break
				if (L.name == "Syndicate-Commando")
					syndicate_leader_selected = numagents == 1?1:0

					var/mob/living/carbon/human/new_syndicate_commando = create_syndicate_death_commando(L, syndicate_leader_selected)


					while((!theghost || !theghost.client) && candidates.len)
						theghost = pick(candidates)
						candidates.Remove(theghost)

					if(!theghost)
						del(new_syndicate_commando)
						break

					new_syndicate_commando.key = theghost.key
					new_syndicate_commando.internal = new_syndicate_commando.s_store
					new_syndicate_commando.internals.icon_state = "internal1"

					//So they don't forget their code or mission.


					new_syndicate_commando << "\blue You are an Elite Syndicate. [!syndicate_leader_selected?"commando":"<B>LEADER</B>"] in the service of the Syndicate. \nYour current mission is: \red<B> [input]</B>"

					numagents--

		//Spawns the rest of the commando gear.
		//	for (var/obj/effect/landmark/L)
			//	if (L.name == "Commando_Manual")
					//new /obj/item/weapon/gun/energy/pulse_rifle(L.loc)
				//	var/obj/item/weapon/paper/P = new(L.loc)
				//	P.info = "<p><b>Good morning soldier!</b>. This compact guide will familiarize you with standard operating procedure. There are three basic rules to follow:<br>#1 Work as a team.<br>#2 Accomplish your objective at all costs.<br>#3 Leave no witnesses.<br>You are fully equipped and stocked for your mission--before departing on the Spec. Ops. Shuttle due South, make sure that all operatives are ready. Actual mission objective will be relayed to you by Central Command through your headsets.<br>If deemed appropriate, Central Command will also allow members of your team to equip assault power-armor for the mission. You will find the armor storage due West of your position. Once you are ready to leave, utilize the Special Operations shuttle console and toggle the hull doors via the other console.</p><p>In the event that the team does not accomplish their assigned objective in a timely manner, or finds no other way to do so, attached below are instructions on how to operate a Nanotrasen Nuclear Device. Your operations <b>LEADER</b> is provided with a nuclear authentication disk and a pin-pointer for this reason. You may easily recognize them by their rank: Lieutenant, Captain, or Major. The nuclear device itself will be present somewhere on your destination.</p><p>Hello and thank you for choosing Nanotrasen for your nuclear information needs. Today's crash course will deal with the operation of a Fission Class Nanotrasen made Nuclear Device.<br>First and foremost, <b>DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE.</b> Pressing any button on the compacted bomb will cause it to extend and bolt itself into place. If this is done to unbolt it one must completely log in which at this time may not be possible.<br>To make the device functional:<br>#1 Place bomb in designated detonation zone<br> #2 Extend and anchor bomb (attack with hand).<br>#3 Insert Nuclear Auth. Disk into slot.<br>#4 Type numeric code into keypad ([nuke_code]).<br>Note: If you make a mistake press R to reset the device.<br>#5 Press the E button to log onto the device.<br>You now have activated the device. To deactivate the buttons at anytime, for example when you have already prepped the bomb for detonation, remove the authentication disk OR press the R on the keypad. Now the bomb CAN ONLY be detonated using the timer. A manual detonation is not an option.<br>Note: Toggle off the <b>SAFETY</b>.<br>Use the - - and + + to set a detonation time between 5 seconds and 10 minutes. Then press the timer toggle button to start the countdown. Now remove the authentication disk so that the buttons deactivate.<br>Note: <b>THE BOMB IS STILL SET AND WILL DETONATE</b><br>Now before you remove the disk if you need to move the bomb you can: Toggle off the anchor, move it, and re-anchor.</p><p>The nuclear authorization code is: <b>[nuke_code ? nuke_code : "None provided"]</b></p><p><b>Good luck, soldier!</b></p>"
				//	P.name = "Spec. Ops. Manual"

			for (var/obj/effect/landmark/L in /area/shuttle/syndicate_elite)
				if (L.name == "Syndicate-Commando-Bomb")
					new /obj/effect/spawner/newbomb/timer/syndicate(L.loc)
				//	del(L)

		return 1 // Has to return one before it knows if there's a wizard to prevent the parent from automatically selecting another game mode.


	proc/makeBorgDeathsquad()
		var/list/mob/dead/observer/candidates = list()
		var/mob/dead/observer/theghost = null
		var/time_passed = world.time
		var/list/namelist = list("Tyr","Fenrir","Lachesis","Clotho","Atropos","Nyx")

	//Generates a list of commandos from active ghosts. Then the user picks which characters to respawn as the commandos.

		for(var/mob/dead/observer/G in player_list)
			spawn(0)
				switch(alert(G,"Do you wish to be considered for a cyborg strike team being sent in?","Please answer in 30 seconds!","Yes","No"))
					if("Yes")
						if((world.time-time_passed)>300)//If more than 30 game seconds passed.
							return
						candidates += G
					if("No")
						return
		sleep(300)

		for(var/mob/dead/observer/G in candidates)
			if(!G.client || !G.key)
				candidates.Remove(G)

		if(candidates.len)
			var/numagents = 3

			//Spawns commandos and equips them.
			for (var/obj/effect/landmark/L in /area/borg_deathsquad)
				if(numagents<=0)
					break
				if (L.name == "Borg-Deathsquad")

					var/name = pick(namelist)
					namelist.Remove(name)

					var/mob/living/silicon/robot/new_borg_deathsquad = create_borg_death_commando(L, name)



					while((!theghost || !theghost.client) && candidates.len)
						theghost = pick(candidates)
						candidates.Remove(theghost)

					if(!theghost)
						del(new_borg_deathsquad)
						break

					new_borg_deathsquad.key = theghost.key

					//So they don't forget their code or mission.


					new_borg_deathsquad << "You are a borg deathsquad operative.  Follow your laws."
					numagents--

		//Spawns the rest of the commando gear.
		//	for (var/obj/effect/landmark/L)
			//	if (L.name == "Commando_Manual")
					//new /obj/item/weapon/gun/energy/pulse_rifle(L.loc)
				//	var/obj/item/weapon/paper/P = new(L.loc)
				//	P.info = "<p><b>Good morning soldier!</b>. This compact guide will familiarize you with standard operating procedure. There are three basic rules to follow:<br>#1 Work as a team.<br>#2 Accomplish your objective at all costs.<br>#3 Leave no witnesses.<br>You are fully equipped and stocked for your mission--before departing on the Spec. Ops. Shuttle due South, make sure that all operatives are ready. Actual mission objective will be relayed to you by Central Command through your headsets.<br>If deemed appropriate, Central Command will also allow members of your team to equip assault power-armor for the mission. You will find the armor storage due West of your position. Once you are ready to leave, utilize the Special Operations shuttle console and toggle the hull doors via the other console.</p><p>In the event that the team does not accomplish their assigned objective in a timely manner, or finds no other way to do so, attached below are instructions on how to operate a Nanotrasen Nuclear Device. Your operations <b>LEADER</b> is provided with a nuclear authentication disk and a pin-pointer for this reason. You may easily recognize them by their rank: Lieutenant, Captain, or Major. The nuclear device itself will be present somewhere on your destination.</p><p>Hello and thank you for choosing Nanotrasen for your nuclear information needs. Today's crash course will deal with the operation of a Fission Class Nanotrasen made Nuclear Device.<br>First and foremost, <b>DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE.</b> Pressing any button on the compacted bomb will cause it to extend and bolt itself into place. If this is done to unbolt it one must completely log in which at this time may not be possible.<br>To make the device functional:<br>#1 Place bomb in designated detonation zone<br> #2 Extend and anchor bomb (attack with hand).<br>#3 Insert Nuclear Auth. Disk into slot.<br>#4 Type numeric code into keypad ([nuke_code]).<br>Note: If you make a mistake press R to reset the device.<br>#5 Press the E button to log onto the device.<br>You now have activated the device. To deactivate the buttons at anytime, for example when you have already prepped the bomb for detonation, remove the authentication disk OR press the R on the keypad. Now the bomb CAN ONLY be detonated using the timer. A manual detonation is not an option.<br>Note: Toggle off the <b>SAFETY</b>.<br>Use the - - and + + to set a detonation time between 5 seconds and 10 minutes. Then press the timer toggle button to start the countdown. Now remove the authentication disk so that the buttons deactivate.<br>Note: <b>THE BOMB IS STILL SET AND WILL DETONATE</b><br>Now before you remove the disk if you need to move the bomb you can: Toggle off the anchor, move it, and re-anchor.</p><p>The nuclear authorization code is: <b>[nuke_code ? nuke_code : "None provided"]</b></p><p><b>Good luck, soldier!</b></p>"
				//	P.name = "Spec. Ops. Manual"


		return 1 // Has to return one before it knows if there's a wizard to prevent the parent from automatically selecting another game mode.


	proc/makeBody(var/mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
		if(!G_found || !G_found.key)	return

		//First we spawn a dude.
		var/mob/living/carbon/human/new_character = new(pick(latejoin))//The mob being spawned.

		new_character.gender = pick(MALE,FEMALE)

		var/datum/preferences/A = new()
		A.randomize_appearance_for(new_character)
		if(new_character.gender == MALE)
			new_character.real_name = "[pick(first_names_male)] [pick(last_names)]"
		else
			new_character.real_name = "[pick(first_names_female)] [pick(last_names)]"
		new_character.name = new_character.real_name
		new_character.age = rand(17,45)

		new_character.dna.ready_dna(new_character)
		new_character.key = G_found.key

		return new_character

	/proc/create_syndicate_death_commando(obj/spawn_location, syndicate_leader_selected = 0)
		var/mob/living/carbon/human/new_syndicate_commando = new(spawn_location.loc)
		var/syndicate_commando_leader_rank = pick("Lieutenant", "Captain", "Major")
		var/syndicate_commando_rank = pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant 1st Class", "Master Sergeant", "Sergeant Major")
		var/syndicate_commando_name = pick(last_names)

		new_syndicate_commando.gender = pick(MALE, FEMALE)

		var/datum/preferences/A = new()//Randomize appearance for the commando.
		A.randomize_appearance_for(new_syndicate_commando)

		new_syndicate_commando.real_name = "[!syndicate_leader_selected ? syndicate_commando_rank : syndicate_commando_leader_rank] [syndicate_commando_name]"
		new_syndicate_commando.name = new_syndicate_commando.real_name
		new_syndicate_commando.age = !syndicate_leader_selected ? rand(23,35) : rand(35,45)

		new_syndicate_commando.dna.ready_dna(new_syndicate_commando)//Creates DNA.

		//Creates mind stuff.
		new_syndicate_commando.mind_initialize()
		new_syndicate_commando.mind.assigned_role = "MODE"
		new_syndicate_commando.mind.special_role = "Syndicate Commando"

		//Adds them to current traitor list. Which is really the extra antagonist list.
		ticker.mode.traitors += new_syndicate_commando.mind
		new_syndicate_commando.equip_syndicate_commando(syndicate_leader_selected)

		return new_syndicate_commando





	/proc/create_borg_death_commando(obj/spawn_location, name)

		var/mob/living/silicon/robot/new_borg_deathsquad = new(spawn_location.loc, 1)

		new_borg_deathsquad.real_name = name
		new_borg_deathsquad.name = name

		//Creates mind stuff.
		new_borg_deathsquad.mind_initialize()
		new_borg_deathsquad.mind.assigned_role = "MODE"
		new_borg_deathsquad.mind.special_role = "Borg Commando"

		//Adds them to current traitor list. Which is really the extra antagonist list.
		ticker.mode.traitors += new_borg_deathsquad.mind
		//del(spawn_location)  // Commenting this out for multiple commando teams.
		return new_borg_deathsquad





/obj/machinery/computer/Borg_station
	name = "Cyborg Station Terminal"
	icon = 'icons/obj/computer.dmi'
	icon_state = "syndishuttle"
	req_access = list()
	var/temp = null
	var/hacked = 0
	var/jumpcomplete = 0

/obj/machinery/computer/Borg_station/attack_hand()
	if(jumpcomplete)
		return
	if(alert(usr, "Are you sure you want to send a cyborg deathsquad?", "Confirmation", "Yes", "No") == "Yes")
		var/area/start_location = locate(/area/borg_deathsquad/start)
		var/area/end_location = locate(/area/borg_deathsquad/station)

		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in end_location)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

					// hey you, get out of the way!
		for(var/turf/T in dstturfs)
						// find the turf to move things to
			var/turf/D = locate(T.x, throwy - 1, 1)
						//var/turf/E = get_step(D, SOUTH)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
			if(istype(T, /turf/simulated))
				del(T)

		start_location.move_contents_to(end_location)

		for(var/obj/machinery/door/poddoor/P in end_location)
			P.open()
		jumpcomplete = 1
		command_alert("DRADIS contact!  Set condition one throughout the station!")
