/turf/snow
    name = "snow"

    dynamic_lighting = 0
    icon = 'icons/eros/turf/snow.dmi'
    icon_state = "snow"

    oxygen = MOLES_O2STANDARD * 1.15
    nitrogen = MOLES_N2STANDARD * 1.15

    temperature = TN60C
    var/list/crossed_dirs = list()

#define FOOTSTEP_SPRITE_AMT 2

/turf/snow/Entered(atom/A)
    if(isliving(A))
        var/mdir = "[A.dir]"
        if(crossed_dirs[mdir])
            crossed_dirs[mdir] = min(crossed_dirs[mdir] + 1, FOOTSTEP_SPRITE_AMT)
        else
            crossed_dirs[mdir] = 1

        update_icon()

    . = ..()

/turf/snow/update_icon()
    overlays.Cut()
    for(var/d in crossed_dirs)
        var/amt = crossed_dirs[d]

        for(var/i in 1 to amt)
            overlays += icon(icon, "footprint[i]", text2num(d))