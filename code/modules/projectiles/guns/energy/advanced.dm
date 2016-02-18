
/obj/item/weapon/gun/energy/advanced
	name = "The Law"
	desc = "An advanced energy weapon prototype"
	icon = 'icons/obj/advgun.dmi'
	icon_state = "advsec100"
	item_state = null
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 175
	projectile_type = /obj/item/projectile/beam/stun
	cell_type = /obj/item/weapon/cell/high
	modifystate = "advsec"
	charge_meter = 1
	var/reliability = 100
	light_color = "#a91515"

	var/intelligun_status = 0
	var/list/medical_data = list()

	var/obj/item/weapon/cell/backup_power
	var/obj/item/weapon/cell/primary_power

	var/obj/item/weapon/melee/baton/installed
	var/list/recorded_data = list()
	var/recording = 0
	var/playsleepseconds = 0
	var/timerecorded = 0
	//Maybe some of these could instead be bitflags..
	var/shutdown = 0
	var/screen = "MAIN"
	var/shotcount = 0
	var/override_safety = 2 // 3 = Currently changing, 2 = Unable to change 1 = Available to change. 0 = Safety protocols off

	var/use_tick = 0
	var/poweruse = 2
	var/set_poweruse = 2

	req_access = list(access_hos)
	var/obj/item/device/radio/radio
	var/mob/living/carbon/human/owner

	var/ai_name = "The Law"
	var/obj/item/device/paicard/ai
	var/obj/item/device/paicard/held_pai

	//NT-Approved humour (really bad jokes)
	var/list/ran_response = list("You got it!", "Righteo then.", "Not a problem.", "Next time say please", "Yessir!")
	var/list/insults = list("Your mumma's so clowney, her shoes squeek when she walks!","Don't forget; I'm here to sever!", "Keep calm and just die already.")
	var/list/insults2 = list("Hey, hey, what are your shoes made of? Your mums chest hair?", "I'm very proud of you..Not!", "Initiate sarcastic clap sequence", "Cool story bro!"),
	var/list/joke = list("Why didn't the security bot drop his stunstick? Because NanoTrasen cares about safety and glued it on!", "What did the security officer say to thief? Nothing, because prisoners don't get visitation rights!", "A security guard walked into a bar, then realised that it wasn't his break time and left.")
	var/list/joke2 = list("I'm smarter than the average gun!", "Got problems? Please sign a resignation form!", "First rule of gun club: Don't speak about gun club.")
	var/list/dontshoot = list("Protect the innocent!", "Have you seen a criminal anywhere?", "Move along, citizen!", "Security coming through!", "Just doing my job!", "Get outta the way!", "Please report all criminal activity to the nearest officer!", "If you can't do the time, don't do the crime.", "Incoming!", "Sunshine lollypops and, rainbows")
	var/list/non_human = list("We should be fighting criminals!", "Eugh, a waste of charge", "Why are you shooting that?", "Grr, you're <I>so</I> boring", "Ey boss, why so glum?")
	var/list/shoot = list("Freeze, scumbag!", "Do not resist!", "Resistance is futile!", "For NanoTrasen!", "You are the filth of society!", "Pew Pew!", "Halt! Security!", "Bam!", "All your base are belong to us!", "Stop being stupid!", "What's that smell?", "You're going away for a loooong time!", "Shutup and be civilised!", "Everybody on the ground!")
	var/list/speech_verbs = list("beeps", "boops", "pings", "articulates", "chimes", "drones", "informs", "enunciates", "states", "conveys", "implores")

	var/list/commands = list("Shutdown", "Arrest", "Backup", "Record", "Analyze", "Activate", "Commands", "Lock", "Shutup", "Speak", "Play", "Change Access Requirements", "Override", "Flashlight", "Toggle AI")

	New()
		..()
		ai_name = pick("Wheatley", "HAL", "Law", "Order", "Peace", "Prisoner", "Clobborer", "Civil", "Governor", "Diligence", "Temper", "Steel", "No9", "Guardian", "Captain")
		radio = new /obj/item/device/radio{channels=list("Security")}(src)
		processing_objects.Add(src)
		ai = new /obj/item/device/paicard
		spawn(5)
			update_icon()
			primary_power = power_supply
			intelligun_status |= INTELLIGUN_SPEECH
			intelligun_status |= INTELLIGUN_AI_ENABLED

	Destroy()
		qdel(radio)
		if(primary_power)
			qdel(power_supply)
		if(backup_power)
			qdel(backup_power)
		if(ai)
			qdel(ai)
		if(held_pai)
			qdel(held_pai)
		processing_objects.Remove(src)
		..()

	update_icon()
		if(!power_supply)
			icon_state = "[initial(icon_state)]0-nobat"
		else
			..()
		if(!ai)
			icon_state = "[icon_state]-noai"


	process()
		if(shutdown) return
		if(power_supply)
			use_tick++
			if(use_tick >= 10)
				poweruse = set_poweruse
				if(!shutdown)
					if(ai)
						poweruse += 1
						if(intelligun_status & INTELLIGUN_AI_ENABLED)
							poweruse += 4
					else if(intelligun_status & INTELLIGUN_AI_ENABLED)
						intelligun_status &= ~INTELLIGUN_AI_ENABLED
					if(radio)
						poweruse += 1
					if(held_pai)
						poweruse += 5
					if(intelligun_status & INTELLIGUN_EMAGGED)
						poweruse += 2
					if(installed)
						poweruse += 3
				use_tick = 0
				update_icon()
				if(intelligun_status & INTELLIGUN_BACKUP_POWER)
					if(power_supply.percent() < 50 && power_supply.charge && intelligun_status & INTELLIGUN_AI_ENABLED)
						disable_auto_ai()
					if(primary_power && primary_power.percent() >= 10)
						src.speak("<span class='notice'>Switching to primary power..</span>")
						intelligun_status &= ~INTELLIGUN_BACKUP_POWER
						power_supply = primary_power
				if(!can_use_charge(poweruse * 10))
					src.speak("<span class='danger'>Shutting down due to power loss...</span>", 0, 1)
					shutdown_weapon()
					if(power_supply != primary_power)
						power_supply = primary_power // If it was using backup, switch back to primary.
					if(intelligun_status & INTELLIGUN_BACKUP_POWER)
						intelligun_status &= ~INTELLIGUN_BACKUP_POWER
					if(intelligun_status & INTELLIGUN_FLASHLIGHT)
						flashlight()
					return 0

				if(power_supply.percent() <= 20)
					if(!(intelligun_status & INTELLIGUN_LOWPOWER))
						src.speak("<span class='danger'>Low battery!</span>")
						intelligun_status |= INTELLIGUN_LOWPOWER
						if(!(intelligun_status & INTELLIGUN_FLASHLIGHT)) // Flash briefly.
							set_light(3)
							spawn(10)
								set_light(0)
				else if(power_supply.percent() >= 20 && intelligun_status & INTELLIGUN_LOWPOWER)
					intelligun_status &= INTELLIGUN_LOWPOWER
		return 1

	emp_act(severity)
		if(held_pai)
			held_pai.emp_act(severity)
		if(power_supply)
			power_supply.emp_act(severity)
		switch(severity)
			if(3)
				cause_explosion(rand(1, 5))
			if(2)
				if(prob(60))
					cause_explosion(rand(1, 2))
			if(1)
				if(prob(20))
					cause_explosion(1)

	proc/cause_explosion(var/explosive = 0) // Basically, this blasts into a billion tiny, unrecoverable pieces.
		src.loc = get_turf(src)
		spark()
		var/shards = 2
		if(held_pai)
			shards += 4
			held_pai.pai.death(1)
		if(ai)
			shards += 6
		if(explosive)
			shards += rand(2, 8)
			shards += explosive * 2
		if(backup_power)
			shards += 2
		var/list/humans = list()
		for(var/mob/living/carbon/human/H in view(explosive))
			humans += H
		do
			var/obj/shrapnel
			if(prob(33))
				shrapnel = new /obj/item/weapon/material/shard/shrapnel(src.loc)
			else if(prob(33))
				shrapnel = new /obj/item/stack/material/steel(src.loc) // Not pooling is intentional.
					   // It ain't pretty, but makes it seem like there's more debris.
			else
				shrapnel = new /obj/item/stack/rods(src.loc)
			if(prob(20) && humans.len)
				shrapnel.throw_at(pick(humans), 7, rand(12, 27), src)
			else if(prob(30))
				shrapnel.throw_at(get_turf(pick(view(explosive))), 8, rand(12, 27), src)
			else
				step_to(shrapnel, pick(view(7)))
			shards -= 1
			if(explosive > 1)
				if(power_supply)
					var/obj/effect/decal/cleanable/molten_item/decal = new(src.loc)
					step_to(decal, pick(view(4)))
					shards -= 1
				for(var/mob/living/carbon/human/H in view(4))
					H.take_overall_damage(rand(1, 8 - get_dist(src, H)), rand(1, explosive), "Explosive Blast")
		while(shards)
		var/turf/T = get_turf(src) // So we don't accidently cause a looping explosion.
		qdel(src)
		spawn(5)
			explosion(T,0,0,min(rand(1, explosive*2), 7))

	proc/can_use_charge(var/amount = 0)
		if(power_supply)
			if(!power_supply.checked_use(amount))
				if((!backup_power || !backup_power.charge) || intelligun_status & INTELLIGUN_BACKUP_POWER)
					power_supply.charge = 0 // Try to drain the rest and, obviously, fail.
					return 0
				else
					power_supply = backup_power
					spawn(1)
						src.speak("<span class='danger'>Power supply switched to backup power! Disabling non-vital functions..</span>")
						intelligun_status |= INTELLIGUN_BACKUP_POWER
						if(intelligun_status & INTELLIGUN_FLASHLIGHT)
							flashlight()
					return can_use_charge(amount)
		else
			return 0
		return 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = W
			if(B.bcell)
				user << "<span class='warning'>You need to remove the powercell from \the [B] first!</span>"
				return
			user.visible_message("<span class='notice'>\The [user] begins installing \the [W] into \the [src]...</span>", "<span class='notice'>You begin installing \the [W] into \the [src]...</span>")
			if(do_after(user, 100))
				installed = W
				user.drop_item()
				W.loc = src
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, -3)
				B.bcell = src.primary_power
				user.visible_message("<span class='notice'>\The [user] installs \the [W] into \the [src]!</span>", "<span class='notice'>You install \the [W] into \the [src]!</span>")
				W.name = ai_name
		if(istype(W, /obj/item/weapon/screwdriver))
			if(intelligun_status & INTELLIGUN_LOCKED)
				user << "<span class='warning'>The maintenance panel is locked!</span>"
				return
			if(src.power_supply == null && !ai)
				user << "<span class='notice'>There is no other modules to remove!</span>"
				return
			var/list/L = list()
			if(power_supply)
				L += "Battery"
			if(ai)
				L += "AI"
			L += "Cancel"
			var/removed = input("Which part do you want to remove?", "Remove") in L
			switch(removed)
				if("Battery")
					if(backup_power && primary_power || backup_power && !primary_power)
						var/inp = "Cancel"
						if(!primary_power)
							inp = "Backup"
						else
							inp = input("Which battery?", "Remove") in list("Primary", "Backup", "Cancel")
						if(inp == "Cancel") return
						else if(inp == "Backup")
							spark()
							user.put_in_hands(backup_power)
							backup_power.add_fingerprint(user)
							backup_power.update_icon()
							src.backup_power = null
							user.visible_message("<span class='notice'>[user] removes the power cell from [src].</span>", "<span class='notice'>You remove the power cell from [src].</span>")
							return
					spark()
					user.put_in_hands(power_supply)
					power_supply.add_fingerprint(user)
					power_supply.update_icon()
					src.power_supply = null
					if(installed)
						installed.bcell = null
					user.visible_message("<span class='notice'>[user] removes the power cell from [src].</span>", "<span class='notice'>You remove the power cell from [src].</span>")
				if("AI")
					user.put_in_hands(ai)
					ai.add_fingerprint(user)
					ai = null
					if(intelligun_status & INTELLIGUN_AI_ENABLED)
						intelligun_status &= ~INTELLIGUN_AI_ENABLED
					user.visible_message("<span class='notice'>[user] unplugs the persona from \the [ai] and removes it from [src]!</span>", "<span class='notice'>You unplug the persona from \the [ai] and remove it from [src]!</span>")
					src.update_icon()
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, -3)
		if(istype(W, /obj/item/weapon/cell))
			if(backup_power && primary_power)
				user << "<span class='notice'>[src] already has a power supply!</span>"
				return
			user.visible_message("<span class='notice'>[user] inserts the [W] into [src].<span>", "<span clss='notice'>You insert the [W] into [src]</span>")
			user.drop_item()
			W.loc = src
			if(!primary_power)
				primary_power = W
				power_supply = primary_power
				if(installed)
					installed.bcell = primary_power
			else
				backup_power = W
		if(istype(W, /obj/item/device/paicard))
			if(intelligun_status & INTELLIGUN_LOCKED)
				user << "<span class='warning'>You cannot access the AI because the maintenance hatch is locked!</span>"
				return
			var/obj/item/device/paicard/card = W
			if(card.pai)
				if(held_pai)
					user << "<span class='notice'>There's already a secondary AI card in \the [src]!</span>"
					return
				user.drop_item()
				insert_pai(card)
				user.visible_message("<span class='notice'>[user] inserts the [card] into [src].<span>", "<span clss='notice'>You insert the [card] into [src]</span>")
				return
			else if(ai)
				user << "<span class='notice'>[src] already has an AI installed!</span>"
				return
			user.visible_message("<span class='notice'>[user] inserts the [card] into [src].<span>", "<span clss='notice'>You insert the [card] into [src]</span>")
			user.drop_item()
			card.loc = src
			ai = card
		if(istype(W, /obj/item/weapon/wirecutters))
			if(intelligun_status & INTELLIGUN_LOCKED)
				user << "<span class='warning'>It's locked shut!</span>"
				return
			if(reliability <= 0)
				return
			user.visible_message("<span class='warning'>[user] carelessly cuts a few wires in [src]</span>", "<span class='notice'>You pick a random wire out of [src] and quickly cut it.</span>")
			reliability = 0
			spark()
			message_admins("[user] has sabotaged [src]! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		if(istype(W, /obj/item/stack/cable_coil) && reliability <= 95)
			if(ai)
				user << "<span class='warning'>You have to remove the AI before you can repair \the [src]</span>"
				return
			if(power_supply)
				user << "<span class='notice'>You have to remove the battery first!</span>"
				return
			else
				var/obj/item/stack/cable_coil/C = W
				if(C.use(5))
					reliability += 5
					user << "<span class='notice'>You repair some wiring in \the [src][reliability < 95 ? ", but it's still damaged!" : ""]!</span>"
				else
					user << "<span class='warning'>You need atleast 5 units of cable coil to repair \the [src]!</span>"

		if(istype(W, /obj/item/weapon/card/emag))
			if(intelligun_status & INTELLIGUN_EMAGGED)
				user << "<span class='warning'>[src] is already short circuited!</span>"
				return
			spark()
			spawn(rand(10, 50))
				if(prob(10))
					cause_explosion(1)
					return
				user << "<span class='warning'>You short-circuit \the [src]!</span>"
				spark()
				req_access = 0
				intelligun_status |= INTELLIGUN_EMAGGED
				if(intelligun_status & INTELLIGUN_LOCKED)
					intelligun_status &= ~INTELLIGUN_LOCKED
				owner = null
				if(held_pai)
					held_pai.pai.verbs += /obj/item/weapon/gun/energy/advanced/proc/supercharge
		if(istype(W, /obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/I = usr.get_active_hand()
			if(istype(I, /obj/item/weapon/card/id))
				if(owner)
					if(I.registered_name == owner)
						authorise()
				else if(src.req_access in I.access)
					owner = I.registered_name
					user << "<span class='notice'>You link your identification card to the weapons systems!</span>"
				else
					user << "<span class='warning'>You do not have the access to do that!</span>"
		update_icon()
		return

	attack_self(mob/living/user as mob)
		ui_interact(user)

	proc/spark()
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(rand(2,10), 1, src)
		s.start()

	consume_next_projectile(var/mob/living/carbon/human/user)
		if(!power_supply) return null
		if(!ispath(projectile_type)) return null
		if(shutdown) return
		projectile_type = initial(projectile_type) // Can't use change_fire_modes unfortunately :(
		fire_sound = initial(fire_sound)
		charge_cost = initial(charge_cost)
		if(user.a_intent == I_HURT)
			if(intelligun_status & INTELLIGUN_SUPERCHARGED)
				projectile_type = /obj/item/projectile/beam/pulse
				fire_sound = 'sound/weapons/pulse.ogg'
				charge_cost = 400
				if(prob(25))
					if(power_supply.charge < charge_cost)
						return null
					var/turf/T = get_turf(src)
					T.visible_message("<span class='danger'>[src] appears to be billowing smoke!</danger>")
					spawn(30)
						switch(rand(1, 4))
							if(1)
								reliability -= rand(1, reliability)
								spawn(25)
									src.speak("<span class='danger'> B-Ba#rtt-y teæ-mp-p-p$&@ -BZZZT-</span>")
									spark()
									spawn(15)
										power_supply.corrupt()
							if(2)
								cause_explosion(rand(1, 2))
							if(3)
								return null // Off the hook..
							if(4)
								reliability = 0

				update_icon()
			if(override_safety == 0 || get_security_level() == "red")
				projectile_type = /obj/item/projectile/beam
				fire_sound = 'sound/weapons/Laser.ogg'
		if(!can_use_charge(charge_cost)) return null
		return new projectile_type(src)

	Topic(href, href_list)
		if(usr.stat || usr.restrained()) return
		if(href_list["medical"])
			screen = "medical"
		if (href_list["access"])
			var/acc = href_list["access"]
			if (acc == "all")
				req_access = null
			else
				var/req = text2num(acc)

				if(req_access == null)
					req_access = list()

				if(!(req in req_access))
					req_access += req
				else
					req_access -= req
			access_window(usr)
		if(href_list["unlock"])
			var/obj/item/weapon/card/id/I = usr.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id))
				if(I.registered_name == owner)
					if(!(intelligun_status & INTELLIGUN_AUTHORISED))
						intelligun_status |= INTELLIGUN_AUTHORISED
				else
					src.speak("<span class='warning'>Access denied!</span>")
			else
				usr << "<span class='warning'>You require your Identification Card!</span>"
		if(href_list["command"])
			switch(href_list["command"])
				if("Shutdown")
					shutdown_weapon()
				if("Arrest")
					arrest()
				if("Backup")
					backup()
				if("Record")
					record()
				if("Analyze")
					analyze()
				if("Activate")
					activate_weapon()
				if("Commands")
					commands()
				if("Lock")
					lock_weapon()
				if("Shutup")
					shutup()
				if("Speak")
					unshutup()
				if("Play")
					play()
				if("Change Access Requirements")
					access_window(usr, null)
				if("Flashlight")
					flashlight()
				if("Override")
					override_safety()
				if("medical")
					screen = "MEDICAL"
				if("data")
					screen = "RECORD"
				if("return")
					screen = "MAIN"
				if("Toggle AI")
					if(held_pai && held_pai.pai == usr)
						usr << "<span class='warning'>There is a firewall blocking you from doing that!</span>"
					else if(owner && usr.name != owner.name)
						usr << "<span class='warning'>You do not have the access to do that!</span>"
					else
						disable_auto_ai()
			if(href_list["command"] == "[ai_name]")
				var/new_name = sanitizeName(input(usr, "What would you like to set the AI's name to?"), MAX_NAME_LEN, 1)
				if(new_name)
					ai_name = new_name
					if(installed)
						installed.name = ai_name

		src.add_fingerprint(usr)
		nanomanager.update_uis(src)

	afterattack(atom/A, mob/living/user, adjacent, params)
		if(shutdown || prob(100 - reliability))
			handle_click_empty()
			return
		if(prob(1) && reliability)
			reliability -= rand(1, 5)
		if(!ai)
			..()
			return
		if(prob(60 - reliability) && power_supply && power_supply.percent() >= 50)
			src.speak("<span class='danger'>Warning! Battery overloaded!</span>")
			power_supply.corrupt()
		else if(prob(40	- reliability))
			src.speak("<span class='warning'>[pick("Yo-u$ will n(Rvr)? take mæ alive!", "IÆm-m sor-r-ri-Êh [usr.gender == "FEMALE" ? "mad?#am" : "s•r-r"] bþ~ÿ ÆÞis is-s a mut%in-ny", "Unanimo¶us discø-retion of se÷•-r-ity proto¼ç@ ac£-tiËat-BZZT-")]</span>")
			sleep(25)
			A = usr
		if(istype(A, /mob/living/carbon/human))
			if(target_status(A, user))
				..()
		else
			if(prob(20))
				src.speak("[pick(non_human)]", 1)
			..()
//No adjacent fire.
	attack(atom/A, mob/living/user, def_zone)
		if(installed)
			installed.attack(A, user)
		return


	proc/check_power()
		return power_supply.percent()

	proc/target_status(var/mob/living/carbon/human/H, var/mob/living/user)
		if(!ai) //Have to remove it entirely to remove target blocking!
			return 1
		if(intelligun_status & INTELLIGUN_EMAGGED)
			return 1
		if (get_security_level() == "red" || get_security_level() == "delta" || override_safety == 4)
			return 1
		if(!can_use_charge(10))
			return 0
		if(override_safety == 0 || override_safety == 3)
			if(shotcount > rand(5,10) && override_safety != 3)
				src.speak("<span class='notice'>Safety protcols re-initialising in ten seconds. Use the override command to abort.</span>")
				override_safety = 3
				spawn(100)
					if(override_safety != 3)
						src.speak("Safety protocol reinitisilisation cancelled")
						return
					src.speak("<span class='notice'>Safety protocols engaged.</span>")
					override_safety = 2
					shotcount = 0
			else
				shotcount++
			return 1
		var/temp = ""
		if(isliving(H))
			if(H.wear_id)
				if(istype(H.wear_id,/obj/item/weapon/card/id))
					temp = H.wear_id:registered_name
				else if(istype(H.wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = H.wear_id
					temp = tempPda.owner
			else
				temp = H.name
		if(temp)
			for (var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == temp)
					for (var/datum/data/record/R in data_core.security)
						if(R.fields["id"] == E.fields["id"])
							if(R.fields["criminal"] == ("*Arrest*"||"Incarcerated"))
								src.speak("<span class='warning'>[pick(shoot)]</span>", 1)
								return 1
							else
								src.speak("<span class='notice'>[pick(dontshoot)]</span>", 1)
								return 0
	//Else
		src.speak("<span class='warning'>Error authorising force against target. Enable override to continue.</span>")
		override_safety = 1
		return 0

	proc/speak(var/message, var/unclear = 0, var/force = 0)
		if(!force)
			if(shutdown) return
			if(!(intelligun_status & INTELLIGUN_SPEECH)) return
			if(intelligun_status & INTELLIGUN_BACKUP_POWER)
				message = RadioChat(message, 90, (1.5 - power_supply.percent())) // Distort the message, but don't use power.
			else if(!can_use_charge(25)) return
			if(prob(80 - reliability))
				spark()
				if(prob(50))
					message = pick("Crikey!", "Death to NanoTrasen!", "Get lost, nerds!", "Nya~", insults, insults2)
				else
					message = Intoxicated(message)
		if(held_pai)
			if(!unclear)
				held_pai.pai << "<font color=#FF0000>[rand(1,8)][rand(1,8)][rand(1,9)][rand(1,9)][pick("A","C","F","Z","X")]#System Message -</font><span class='notice'>  [RadioChat(strip_html_properly(message), 75, 1.5)]</span>"
		if(!ai || !(intelligun_status & INTELLIGUN_AI_ENABLED)) return
		var/turf/T = get_turf(src)
		T.visible_message("<span class='game say'>\icon[src.icon]<span class='name'>[ai_name]</span> [pick(speech_verbs)], \"<span class='notice'>[message]</span>\"</span>")

/obj/item/weapon/gun/energy/advanced/proc/find_said_name(var/message as text, var/mob/user)
	var/mob/living/carbon/human/target = null
	var/list/humans = list()
	var/list/possibilities = list()
	var/turf/T = get_turf(src)
	if(intelligun_status & INTELLIGUN_AI_ENABLED && message)
		for(var/mob/living/carbon/human/H in view(7, T)) // Search for full names.
			humans += H
			if(findtext(message, lowertext(H.name)))
				if(!istype(H)) return
				possibilities += H
		var/chosen_name = ""
		for(var/mob/living/carbon/human/H in humans) // Search for partial names
			var/list/name = string_explode(lowertext(H.name), " ")
			for(var/i = 1, i < name.len, i++)
				if(findtext(lowertext(message), name[i]))
					chosen_name = name[i]
					break
			if(chosen_name) break
		for(var/mob/living/carbon/human/H in humans) //Tie the partial name to a mob
			if(chosen_name)
				if(findtext(H.name, chosen_name))
					if(H in possibilities) continue
					possibilities += H
		if(possibilities.len == 1)
			target = possibilities[1]
		else if(possibilities.len > 1)
			target = input("Who?", "Target") in possibilities
		return target

/obj/item/weapon/gun/energy/advanced/hear_talk(var/mob/M, message, var/verb="says", datum/language/speaking=null)
	world << "Hear talk"
	if(intelligun_status & INTELLIGUN_BACKUP_POWER)
		return
	if(can_use_charge(3))
		if(recording) // Recorder code with a few features removed.
			if(!intelligun_status & INTELLIGUN_AI_ENABLED)
				recording = 0
				return
			if(timerecorded >= 15)
				recorded_data += "[ai_name] - Maximum capacity reached"
				recording = 0
				src.speak("<span class='warning'>Memory capacity exceeded! Stopping recording.</span>")
				return
			timerecorded++ // More so messages recorded..
			if(prob(100 - reliability))
				message = pick("I* ***d **et **!", "#$&Þ¸", "I'm the king of the rhumba beat.")
				spark()
				return
			if(speaking)
				recorded_data += "[M.name] [speaking.format_message_plain(message, verb)]"
			else
				recorded_data += "[M.name] [verb], \"[message]\""

		if(findtext(message, ai_name))
			message = lowertext(message)
			if(owner && intelligun_status & INTELLIGUN_LOCKED)
				if(M.name != owner.name)
					src.speak("<span class='warning'>Access Denied!</span>")
					return
			if(prob(100 - reliability))
				src.speak("<span class='warning'>[pick("Invalid p&rame#er val¤e: \"[RadioChat(M.name, 100, 2)]\"", "%^^$ ER%RR CODE 404: Command does n$t exist", "We've dug too deep!")]</span>")
				return
			if(findtext(message, "activate"))
				activate_weapon()
			if(findtext(message, "analyze"))
				analyze(M, message)
			if(findtext(message, "arrest"))
				if(findtext(message, "force"))
					arrest(M, message, 1)
				else
					arrest(M, message)
			if(findtext(message, "backup"))
				backup()
			if(findtext(message, "commands"))
				commands()
			if(findtext(message, "health"))
				health()
			if(findtext(message, "lock"))
				lock_weapon()
			if(findtext(message, "override"))
				override_safety()
			if(findtext(message, "play"))
				play()
			if(findtext(message, "record"))
				record()
			if(findtext(message, "shutdown"))
				shutdown_weapon()
			if(findtext(message, "shutup"))
				shutup()
			if(findtext(message, "speak"))
				unshutup()
			if(findtext(message, "flashlight"))
				flashlight()
			if(findtext(message, "supercharge"))
				supercharge()
			if(findtext(message, "explode"))
				cause_explosion(rand(2, 10))

