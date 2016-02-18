#define INTELLIGUN_BACKUP_POWER 1
#define INTELLIGUN_PLAYING 2
#define INTELLIGUN_ANALYZING 4
#define INTELLIGUN_LOCKED 8
//#define INTELLIGUN_SHUTDOWN 16
#define INTELLIGUN_SPEECH 32
#define INTELLIGUN_AUTHORISED 64
#define INTELLIGUN_SUPERCHARGED 128
#define INTELLIGUN_EMAGGED 256
#define INTELLIGUN_AI_ENABLED 512
#define INTELLIGUN_FLASHLIGHT 1024
#define INTELLIGUN_LOWPOWER 2048

/obj/item/weapon/gun/energy/advanced/proc/insert_pai(var/obj/item/device/paicard/card)
	if(held_pai) return
	if(card.pai)
		card.loc = src
		held_pai = card
		card.pai << "You've been inserted into \the [src]"
		card.pai << "Uploading control software..."
		spawn(50)
			if(intelligun_status & INTELLIGUN_SUPERCHARGED && prob(50))
				spark()
				card.pai << "<span class='danger'>You feel a sudden surge of electricity pulse through your circuits!</span>"
				spawn(30)
					card.pai.emp_act(rand(1, 3))
			if(prob(100 - reliability))
				spark()
				src.speak("<span class='danger'>Unidentified foreign software detected! Beginning purge..</span>")
				spawn(rand(20, 60))
					if(prob(40) && held_pai)
						held_pai << "<span class='danger'>You feel a sudden surge of electricity pulse through your circuits!</span>"
						spawn(15)
							if(held_pai)
								held_pai.emp_act(rand(1,3))
								spawn(10)
									if(held_pai)
										eject_pai()
					else
						card.pai << "<span class='warning'>You feel a sudden pulse of electricity, and disconnect your wiring before you are damaged!</span>"
						eject_pai()
				return
			card.pai << "Initiating control software.."
			spawn(50)
				held_pai.pai.verbs += /obj/item/weapon/gun/energy/advanced/proc/access_interface
				held_pai.pai.verbs += /obj/item/weapon/gun/energy/advanced/proc/speech
				held_pai.pai.verbs += /obj/item/weapon/gun/energy/advanced/verb/eject_pai
				held_pai.pai.verbs += /obj/item/weapon/gun/energy/advanced/proc/hack_into
				held_pai.pai.verbs += /obj/item/weapon/gun/energy/advanced/proc/authorise
				card.pai << "Initiated!"

/obj/item/weapon/gun/energy/advanced/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nano_ui/master_ui = null, var/datum/topic_state/state = default_state)
	var/list/data = list()
	data["can_open"] = 1
	if(intelligun_status & INTELLIGUN_LOCKED)
		if(!(held_pai && user == held_pai.pai))
			if(!(intelligun_status & INTELLIGUN_AUTHORISED))
				data["can_open"] = 0
	data["speech"] = (intelligun_status & INTELLIGUN_SPEECH ? "Enabled!" : "Disabled!")
	data["integrity"] = reliability
	if(owner)
		data["owner"] = owner.name
	else
		data["owner"] = "NONE"
	data["ai_name"] = ai_name
	data["medical_data"] = medical_data
	data["poweruse"] = poweruse
	if(power_supply)
		data["powerleft"] = power_supply.charge
		data["powertime"] = round((power_supply.charge / poweruse) / 60)
	else
		data["powerleft"] = 0
		data["powertime"] = "NONE"
	data["recorded_data"] = recorded_data
	data["state"] = screen
	data["ai_enabled"] = (intelligun_status & INTELLIGUN_AI_ENABLED ? "Enabled!" : "Disabled!")
	data["commands"] = commands
	data["locked"] = (intelligun_status & INTELLIGUN_LOCKED ? "Enabled!" : "Disabled!")
	data["powerstate"] = 0
	data["ai_status"] = pick(joke, joke2, insults, insults2)
	if(intelligun_status & INTELLIGUN_BACKUP_POWER)
		data["powerstate"] = 4
	else if(intelligun_status & INTELLIGUN_LOWPOWER)
		data["powerstate"] = 3
	else if(power_supply.percent() <= 50)
		data["powerstate"] = 2
	else if(!backup_power)
		data["powerstate"] = 1


	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open, state)
	if(!ui)
		ui = new(user, src, ui_key, "intelligun.tmpl", "Intelligun", 445, 680, state = state)
		ui.set_initial_data(data)
		ui.open()

