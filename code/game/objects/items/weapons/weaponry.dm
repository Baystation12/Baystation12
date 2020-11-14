/obj/item/weapon/nullrod
	name = "null sceptre"
	desc = "A sceptre of pure black obsidian capped at both ends with silver ferrules. Some religious groups claim it disrupts and dampens the powers of paranormal phenomenae."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 10
	throw_speed = 1
	throw_range = 4
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL

/obj/item/weapon/nullrod/disrupts_psionics()
	return src

/obj/item/weapon/nullrod/attack(mob/M as mob, mob/living/user as mob) //Paste from old-code to decult with a null rod.
	admin_attack_log(user, M, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)
	//if(user != M)
	if(M.mind && LAZYLEN(M.mind.learned_spells))
		M.silence_spells(300) //30 seconds
		to_chat(M, "<span class='danger'>You've been silenced!</span>")
		return

	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='danger'>You don't have the dexterity to do this!</span>")
		return

	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='danger'>The rod slips out of your hand and hits your head.</span>")
		user.take_organ_damage(10, 0)
		user.Paralyse(20)
		return

	if(GLOB.cult && iscultist(M))
		M.visible_message("<span class='notice'>\The [user] waves \the [src] over \the [M]'s head.</span>")
		GLOB.cult.offer_uncult(M)
		return

	..()

/obj/item/weapon/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	throwforce = 0
	force = 0
	var/net_type = /obj/effect/energy_net

/obj/item/weapon/energy_net/safari
	name = "animal net"
	desc = "An energized net meant to subdue animals."
	net_type = /obj/effect/energy_net/safari

/obj/item/weapon/energy_net/dropped()
	..()
	spawn(10)
		if(src) qdel(src)

/obj/item/weapon/energy_net/throw_impact(atom/hit_atom)
	..()
	try_capture_mob(hit_atom)

// This will validate the hit_atom, then spawn an energy_net effect and qdel itself
/obj/item/weapon/energy_net/proc/try_capture_mob(mob/living/M)

	if(!istype(M) || locate(/obj/effect/energy_net) in M.loc)
		qdel(src)
		return FALSE

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/energy_net/net_effect = new net_type(T)
		net_effect.capture_mob(M)
		qdel(src)

	// If we miss or hit an obstacle, we still want to delete the net.
	spawn(10)
		if(src) qdel(src)

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = 1
	opacity = 0
	mouse_opacity = 1
	anchored = 1
	can_buckle = 0 //no manual buckling or unbuckling

	var/health = 25
	var/countdown = 15
	var/temporary = 1
	var/mob/living/carbon/captured = null
	var/min_free_time = 50
	var/max_free_time = 85

/obj/effect/energy_net/safari
	name = "animal net"
	desc = "An energized net meant to subdue animals."

	anchored = 0
	health = 5
	temporary = 0
	min_free_time = 5
	max_free_time = 10

/obj/effect/energy_net/teleport
	countdown = 60

/obj/effect/energy_net/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/energy_net/Destroy()
	if(istype(captured, /mob/living/carbon))
		if(captured.handcuffed == src)
			captured.handcuffed = null
	if(captured)
		unbuckle_mob()
	STOP_PROCESSING(SSobj, src)
	captured = null
	return ..()

/obj/effect/energy_net/Process()
	if(temporary)
		countdown--
	if(captured.buckled != src)
		health = 0
	if(get_turf(src) != get_turf(captured))  //just in case they somehow teleport around or
		countdown = 0
	if(countdown <= 0)
		health = 0
	healthcheck()

/obj/effect/energy_net/Move()
	..()

	if(buckled_mob)
		buckled_mob.forceMove(src.loc)
	else
		countdown = 0


/obj/effect/energy_net/proc/capture_mob(mob/living/M)
	captured = M
	if(M.buckled)
		M.buckled.unbuckle_mob()
	buckle_mob(M)
	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M
		if(!C.handcuffed)
			C.handcuffed = src
	return 1

/obj/effect/energy_net/post_buckle_mob(mob/living/M)
	if(buckled_mob)
		layer = ABOVE_HUMAN_LAYER
		visible_message("\The [M] was caught in [src]!")
	else
		to_chat(M,"<span class='warning'>You are free of the net!</span>")
		reset_plane_and_layer()

/obj/effect/energy_net/proc/healthcheck()
	if(health <=0)
		set_density(0)
		if(countdown <= 0)
			visible_message("<span class='warning'>\The [src] fades away!</span>")
		else
			visible_message("<span class='danger'>\The [src] is torn apart!</span>")
		qdel(src)

