/obj/item/weapon/gun/energy/advanced/proc/medical_scan(var/mob/living/carbon/human/H)
	if(H)
		if(intelligun_status & INTELLIGUN_ANALYZING)
			src.speak("<span class='warning'>Processing previous analysis! Please wait.</span>")
			return
		if(prob(1))
			reliability -= 1
		if(get_dist(src, H) > 3)
			src.speak("<span class='warning'>Unable to initiate scan. Distance too great.</span>")
			return
		if(shutdown)
			return
		if(medical_data.len >= 50)
			src.speak("<span class='notice'>Removing previous medical records</span>")
			medical_data.Cut()
		src.speak("<span class='notice'> <b>Initating scan for: [H]</b></span>")
		if(!istype(H))
			src.speak("<span class='warning'>Scan results inconclusive</span>")
			return
		intelligun_status |= INTELLIGUN_ANALYZING
		spawn(15)
			if(!can_use_charge(60)) return
			src.speak("<span class='notice'>Current Status: [H.stat > 1 ? "<span class='warning'>dead</span>" : "[H.health]% healthy"]</span>")
			medical_data += "<b>Scan Results for: [H]</b><br><hr><br>"
			medical_data += "<span class='notice'>Overall Status: [H.stat > 1 ? "<span class='warning'>dead</span>" : "[H.health]% healthy"]</span><br>"
			if(H.health < 75)
				if(H.stat <= 1)
					src.speak("<span class='notice'>Beginning detailed analysis of data..</span>")
					spawn(rand(10, 25))
						src.speak("<span class='notice'> Measurements taken. Estimating symptoms...</span>")
					spawn(rand(25, 50))
						src.speak("<span class='notice'> Symptoms estimated. Formulating..</span>")
					spawn(rand(50, 60))
						var/diagnosis = "<span class='notice'> Diagnosis Complete. Measurements</span>"
						var/symptoms = "<span class='notice'>Symptoms may include</span>"
						var/damage = 100 - H.health
						if(H.getOxyLoss() > 1)
							medical_data += "{<font color=#0000FF><B>Respiration</B> ::</font> [H.getOxyLoss() > damage / 2 ? "<font color=#FF0000>Severe Oxygen Deprivation:</font>" : "<font color=#FF00FF>Minor Oxygen Deprivation:</font>"] [H.getOxyLoss()]%}<br>"
							diagnosis += ":<font color=#0000FF> Sp02 :: [100 - H.getOxyLoss()]</font> "
							symptoms += ":<font color=#0000FF> Hypoxia</font> "
							if(H.getOxyLoss() > 70)
								symptoms += ":<font color=#0000FF> Unconciousness</font> "
						if(H.getToxLoss() > 1)
							medical_data += "{<font color=#00C000><B>Blood Toxicity</B> ::</font> [H.getToxLoss() > damage / 2 ? "<font color=#FF0000>Acidic:</font>" : "<font color=#FF00FF>Minor Toxicity:</font>"] [H.getToxLoss()]%}<br>"
							diagnosis += ":<font color=#808000> HCO3 mEq/L :: [100 - H.getToxLoss()]</font> "
							symptoms += ":<font color=#00C000> Acidosis</font> "
							if(H.getToxLoss() > 30)
								symptoms += ": <font color=#FF00FF>Nausea</font> "
						if(H.getFireLoss() > 1)
							medical_data += "{<font color=#FFFF00><B>Burns</B> ::</font>	[H.getFireLoss() > damage / 2 ? "<font color=#FF0000>Third-Degree Burns:</font>" : "<font color=#FF00FF>Second-Degree Burns:</font>"] [H.getFireLoss()]%}<br>"
							diagnosis += ":<font color=#800000> ESR :: [H.getFireLoss()]mm/h </font>"
							symptoms += ":<font color=#FF00FF> Inflammation</font> "
							if(H.getFireLoss() > 30)
								symptoms += ":<font color=#008080> Adipose Damage</font> "
						if(H.getBruteLoss() > 1)
							medical_data += "{<font color=#FF0000><B>Brute Damage</B> ::</font> [H.getBruteLoss() > damage / 2 ? "<font color=#FF0000>Severe Integrity Damage:</font>" : "<font color=#FF00FF>Minor Integrity Damage:</font>"] [H.getBruteLoss()]%}<br>"
							diagnosis += ":<font color=#FF0000> Ecchymosis :: [H.getBruteLoss()]mm/h </font>"
							symptoms += ":<font color=#FF0000> Severe Contusions</font> "
						if(H.getHalLoss() > 1)
							symptoms += ": [H.getBruteLoss() > 50 ? "<font color=#FF0000>Severe Pain</font>" : "<font color=#FF00FF>Mild Pain</font>"] "
							if(H.getHalLoss() + damage >= 80 && H.getOxyLoss() < 50)
								symptoms += ":<font color=#008080> Unconcioussness</font> "
						diagnosis += ":<font color=#0000FF> Body Temperature :: [H.bodytemperature-T0C]&deg;C ([H.bodytemperature*1.8-459.67]&deg;F) </font>"
						diagnosis += ":<font color=#0000FF> Heart Rate :: </font>[H.get_pulse(GETPULSE_TOOL)]bpm "
						medical_data += "{<font color=#0000FF><b>Heart Rate</b> :: [H.get_pulse(GETPULSE_TOOL)]</font>}<br>"
						if(H:vessel)
							var/blood_volume = round(H:vessel.get_reagent_amount("blood"))
							var/blood_percent =  blood_volume / 560
							blood_percent = round(blood_percent, 0.25) * 100
							if(blood_volume < 560)
								diagnosis += ": <span class='notice'>Approximate Blood Percentage :: [blood_percent < 50 ? "<span class='warning'>[rand(blood_percent / 2, blood_percent)]</span>" : "<font color=#808000> [rand(blood_percent / 2, blood_percent)]</font>"]% </span>"
								symptoms += " :<font color=#FF0000> Bleeding </font> "
							medical_data += "{<font_color=#0000FF><b>Blood Volume</b> :: [blood_volume]cl/560cl</font>}"
							if(blood_percent < 50)
								symptoms += ":<font color=#FF0000> Hypovolemia</font> "

							else if(blood_percent < 75)
								symptoms +=	":<font color=#808000> Hypovolemia</font> "
						if(prob(100 - reliability))
							switch(rand(1, 6))
								if(1)
									diagnosis += ":<font color=#008080> Tardiness :: 100%</font> "
								if(2)
									diagnosis += ":<font color=#008080> Robustness :: -1%</font> "
								if(3)
									diagnosis += ":<font color=#008080> Analsysis Accuracy :: 0%</font> "
								if(4)
									symptoms += ":<font color=#008080> Gonnorhea</font> "
								if(5)
									symptoms += ":<font color=#008080> Genetic Instability</font> "
								if(6)
									symptoms += ":<font color=#008080> B-%^rxs(dom</font> "
						symptoms += ":<span class='notice'>  Recommendation: See a doctor!</span>"
						src.speak("[diagnosis] : [symptoms]", 0)
						medical_data += "<br><br><hr><br><br>"
						intelligun_status &= ~INTELLIGUN_ANALYZING
			else
				intelligun_status &= ~INTELLIGUN_ANALYZING