/obj/item/weapon/gun/energy/advanced/proc/disable_auto_ai()
	speak("<span class='notice'>Automatic AI [intelligun_status & INTELLIGUN_AI_ENABLED == 1 ? "dis" : "en"]abled</span>", 0, 1)
	if(intelligun_status & INTELLIGUN_BACKUP_POWER)
		if(power_supply.percent() < 50 && power_supply.charge && !(intelligun_status & INTELLIGUN_AI_ENABLED))
			src.speak("<span class='danger'>This feature is disabled due to power loss!</span>", 0, 1)
			return
	if(held_pai && usr == held_pai.pai)
		usr << "<span class='warning'>You don't have the access to do that!</span>"
		return
	spawn(5)
		if(intelligun_status & INTELLIGUN_AI_ENABLED)
			intelligun_status &= ~INTELLIGUN_AI_ENABLED
		else intelligun_status |= INTELLIGUN_AI_ENABLED

/obj/item/weapon/gun/energy/advanced/proc/shutdown_auto_ai()
	set name = "Shutdown Weapon Auto-AI"
	set desc = "Disable the automatic AI Systems"
	set category = "pAI Commands"
	var/turf/T = get_turf(src)
	var/obj/item/weapon/gun/energy/advanced/gun
	for(var/obj/item/weapon/gun/energy/advanced/A in T)
		if(A.held_pai.pai == usr) gun = A
	if(!gun) return

	if(gun.intelligun_status & INTELLIGUN_AI_ENABLED)
		gun.speak("AI Force Shutdown Activated!")
		gun.intelligun_status &= ~INTELLIGUN_AI_ENABLED
	usr.verbs -= /obj/item/weapon/gun/energy/advanced/proc/shutdown_auto_ai


/obj/item/weapon/gun/energy/advanced/proc/access_window(var/mob/user as mob, var/obj/item/weapon/card/id/P)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/weapon/card/id/I = H.get_idcard()
		if(P) I = P
		if(I)
			if(access_hop in I.access)
				var/t1 = ""
				var/list/accesses = get_all_accesses()
				for(var/acc in accesses)
					var/aname = get_access_desc(acc)
					if (!req_access || req_access.len || !(acc in req_access))
						t1 += "<a href='?src=\ref[src];access=[acc]'>[aname]</a><br>"
					else
						t1 += "<a style='color: red' href='?src=\ref[src];access=[acc]'>[aname]</a><br>"
				t1 += text("<p><a href='?src=\ref[];close=1'>Close</a></p>\n", src)
				user << browse(t1, "window=airlock_electronics")
				onclose(user, "airlock")
			else
				H << "<span class='warning'>You do not have the access to change that!</span>"
		else
			H << "<span class='warning'>You require your ID	to do that!</span>"

/obj/item/weapon/gun/energy/advanced/proc/authorise()
	set name = "Authorise Interface"
	set desc ="Allow access to the interface when it's locked."
	set category = "pAI Commands"

	var/turf/T = get_turf(src)
	var/obj/item/weapon/gun/energy/advanced/gun
	for(var/obj/item/weapon/gun/energy/advanced/A in T.loc)
		if(A.held_pai.pai == usr) gun = A
	if(!gun) return
	if(gun.intelligun_status & INTELLIGUN_AUTHORISED)
		gun.intelligun_status &= INTELLIGUN_AUTHORISED
	else gun.intelligun_status |= INTELLIGUN_AUTHORISED
	gun.speak("Interface [gun.intelligun_status & INTELLIGUN_AUTHORISED ? "" : "un"]locked")

/obj/item/weapon/gun/energy/advanced/proc/speech()
	set name = "Speak"
	set desc ="Allows you to send a message through the AI (including radio)"
	set category = "pAI Commands"
	var/message = input("What do you want to say?", "Message") as text
	var/turf/T = get_turf(src)
	var/obj/item/weapon/gun/energy/advanced/gun
	for(var/obj/item/weapon/gun/energy/advanced/A in T.loc)
		if(A.held_pai.pai == usr) gun = A
	if(!gun) return
	if(findtext(message, ";", 1, 1) || findtext(message, ":s", 1, 1))
		gun.radio.autosay(message, ai_name, "Security")
		return
	spawn(0) gun.speak(message, 0, 1)

/obj/item/weapon/gun/energy/advanced/verb/eject_pai()
	set category = "Object"
	set name = "Remove pAI"
	set src in usr
	if(!src.held_pai)
		usr << "There is no pAI in \the [src]!"
		return
	if(src.intelligun_status & INTELLIGUN_LOCKED)
		usr << "[src] is locked shut!"
		return
	src.held_pai.loc = get_turf(src)
	if(istype(usr, /mob/living/carbon/human))
		usr.put_in_hands(src.held_pai)
	else
		src.visible_message("<span class='warning'>[src.held_pai] drops onto the ground!</span>")
	src.held_pai = null
	held_pai.pai.verbs -= /obj/item/weapon/gun/energy/advanced/proc/access_interface
	held_pai.pai.verbs -= /obj/item/weapon/gun/energy/advanced/proc/speech
	held_pai.pai.verbs -= /obj/item/weapon/gun/energy/advanced/verb/eject_pai
	held_pai.pai.verbs -= /obj/item/weapon/gun/energy/advanced/proc/hack_into
	held_pai.pai.verbs -= /obj/item/weapon/gun/energy/advanced/proc/authorise
	held_pai.pai.verbs -= /obj/item/weapon/gun/energy/advanced/proc/force_override
	held_pai.pai.verbs -= /obj/item/weapon/gun/energy/advanced/proc/override_owner
	held_pai.pai.verbs -= /obj/item/weapon/gun/energy/advanced/proc/hack_into