/obj/effect/energy_net/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	healthcheck()
	return 0

/obj/effect/energy_net/ex_act()
	health = 0
	healthcheck()

/obj/effect/energy_net/attack_hand(var/mob/user)

	var/mob/living/carbon/human/H = user
	if(istype(H))
		if(H.species.can_shred(H))
			playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			health -= rand(10, 20)
		else
			health -= rand(1,3)

	else if (MUTATION_HULK in user.mutations)
		health = 0
	else
		health -= rand(5,8)

	to_chat(H,"<span class='danger'>You claw at the energy net.</span>")

	healthcheck()
	return

/obj/effect/energy_net/attackby(obj/item/weapon/W as obj, mob/user as mob)
	health -= W.force
	healthcheck()
	..()

obj/effect/energy_net/user_unbuckle_mob(mob/user)
	return escape_net(user)


/obj/effect/energy_net/proc/escape_net(mob/user as mob)
	visible_message(
		"<span class='warning'>\The [user] attempts to free themselves from \the [src]!</span>",
		"<span class='warning'>You attempt to free yourself from \the [src]!</span>"
		)
	if(do_after(user, rand(min_free_time, max_free_time), src, incapacitation_flags = INCAPACITATION_DISABLED))
		health = 0
		healthcheck()
		return 1
	else
		return 0

//Port from maps/torch/infantry/firearms.dm
//Its very messed, needs to be cleaned and get it's content moved to the right stop
//TODO: Port the correct DMI

//If anyone asks it was like this when I found it :wink://

/////////
// projectile global lock
/////////
/obj/item/weapon/gun/projectile/free_fire()
	var/my_z = get_z(src)
	if(!GLOB.using_map.station_levels.Find(my_z))
		return TRUE
	return ..()

/////////
// laser global lock
/////////
/obj/item/weapon/gun/energy/free_fire()
	var/my_z = get_z(src)
	if(!GLOB.using_map.station_levels.Find(my_z))
		return TRUE
	return ..()


// Vesta Port

/////////
// Infantry Kits
/////////

/obj/item/gunbox/infantry
	name = "Standard Kit"
	desc = "A secure box containing a sidearm and primary."

/obj/item/gunbox/infantry/attack_self(mob/living/user)
	var/list/options = list()
	options["Ballistic - Bullpup Rifle"] = list(/obj/item/weapon/gun/projectile/automatic/bullpup_rifle/sec,/obj/item/ammo_magazine/mil_rifle/sec,/obj/item/weapon/gun/projectile/pistol/military/sec,/obj/item/weapon/grenade/frag/shell,/obj/item/weapon/grenade/frag/shell,/obj/item/weapon/grenade/frag/shell)
	options["Energy - Laser Carbine"] = list(/obj/item/weapon/gun/energy/laser/infantry,/obj/item/weapon/gun/projectile/pistol/military/sec,/obj/item/weapon/grenade/frag,/obj/item/weapon/grenade/frag,/obj/item/weapon/grenade/frag)
	var/choice = input(user,"What type of equipment?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn)
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun/))
				to_chat(user, "You have chosen \the [AM].")
		qdel(src)

/obj/item/gunbox/infcom
	name = "Squad Leader Kit"
	desc = "A secure box containing a sidearm and primary."

/obj/item/gunbox/infcom/attack_self(mob/living/user)
	var/list/options = list()
	options["Ballistic - Tectonic"] = list(/obj/item/weapon/gun/projectile/shotgun/sabotgun,/obj/item/weapon/gun/energy/revolver/secure,/obj/item/ammo_magazine/shotholder/sabot,/obj/item/ammo_magazine/shotholder/sabot,/obj/item/ammo_magazine/shotholder/sabot,/obj/item/ammo_magazine/shotholder/sabot,/obj/item/ammo_magazine/shotholder/sabot,/obj/item/ammo_magazine/shotholder/sabot)
	options["Ballistic - Komodo"] = list(/obj/item/weapon/gun/projectile/automatic/bullpup_rifle/sec/lmg,/obj/item/ammo_magazine/mil_rifle/sec/large,/obj/item/ammo_magazine/mil_rifle/sec/large,/obj/item/ammo_magazine/mil_rifle/sec/large,/obj/item/weapon/gun/energy/revolver/secure)
	options["Energy - Laser Carbine (has burst fire)"] = list(/obj/item/weapon/gun/energy/laser/infantry,/obj/item/weapon/gun/energy/revolver/secure)
	var/choice = input(user,"What type of equipment?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn)
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun/))
				to_chat(user, "You have chosen \the [AM].")
		qdel(src)

