
//Consoles

/obj/machinery/mac_cannon/ammo_loader/plasma_cannon
    weapon_name = "Heavy Plasma Cannon"
    name = "Loading Console"
    desc = "A console used for the loading of charged plasma shells into the cannon."
    icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
    icon_state = "covie_console"
    load_sound = 'code/modules/halo/sounds/plasma_cannon_loading.ogg'
    ammo_cap = 3
    var/ammo_count = 0

    New()
        ..()
        ammo_count = 0

    attack_hand(mob/user)
        ..()
        if(ammo_count >= ammo_cap)
            to_chat(user, "<span class='notice'>You load a plasma charge into [src].</span>")
            return
        ammo_count++
        to_chat(user, "<span class='notice'>You load a plasma charge into [src].</span>")

/obj/machinery/overmap_weapon_console/mac/plasma_cannon
    name = "Plasma Cannon Fire Control"
    desc = "A console used to control the firing of the plasma cannon. Fires a burst of three plasma shells."
    icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
    icon_state = "covie_console"
    fire_sound = 'code/modules/halo/sounds/plasma_cannon_fire.ogg'
    fired_projectile = /obj/item/projectile/overmap/plasma_shell
    requires_ammo = 1
    accelerator_overlay_icon_state = "plasma_cannon_firing"
    var/burst_size = 3
    var/burst_delay = 10.5
    var/obj/machinery/mac_cannon/ammo_loader/plasma_cannon/linked_ammo_loader
    var/obj/machinery/mac_cannon/accelerator/plasma_cannon/linked_accelerator
    var/firing = 0

    New()
        ..()
        spawn(10)
            var/turf/T = get_turf(src)
            if(!T)
                return
            linked_ammo_loader = locate(/obj/machinery/mac_cannon/ammo_loader/plasma_cannon) in range(5, T)
            linked_accelerator = locate(/obj/machinery/mac_cannon/accelerator/plasma_cannon) in range(5, T)

    fire(atom/overmap_target)
        if(!powered() || !overmap_target || firing)
            return

        if(!linked_ammo_loader)
            return

        if(requires_ammo && linked_ammo_loader.ammo_count < burst_size)
            visible_message("<span class='warning'>[src] buzzes: Insufficient plasma charge ([linked_ammo_loader.ammo_count]/[burst_size]).</span>")
            return

        visible_message("<span class='danger'>[src] hums as it prepares to unleash a plasma barrage!</span>")

        for(var/i = 1 to burst_size)
            if(!linked_ammo_loader || linked_ammo_loader.ammo_count <= 0)
                break
            if(!overmap_target)
                break
            firing = 0
            if(..())
                playsound(src, fire_sound, 100, 1)
                if(linked_accelerator)
                    linked_accelerator.overlays += accelerator_overlay_icon_state
                    spawn(5)
                        linked_accelerator.overlays -= accelerator_overlay_icon_state
                linked_ammo_loader.ammo_count--
            firing = 1
            sleep(burst_delay)

        firing = 0
        update_icon()

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/plasma_cannon
    name = "Plasma Cannon Bombardment Console"
    desc = "A fire control console used to direct fire on planetary targets."
    icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
    icon_state = "covie_console"
    fire_sound = 'code/modules/halo/sounds/plasma_cannon_fire.ogg'
    designator_spawn = /obj/item/weapon/laser_designator/covenant
    var/burst_size = 3
    var/burst_delay = 10.5
    var/obj/machinery/mac_cannon/ammo_loader/plasma_cannon/linked_ammo_loader

    New()
        ..()
        var/obj/ld = new designator_spawn(loc)
        ld.loc = loc
        var/turf/T = get_turf(src)
        if(T)
            linked_ammo_loader = locate(/obj/machinery/mac_cannon/ammo_loader/plasma_cannon) in range(5, T)

    attack_hand(var/mob/user)
        var/beacon_selection = get_beacon_from_name((input(user, "Bombardment Beacon Selection", "Select a beacon to fire on.", "Cancel") in get_overmap_adjacent_bombard_beacons() + list("Cancel")))

        if(isnull(beacon_selection) || beacon_selection == "Cancel")
            to_chat(user, "<span class='notice'>Firing sequence cancelled.</span>")
            return

        fire(beacon_selection, user)

    fire(var/atom/target, var/mob/user)
        if(!do_power_check(user))
            return

        if(!linked_ammo_loader || linked_ammo_loader.ammo_count < burst_size)
            visible_message("<span class='warning'>[src] buzzes: Insufficient plasma charge ([linked_ammo_loader?.ammo_count || 0]/[burst_size]).</span>")
            return

        visible_message("<span class='danger'>[src] hums as it prepares to unleash a plasma barrage!</span>")
        sleep(10)

        var/turf/target_turf = target.loc
        var/obj/effect/overmap/targ_overmap = map_sectors["[target.z]"]
        if(!target_turf || !targ_overmap)
            to_chat(user, "<span class='warning'>Invalid target location!</span>")
            return

        for(var/i = 1 to burst_size)
            play_fire_sound()
            play_fire_sound(targ_overmap, target_turf)
            bombard_impact(target_turf)
            linked_ammo_loader.ammo_count--
            if(i == 1)
                targ_overmap.adminwarn_attack()
            sleep(burst_delay)