/obj/item/weapon/gun/energy/advanced/proc/access_interface()
	set category = "pAI Commands"
	set name = "Access Control Software"
	set desc = "Access the control software"
	var/turf/T = get_turf(src)
	var/obj/item/weapon/gun/energy/advanced/gun
	for(var/obj/item/weapon/gun/energy/advanced/A in T.loc)
		if(A.held_pai.pai == usr) gun = A
	if(!gun) return
	gun.ui_interact(usr, state = contained_state)

/obj/item/weapon/gun/energy/advanced/proc/hack_into()
	set category = "pAI Commands"
	set name = "Hack"
	set desc = "Hack into the weaponry's systems!"
	var/turf/T = get_turf(src)
	var/obj/item/weapon/gun/energy/advanced/gun
	for(var/obj/item/weapon/gun/energy/advanced/A in T.loc)
		if(A.held_pai.pai == usr) gun = A
	if(!gun) return

	usr << "<span class='warning'>Attempting to upload override software...</span>"
	spawn(100)
		if(gun.held_pai.pai != usr) return
		if(gun.intelligun_status & INTELLIGUN_AI_ENABLED)
			gun.speak("<span class='notice'>Foreign software detected! Deleting..</span>")
			spawn(20)
				usr << "<span class='warning'>Override software unresponsive. Disabling AI programming..</span>"
				spawn(100)
					if(gun.held_pai.pai != usr) return
					if(prob(60))
						gun.speak("<span class='danger'>Deletion interrupted. Malware discovered. Deleting: [usr.name]</span>")
						if(prob(40))
							gun.held_pai.emp_act(rand(1,3))
						else
							usr << "<span class='notice'>You quickly pulse the weapon's AI, halting the deletion process.</span>"
							gun.reliability -= (rand(1, 20))
							gun.spark()
							spawn(15)
								gun.speak("<span class='danger'>-BZZT-</span>", 0, 1)
						return
					usr.verbs += /obj/item/weapon/gun/energy/advanced/proc/shutdown_auto_ai
					usr << "<span class='warning'>AI Programming shutdown pending activation.</span>"
					return
		else
			usr << "<span class='notice'>Override Software uploaded. Disabling firewall..</span>"
			spawn(rand(80,150))
				gun.spark()
				usr << "<span class='notice'>Firewall disabled. Overriding security matrix..</span>"
				spawn(rand(80, 150))
					if(gun.held_pai.pai != usr) return
					gun.spark()
					usr << "<span class='notice'>Security matrix overridden. Connecting to autonomous AI systems...</span>"
					spawn(20)
						gun.held_pai.pai.verbs += /obj/item/weapon/gun/energy/advanced/proc/force_override
						gun.held_pai.pai.verbs += /obj/item/weapon/gun/energy/advanced/proc/override_owner
						gun.held_pai.pai.verbs -= /obj/item/weapon/gun/energy/advanced/proc/hack_into
						gun.speak("AI unit found: [gun.held_pai.pai] connected. Welcome.")

/obj/item/weapon/gun/energy/advanced/proc/force_override()
	set name = "Override Safety"
	set category = "Systems"
	set desc = "Override the in-built security systems."
	var/turf/T = get_turf(src)
	var/obj/item/weapon/gun/energy/advanced/gun
	for(var/obj/item/weapon/gun/energy/advanced/A in T.loc)
		if(A.held_pai.pai == usr) gun = A
	if(!gun) return
	gun.override_safety = 4
	usr << "<span class='notice'>In-built security circuit fried!</span>"
	usr.verbs -= /obj/item/weapon/gun/energy/advanced/proc/force_override

/obj/item/weapon/gun/energy/advanced/proc/override_owner()
	set name = "Override Control"
	set category = "Systems"
	set desc = "Override the manual control system."
	var/turf/T = get_turf(src)
	var/obj/item/weapon/gun/energy/advanced/gun
	for(var/obj/item/weapon/gun/energy/advanced/A in T.loc)
		if(A.held_pai.pai == usr) gun = A
	if(!gun) return
	gun.owner = null
	usr << "<span class='notice'>Manual control overriden.</span>"
	if(gun.intelligun_status & INTELLIGUN_LOCKED)
		gun.intelligun_status &= INTELLIGUN_LOCKED
	gun.req_access = list(0)
	usr.verbs -= /obj/item/weapon/gun/energy/advanced/proc/override_owner