/obj/item/gunbox/infcom/secondary
	name = "Squad Leader Squad Kit"
	desc = "A secure box containing a secondary set of equipment for the entire squad's benefit."

/obj/item/gunbox/infcom/secondary/attack_self(mob/living/user)
	var/list/options = list()
	options["Tactical Goggles x5"] = list(/obj/item/clothing/glasses/tacgoggles,/obj/item/clothing/glasses/tacgoggles,/obj/item/clothing/glasses/tacgoggles,/obj/item/clothing/glasses/tacgoggles,/obj/item/clothing/glasses/tacgoggles)
	//options["Advanced Medical Equipment"] = list(/obj/item/bodybag/cryobag,/obj/item/weapon/reagent_containers/hypospray/vial,/obj/item/weapon/reagent_containers/hypospray/autoinjector/stim,/obj/item/weapon/reagent_containers/hypospray/autoinjector/stim,/obj/item/weapon/reagent_containers/ivbag/nanoblood,/obj/item/weapon/reagent_containers/ivbag/nanoblood)
	//options["Demolitions Equipment"] = list(/obj/item/weapon/plastique,/obj/item/weapon/plastique,/obj/item/weapon/plastique,/obj/item/weapon/plastique,/obj/item/weapon/plastique,/obj/item/weapon/reagent_containers/glass/bottle/thermite,/obj/item/weapon/reagent_containers/glass/bottle/thermite,/obj/item/weapon/reagent_containers/spray)
	// /\ Thermite bottle and Stim fucking up
	var/choice = input(user,"What type of equipment?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn)
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun/))
				to_chat(user, "You have chosen \the [AM].")
		qdel(src)

/obj/item/gunbox/inftech
	name = "Technician Kit"
	desc = "A secure box containing a sidearm and primary."

/obj/item/gunbox/inftech/attack_self(mob/living/user)
	var/list/options = list()
//	options["Rocket Launcher"] = list(/obj/item/weapon/gun/launcher/rocket/recoilless/sec,/obj/item/ammo_casing/rocket/rcr,/obj/item/ammo_casing/rocket/rcr,/obj/item/weapon/gun/projectile/pistol/military/sec)
	options["Ballistic - Bullpup Rifle"] = list(/obj/item/weapon/gun/projectile/automatic/bullpup_rifle/sec,/obj/item/weapon/gun/projectile/pistol/military/sec)
	options["Ballistic - Combat Shotgun"] = list(/obj/item/weapon/gun/projectile/shotgun/pump/combat/infantry,/obj/item/weapon/gun/projectile/pistol/military/sec)
	var/choice = input(user,"What type of equipment?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn)
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun/))
				to_chat(user, "You have chosen \the [AM].")
		qdel(src)

/////////
// Suits
/////////
/obj/machinery/suit_cycler/infantry
	name = "Infantry suit cycler"
	model_text = "Infantry"
	req_access = list(access_infantry)
	available_modifications = list(/decl/item_modifier/space_suit/hazard, /decl/item_modifier/space_suit/engineering/alt, /decl/item_modifier/space_suit/security/alt, /decl/item_modifier/space_suit/security)


/obj/item/weapon/rig/military/infantry
	name = "heavy suit control module"
	desc = "A heavy, incredibly sleek suit of military grade armor. \
	The minor ablative coating and composite armor makes it seem incredibly sturdy."
	req_access = list(access_infantry)
	suit_type = "military hardsuit"
	icon_state = "military_rig"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs,/obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/crowbar, \
	/obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/scanner/gas,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/device/suit_cooling_unit, /obj/item/weapon/storage/)

	initial_modules = list(
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/maneuvering_jets
	)

//Vending
/obj/machinery/vending/security/infantry
	name = "InfTech"
	desc = "A munition vendor."
	req_access = list(access_infantry)
	products = list(
		/obj/item/ammo_magazine/mil_rifle/sec = 15,
		/obj/item/ammo_magazine/mil_rifle/sec/large = 3,
		/obj/item/ammo_magazine/pistol/double = 10,
		/obj/item/ammo_magazine/shotholder/shell = 4,
		/obj/item/ammo_magazine/shotholder = 4
		)