/obj/item/weapon/gun/energy/advanced/proc/analyze(var/mob/user, var/message as text)
	if(shutdown) return
	if(!user && usr) user = usr
	else if(!usr)
		src.speak("<span class='danger'>Error!</span>")
		return 0
	var/mob/living/carbon/human/target = find_said_name(message, user)
	var/list/humans = list()
	var/turf/T = get_turf(src)
	for(var/mob/living/carbon/human/H in view(2, T))
		humans += H
	if(!target || !istype(target))
		target = input("Who?", "Analyze") in humans
		if(!target)
			if(!ai)
				src.speak("<span class='danger'>Alert: Automatic AI recognition software unresponsive!</span>")
				return
			src.speak("<span class='notice'>Unable to find anyone in range to analyze!</span>")
			return
	if(!(target in view(3, T)))
		src.speak("[target] is too far away!")
		return
	medical_scan(target)

/obj/item/weapon/gun/energy/advanced/proc/health(var/mob/living/carbon/human/M)
	medical_scan(M)

/obj/item/weapon/gun/energy/advanced/proc/lock_weapon()
	if(shutdown) return
	if(intelligun_status & INTELLIGUN_LOCKED)
		intelligun_status &= ~INTELLIGUN_LOCKED
	else intelligun_status |= INTELLIGUN_LOCKED
	src.speak("Controls [intelligun_status & INTELLIGUN_LOCKED ? "" : "un"]locked")