//Machinery

/obj/machinery/mac_cannon/accelerator/plasma_cannon
	name = "Plasma Cannon"
	desc = "A plasma cannon capable of firing high velocity plasma shells."
	icon = 'code/modules/halo/overmap/weapons/plasma_cannon_2.dmi'
	icon_state = "plasma_cannon"

/obj/machinery/mac_cannon/capacitor/plasma_cannon
	name = "Plasma Cannon Power Cell"
	desc = "A power cell used to charged plasma shells for the cannon"
	icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
	icon_state = "power_cell"

//Projectiles

/obj/item/projectile/overmap/plasma_shell
    name = "Plasma Shell"
    desc = "A high velocity plasma shell."
    icon = 'code/modules/halo/overmap/weapons/pulse_turret_tracers.dmi'
    icon_state = "plasma_cannon_proj"
    step_delay = 1
    damage = 500
    ship_damage_projectile = /obj/item/projectile/plasma_shell_proj
    ship_hit_sound = 'code/modules/halo/sounds/plasma_cannon_hit_sound.ogg'

    sector_hit_effects(var/z_level, var/obj/effect/overmap/hit, var/list/hit_bounds)
        if(!hit.CanUntargetedBombard(console_fired_by))
            return
        var/turf/T = get_turf(hit)
        if(!T)
            T = locate(rand(hit_bounds[1], hit_bounds[3]), rand(hit_bounds[2], hit_bounds[4]), z_level)
            if(!T)
                var/list/valid_turfs = get_area_turfs(hit.map_z[z_level])
                if(valid_turfs.len > 0)
                    T = pick(valid_turfs)
                else
                    return
        explosion(T, 7, 12, 18, 25, adminlog = 0)
        var/obj/effect/overmap/sector/S = map_sectors["[src.z]"]
        if(S)
            S.adminwarn_attack()

/obj/item/projectile/plasma_shell_proj
    name = "Plasma Shell"
    desc = "A high velocity plasma shell."
    icon = 'code/modules/halo/overmap/weapons/pulse_turret_tracers.dmi'
    icon_state = "plasma_cannon_proj"
    damage = 500
    penetrating = 1
    var/warned = 0

    on_impact(var/atom/impacted)
        if(istype(impacted, /obj/effect/shield))
            return
        var/turf/T = get_turf(impacted)
        if(!T)
            return
        explosion(T, 4, 6, 8, 10, adminlog = 0)
        if(!warned)
            warned = 1
            var/obj/effect/overmap/sector/S = map_sectors["[src.z]"]
            if(S)
                S.adminwarn_attack()
        . = ..()

    check_penetrate(var/atom/impacted)
        if(istype(impacted, /obj/effect/shield))
            return 0
        if(penetrating > 0)
            penetrating--
            return 1
        return 0
