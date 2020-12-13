#define EXECUTION_TIME 2 SECONDS

/obj/item/weapon
    var/executions_allowed = FALSE
    var/list/start_execute_messages = list(BP_CHEST = "\The USER prepares to execute \the VICTIM with \the WEAPON!")
    var/list/finish_execute_messages = list(BP_CHEST = "\The USER executes \the VICTIM with \the WEAPON!")

//Make sure the weapon can execute, the victim isn't dead, there are valid messages for this zone, and the victim has that body part.
/obj/item/weapon/proc/can_execute(mob/living/carbon/human/user, mob/living/carbon/human/victim)
    return executions_allowed && victim.stat != DEAD && start_execute_messages[user.zone_sel.selecting] && victim.get_organ(user.zone_sel.selecting)

//Returns true if we successfully executed, false if we were interrupted.
/obj/item/weapon/proc/do_execute(mob/living/carbon/human/user, mob/living/carbon/human/victim)
    var/zone = user.zone_sel.selecting

    var/startmessage = start_execute_messages[zone]
    startmessage = replacetext(startmessage, "USER", user.name)
    startmessage = replacetext(startmessage, "VICTIM", victim.name)
    startmessage = replacetext(startmessage, "WEAPON", src.name)

    if(user.loc != victim.loc)
        user.Move(victim.loc)
    user.visible_message("<span class='danger'>[startmessage]</span>")

    if(!do_after(user, EXECUTION_TIME, victim))
        return FALSE

    var/execmessage = finish_execute_messages[zone]
    execmessage = replacetext(execmessage, "USER", user.name)
    execmessage = replacetext(execmessage, "VICTIM", victim.name)
    execmessage = replacetext(execmessage, "WEAPON", src.name)

    user.visible_message("<span class='danger'>[execmessage]</span>")
    victim.next_scream_at = world.time + 1
    victim.emote("painscream")
    playsound(loc, hitsound, 100)
    victim.apply_damage(150, damtype, zone, 0, src.damage_flags(), src)
    victim.visible_message("<span class='danger'><i>[victim] briefly struggles before seizing up and falling limp...</i></span>")
    var/obj/item/organ/internal/brain/B = victim.internal_organs_by_name[BP_BRAIN]
    if(B)
        B.die()
    return TRUE

#undef EXECUTION_TIME