/obj/item/weapon/gun/energy/advanced/proc/arrest(var/mob/user, var/message as message, var/forceful = 0)
	if(shutdown) return
	if(!can_use_charge(50)) return
	var/mob/living/carbon/human/target = find_said_name(message, user)
	var/list/humans = list()
	var/turf/T = get_turf(src)
	if(!T) return
	for(var/mob/living/carbon/human/H in view(7, T))
		humans += H
	if(!target)
		if(humans.len > 1)
			src.speak("Who do you want to arrest?")
			target = input("Who?", "Arrest") in humans
		else if(humans.len == 1)
			target = pick(humans)
		else
			src.speak("I can't see anyone we can arrest.")
			return
	var/temp = ""
	if(target.wear_id)
		if(istype(target.wear_id,/obj/item/weapon/card/id))
			temp = target.wear_id:registered_name
		else if(istype(target.wear_id,/obj/item/device/pda))
			var/obj/item/device/pda/tempPda = target.wear_id
			temp = tempPda.owner
	if(!temp)
		temp = target.name
	if(temp)
		for (var/datum/data/record/E in data_core.general)
			if(E.fields["name"] == temp)
				for (var/datum/data/record/R in data_core.security)
					if(R.fields["id"] == E.fields["id"])
						if(R.fields["criminal"] == "*Arrest*")
							forceful = 1

	if(forceful)
		src.speak("<span class='warning'>[target], you are officially under arrest! You are required to lay face-down on the floor within \
				   the next ten seconds or use of force may be authorised! Failure to do as requested by \
				   [owner ? "[owner]" : "your arresting officer"] will result in further charges against you!</span>")
		spawn(50)
			if(!target.stat || !target.lying || !target.restrained())
				src.speak("<span class='danger'>[target], you have five seconds to submit!</span>")
				spawn(50)
					if(!target.stat || !target.lying || !target.restrained())
						override_safety = 1
						override_safety()
						return // They refused to comply
	else
		src.speak(pick("What's their crime?", "What are they in for?", "Why?", "Yee-Haw, we got 'em. But  what'd we get them for?"))
		var/minor_crimes = ""
		var/major_crimes = ""
		var/crime = ""
		minor_crimes = sanitize(reject_bad_text(input("What minor offence(s) are you arresting them for?", "Arrest", ""), 24))
		major_crimes = sanitize(reject_bad_text(input("What major offence(s) are you arresting them for?", "Arrest", ""), 24))
		if(minor_crimes == "" && major_crimes == "")
			src.speak("<span class='warning'>You can't arrest them without reason!</span>")
			return
		if(major_crimes	!= "")
			if(minor_crimes != "")
				crime = "[minor_crimes], [major_crimes]."
			else
				crime = "[major_crimes]."
		else
			crime = "[minor_crimes]."
		if(prob(100 - reliability))
			src.speak("[target], I am arresting you for the crime of associating with a clown. \
					  You have the right to be beaten senseless. Anything you say or do doesn't matter \
					  because no one is going to listen to your complaints anyway. Do you understand these \
					  rights as they have been read to you? Either way, the records will state you do.")
			spark()
		else
			src.speak("[target], I am arresting you for the crime(s) of [lowertext(crime)] You have the right to remain silent. \
					  Anything you say or do can, and will, be given as evidence in the court of law. You have the \
					  right to an attorney. If you cannot afford an attorney, one will be provided for you. \
					  If you remain cooperative throughout your detainment procedure, you may be offered parole. \
					  Do you understand these rights as they have been read to you? Please confirm this by saying 'I do'.")
		if(temp)
			for (var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == temp)
					for (var/datum/data/record/R in data_core.security)
						if(R.fields["id"] == E.fields["id"])
							if(findtext(lowertext(R.fields["mi_crim"]), "none")) // *sigh*
								R.fields["mi_crim"] = ""
							if(findtext(lowertext(R.fields["ma_crim"]), "none"))
								R.fields["ma_crim"] = ""
							R.fields["mi_crim"] += minor_crimes
							R.fields["ma_crim"]	+= major_crimes
							radio.autosay("[temp] has been arrested and their security records have been updated.", ai_name, "Security")
							return
			src.speak("<span class='warning'>Error. Unable to find associated security record.</span>")