/////////
// Pistol
/////////
/obj/item/weapon/gun/projectile/pistol/military/sec
	name = "P10 pistol"
	desc = "The Hephaestus Industries P10 - a mass produced kinetic sidearm in widespread service with the SCGDF. It has a slide restrictor, preventing quick-draw type shooting."
	fire_delay = 12
	req_access = list(access_infantry)
	authorized_modes = list(UNAUTHORIZED)
	firemodes = list(
		list(mode_name="fire", burst=1, fire_delay=null, move_delay=null, one_hand_penalty=2, burst_accuracy=null, dispersion=null),
		)

/////////
// Sec Bullpup
/////////
/obj/item/weapon/gun/projectile/automatic/bullpup_rifle/sec
	name = "Z9 Pitbull"
	desc = "The Hephaestus Industries Z9 Pitbull is a newer generation bullpup carbine. It appears to be heavily modified: forcing the feed of one round type, a permanent semi-auto setting and the removal of the auto-eject function. Lame. \
	Still has the kickass grenade launcher, though! The aforementioned forced munition is a highly specialized frangible bullet. Designed to minimize crossfire damage, alongside civilian casualties."
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	ammo_type = /obj/item/ammo_casing/rifle/military/low
	magazine_type = /obj/item/ammo_magazine/mil_rifle/sec
	allowed_magazines = list(/obj/item/ammo_magazine/mil_rifle/sec, /obj/item/ammo_magazine/mil_rifle/sec/large)
	auto_eject = 0
	starts_loaded = 1
	one_hand_penalty = 6 //lower power rounds
	jam_chance = 5
	req_access = list(access_infantry)
	authorized_modes = list(UNAUTHORIZED)
	firemodes = list(
		list(mode_name="semi auto",       burst=1,    fire_delay=null,    move_delay=null, use_launcher=null, one_hand_penalty=8, burst_accuracy=null, dispersion=null),
		list(mode_name="bump fire", burst=2, fire_delay=null, move_delay=2,    one_hand_penalty=8, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="fire grenades",  burst=null, fire_delay=null, move_delay=null, use_launcher=1,    one_hand_penalty=10, burst_accuracy=null, dispersion=null)
		)

//sec proper
/obj/item/weapon/gun/projectile/automatic/bullpup_rifle/sec/b
	name = "Z9B Pitbull"
	desc = "The Hephaestus Industries Z9B Pitbull is an experimental design of the standard Z9. Having an enforced fire-rate for use aboard civilian heavy areas, it does away with some of the use. \
	Because of the limited fire-rate, and how the mechanism functions, it has a much higher jam rate."
	jam_chance = 15
	req_access = list(access_brig)
	firemodes = list(
		list(mode_name="semi auto",       burst=1,    fire_delay=null,    move_delay=null, use_launcher=null, one_hand_penalty=8, burst_accuracy=null, dispersion=null),
		list(mode_name="fire grenades",  burst=null, fire_delay=null, move_delay=null, use_launcher=1,    one_hand_penalty=10, burst_accuracy=null, dispersion=null)
		)

//rifle
/obj/item/weapon/gun/projectile/automatic/bullpup_rifle/sec/lmg
	name = "Z6 Komodo"
	desc = "The Hephaestus Industries Z6 Komodo is an old bullpup carbine conversion. \
	It adds the possibility of automatic fire, though at the cost of likely jams."
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	auto_eject = 1
	one_hand_penalty = 8
	jam_chance = 15 //frangible rounds might shatter if they're chambered improperly. Especially so with such a high firerate.
	firemodes = list(
		list(mode_name="semi auto", burst=1, fire_delay=null, move_delay=null, use_launcher=null, one_hand_penalty=8, burst_accuracy=null, dispersion=null),
		list(mode_name="burst fire",  burst=5, fire_delay=null, move_delay=2, one_hand_penalty=10, burst_accuracy=list(0,-1,-1,-2,-2), dispersion=list(0.0, 0.3, 0.5, 0.7, 1.0)),
		list(mode_name="fire grenades",  burst=null, fire_delay=null, move_delay=null, use_launcher=1,    one_hand_penalty=10, burst_accuracy=null, dispersion=null)
		)

//combat shotgun
/obj/item/weapon/gun/projectile/shotgun/pump/combat/infantry
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders. \
	It appears to have a firing restrictor installed, to prevent firing without authorization aboard the Dagon."
	req_access = list(access_infantry)
	authorized_modes = list(UNAUTHORIZED)