/obj/item/weapon/gun/energy/advanced/proc/shutdown_weapon()
	if(shutdown == -1) return
	shutdown = -1
	src.speak("<span class='notice'>Beginning shutdown..</span>", 0, 1)
	spawn(rand(20, 450))
		src.speak("<span class='notice'>Shutdown complete.</span>", 0, 1)
		shutdown = 1

/obj/item/weapon/gun/energy/advanced/proc/activate_weapon()
	if(shutdown == -1) return
	if(!shutdown)
		src.speak("I'm already active!", 0, 1)
		return
	src.speak("Beginning startup..", 0, 1)
	shutdown = -1
	spawn(rand(20, 450))
		if(prob(100 - reliability))
			src.speak("<span class='warning'>Error.</span>", 0, 1)
			if(prob(50 - reliability))
				src.speak("<span class='danger'>Batteries Overloaded!</span>", 0, 1)
				spawn(rand(1, 100))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(rand(1,8), 1, src)
					s.start()
					spawn(rand(10, 30))
						src.visible_message("<span class='danger'>\the [src] blows apart!</span>", 1)
						sleep(3)
						cause_explosion(2)
						qdel(src)
				return
			shutdown = 1
			return
		else if(!can_use_charge(200))
			src.speak("<span class='danger'>Insufficient power to activate!</span>")
			shutdown = 1
		else
			src.speak("<span class='notice'>Startup complete!</span>", 0, 1)
			shutdown = 0

/obj/item/weapon/gun/energy/advanced/proc/record()
	if(recording == 2 || intelligun_status & INTELLIGUN_BACKUP_POWER)
		src.speak("<span class='warning'>Recording is disabled!</span>")
		return
	if(timerecorded >= 15)
		src.speak("<span class='notice'>Unable to record more data: Memory slot is at it's maximum capacity!</span>")
		return
	if(shutdown) return
	src.speak("<span class='notice'> Recording [recording ? "stopped" : "started"]</span>")
	if(recording) recording = 0
	else recording = 1

/obj/item/weapon/gun/energy/advanced/proc/play()
	if(held_pai)
		if(!(intelligun_status & INTELLIGUN_AI_ENABLED))
			src.speak("<span class='warning'>Unable to play recording: AI disabled!</span>")
			return
	if(shutdown) return
	if(intelligun_status & INTELLIGUN_PLAYING)
		src.speak("You are already playing!")
		return
	if(recording)
		src.speak("You cannot play whilst recording!")
		return
	src.speak("Playing recorded data...")
	intelligun_status |= INTELLIGUN_PLAYING
	spawn(rand(5, 25))
		for(var/i=1,recorded_data.len >= i,sleep(10 * (playsleepseconds) ))
			if(!(intelligun_status & INTELLIGUN_PLAYING))
				break
			var/playedmessage = recorded_data[i]
			if (findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
				playedmessage = copytext(playedmessage,2)
			src.speak("<font color=Maroon><B>Recording</B>: [playedmessage]</font>")
			if(recorded_data.len < i+1)
				playsleepseconds = 1
				sleep(10)
				src.speak("<font color=Maroon><B>Recording</B>: End of recording.</font>")
			i++

/obj/item/weapon/gun/energy/advanced/proc/flashlight()
	if(shutdown) return
	if(intelligun_status & INTELLIGUN_BACKUP_POWER && !(intelligun_status & INTELLIGUN_FLASHLIGHT))
		src.speak("<span class='warning'>This feature is disabled due to power loss!</span>")
		return
	if(intelligun_status & INTELLIGUN_FLASHLIGHT)
		intelligun_status &= ~INTELLIGUN_FLASHLIGHT
	else intelligun_status |= INTELLIGUN_FLASHLIGHT
	src.speak("Flashlight...[intelligun_status & INTELLIGUN_FLASHLIGHT ? "On!" : " Off!"]", 0, 1)
	spawn(10)
		if(intelligun_status & INTELLIGUN_FLASHLIGHT)
			set_light(4)
			set_poweruse += 3
			poweruse += 3 // So it shows up in the interface before process()
		else
			poweruse -= 3
			set_poweruse -= 3
			set_light(0)



/obj/item/weapon/gun/energy/advanced/proc/backup()
	if(shutdown) return
	var/area/A = get_area(src)
	var/location = A.name
	if(prob(102 - reliability))
		location = pick("Candy Land", "Space", "%Ê¤zrt", "A smelly pile of garbage")
	src.speak("<span class='warning'>This is [owner ? "[owner.name]" : "[ai_name]"] requesting backup at the location of: [location] immediatley.</span>", 1)
	radio.autosay("This is [owner ? "[owner.name]" : "[ai_name]"] requesting backup at the location of: [location] immediately.", ai_name, "Security")

/obj/item/weapon/gun/energy/advanced/proc/shutup()
	if(prob(105 - reliability))
		src.speak("You can never silence me!")
		return
	if(!(intelligun_status & INTELLIGUN_SPEECH)) return
	src.speak(pick("Fine..I'll be quiet", "You'll regret it!", "You're going to miss me, right?"), 1)
	intelligun_status &= ~INTELLIGUN_SPEECH

/obj/item/weapon/gun/energy/advanced/proc/unshutup() //speak was taken..
	if(intelligun_status & INTELLIGUN_SPEECH) return
	intelligun_status |= INTELLIGUN_SPEECH
	src.speak(pick("Hah! Knew you'd miss me", "Aww...I'm flattered", "I was only being quiet because I was angry. But I forgive you."), 1)

/obj/item/weapon/gun/energy/advanced/proc/override_safety()
	if(override_safety == 1)
		override_safety = 0
		src.speak("<span class='warning'><b>Safety protocols temporarily disengaged. Approximately ten shots before safety re-engages.</b></span>")
	else if(override_safety == 3)
		override_safety = 0
	else if(override_safety == 2)
		src.speak("Unable to disengage safety protocols without reason.")
	else if(override_safety == 0)
		src.speak("Engaging safety protocols..")
		spawn(rand(10, 50))
			override_safety = 2
	shotcount = 0

/obj/item/weapon/gun/energy/advanced/proc/supercharge()


	if(!src.intelligun_status & INTELLIGUN_EMAGGED)
		return
	if(src.intelligun_status & INTELLIGUN_SUPERCHARGED)
		src.speak("Battery temperature returning to optimal levels.")
		intelligun_status &= ~INTELLIGUN_SUPERCHARGED
		return
	else
		src.speak("<span class='danger'>Ov^#rload¤i-ing re-BZZT</span>")
		intelligun_status &= INTELLIGUN_SUPERCHARGED
	if(prob(15) && src.ai || prob(100 - src.reliability))
		spawn(rand(25, 50))
			src.audible_message("<span class='danger'>BANG!</span>")
			spawn(10)
				src.cause_explosion(rand(1, 2))

/obj/item/weapon/gun/energy/advanced/proc/commands()
	src.speak("Listing commands:	<br>\
			  <font color=#808000>Activate: </font>\
			  Activate power <br>\
			  <font color=#00FF00>Analyze: </font>\
			  Initiate wireless bioscan. Recorded \
			  in the interface for reference. Please \
			  state the patient's full name during command<br> \
			  <font color=#FF0000>Arrest: </font> \
			  Automatically state rights, update security \
			  records and report arrest on the encrypted \
			  security channel. <br> \
			  <font color=#FF0000>Backup: </font> \
			  Automatically calls for immediate reinforcements \
			  on the encrypted security channel. <br> \
			  <font color=#808000>Commands:</font> \
			  Repeats this. <br> \
			  <font color=#FF0000>Flashlight: </font> \
			  Turns on the flashlight.<br> \
			  <font color=#00FF00>Health: </font>\
			  Begins a localised bioscan. <br> \
			  <font color=#FF0000>Lock: </font> \
			  Locks the interface so as to require \
			  identification to open and disables \
			  voice commands. <br> \
			  <font color=#808000>Play: </font> \
			  Plays the stored voice records. <br> \
			  <font color=#808000>Record: </font> \
			  Start recording voice logs. <br> \
			  <font color=#808000>Shutdown: </font> \
			  Disables systems (including weapons) \
			  for conserving power. <br> \
			  <font color=#808000>Shutup: </font> \
			  Disables voice response for power saving. <br> \
			  <font color=#808000>Speak: </font> \
			  Enables voice response.<br> \
			  <font color=#FF0000>Unlock: </font> \
			  Unlocks the interface and enables voice commands \
			  commands. [intelligun_status & INTELLIGUN_EMAGGED ? "<br><font color=#800080>Supercharge : Ov&$r-rchargÆ r-rèactor<br>Explode: -BZZT-</font>" : ""]", 1)