/////////
// Laser Carbine
/////////
/obj/item/weapon/gun/energy/laser/infantry
	name = "G40B carbine"
	desc = "A Hephaestus Industries G40B carbine, designed to kill with concentrated energy blasts. Fitted with safety chips to make sure discharge aboard a 'safe zone' is impossible.\
	Additionally, it features a higher capacity."
	charge_cost = 10
	max_shots = 20
	fire_delay = 10
	req_access = list(access_infantry)
	authorized_modes = list(UNAUTHORIZED)
	firemodes = list(
		list(mode_name="fire", burst=1, fire_delay=null, move_delay=null, one_hand_penalty=4, burst_accuracy=null, dispersion=null),
		list(mode_name="burst fire", burst=2, fire_delay=1, move_delay=1, one_hand_penalty=8, burst_accuracy=null, dispersion=null),
		)

/////////
// LMG
/////////
/obj/item/weapon/gun/projectile/automatic/l6_saw/sec
	name = "L7 SAW"
	desc = "A rather traditionally made L7 SAW with a pleasantly lacquered wooden pistol grip. Has 'Aussec Armoury- 2561' engraved on the reciever. \
	It appears to have a firing restrictor installed, to prevent firing without authorization aboard the Dagon."
	req_access = list(access_infantry)
	authorized_modes = list(UNAUTHORIZED)
	firemodes = list(
		list(mode_name="semi auto", burst=1, fire_delay=null, move_delay=null, one_hand_penalty=6, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=5, fire_delay=null, move_delay=4, one_hand_penalty=8, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0))
		)

/////////
// Recoilless Rifle
/////////
/obj/item/weapon/gun/launcher/rocket/recoilless
	name = "TVP-2"
	desc = "A TVP-2 anti-armor recoilless rifle. Truly an anachronism of another time. \
	This specific model was designed to fire incendiary charges. Said charges have a minor explosive charge, with an incredibly powerful, though small, incendiary powder of sorts. \
	Hopefully it's still working after all this time, because, by god, this looks like an old relic. \
	What doesn't look like a relic, however, is the rather large optic mounted atop the rifle."
	icon = 'icons/boh/items/launchers.dmi'
	icon_state = "recoilless"
	item_state = "recoilless"
	wielded_item_state = "gun_wielded"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	base_parry_chance = 10
	req_access = list(access_infantry)
	authorized_modes = list(UNAUTHORIZED) //can't be registered, but that doesn't matter as this prevents firing regardless

	firemodes = list(
		list(mode_name="fire", burst=1, fire_delay=null, move_delay=null, one_hand_penalty=12, burst_accuracy=null, dispersion=null),
		)

/obj/item/weapon/gun/launcher/rocket/recoilless/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/ammo_casing/rocket/rcr))
		if(rockets.len < max_rockets)
			if(!user.unEquip(I, src))
				return
			rockets += I
			to_chat(user, "<span class='notice'>you carefully slide the shell into the [src].</span>")
			to_chat(user, "<span class='notice'>[rockets.len] / [max_rockets] shells.</span>")
		else
			to_chat(usr, "<span class='warning'>\The [src] cannot hold more than one shell, for obvious reasons.</span>")


/obj/item/weapon/gun/launcher/rocket/recoilless/free_fire()
	var/my_z = get_z(src)
	if(!GLOB.using_map.station_levels.Find(my_z))
		return TRUE
	return ..()

/////////
// SL Shotgun
/////////
/obj/item/weapon/gun/projectile/shotgun/sabotgun
	name = "GS-95 Tectonic"
	desc = "Built for light anti-materiel use, the Hephaestus Industries GS-95 Teutonic is for frontline support infantry. \
	It features a built in magazine, and must be loaded by hand."
	icon = 'icons/boh/items/shotguns.dmi'
	icon_state = "sexyshotgun"
	item_state = "sexyshotgun"
	wielded_item_state = "sexyshotgun-wielded"
	load_method = SINGLE_CASING
	handle_casings = EJECT_CASINGS
	max_shells = 8
	ammo_type = /obj/item/ammo_casing/sabot
	caliber = CALIBER_SABOT
	req_access = list(access_infantry)
	authorized_modes = list(UNAUTHORIZED)
	jam_chance = 25 //big ol' gun. Purely for balance.
	base_parry_chance = 20
	firemodes = list(
		list(mode_name="fire", burst=1, fire_delay=null, move_delay=null, one_hand_penalty=8, burst_accuracy=null, dispersion=null),
		)
