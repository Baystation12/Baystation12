
/turf/simulated/floor/forerunner_alloy
    name = "Alloy Flooring"
    desc = "Floor made of an advanced alien alloy."
    icon = 'code/modules/halo/forerunner/turfs/floors.dmi'
    icon_state = "floortile"
    heat_capacity = 17000
    initial_flooring = /decl/flooring/forerunner_alloy

    New()
        ..()
        if(initial_flooring)
            flooring = decls_repository.get_decl(initial_flooring)
            if(initial(icon_state) != "floortile")
                icon_state = initial(icon_state)

    update_icon()
        if(initial(icon_state) != "floortile")
            var/saved_state = icon_state
            ..()
            icon_state = saved_state
        else
            ..()

/decl/flooring/forerunner_alloy
    name = "Alloy Flooring"
    desc = "Floor made of an advanced alien alloy."
    icon = 'code/modules/halo/forerunner/turfs/floors.dmi'
    icon_base = "floortile"
    flags = TURF_ACID_IMMUNE
    build_type = null
    build_cost = 2
    build_time = 30
    apply_thermal_conductivity = 0.025
    apply_heat_capacity = 325000

//Variants
/turf/simulated/floor/forerunner_alloy/tile
    icon_state = "floortile2"

/turf/simulated/floor/forerunner_alloy/arrow
    icon_state = "floortile3"

/turf/simulated/floor/forerunner_alloy/arrow/two
    icon_state = "floortile4"

/turf/simulated/floor/forerunner_alloy/arrow/three
    icon_state = "floortile5"

/turf/simulated/floor/forerunner_alloy/arrow/four
    icon_state = "floortile6"

/turf/simulated/floor/forerunner_alloy/center
    icon_state = "floortile7"

/turf/simulated/floor/forerunner_alloy/center/two
    icon_state = "floortile8"

/turf/simulated/floor/forerunner_alloy/center/three
    icon_state = "floortile9"

/turf/simulated/floor/forerunner_alloy/center/four
    icon_state = "floortile10"

/turf/simulated/floor/forerunner_alloy/center/five
    icon_state = "floortile11"

/turf/simulated/floor/forerunner_alloy/center/six
    icon_state = "floortile12"

/turf/simulated/floor/forerunner_alloy/center/seven
    icon_state = "floortile13"

/turf/simulated/floor/forerunner_alloy/corner
    icon_state = "floortile14"

/turf/simulated/floor/forerunner_alloy/corner/two
    icon_state = "floortile16"

/turf/simulated/floor/forerunner_alloy/corner/three
    icon_state = "floortile19"

/turf/simulated/floor/forerunner_alloy/corner/four
    icon_state = "floortile20"

/turf/simulated/floor/forerunner_alloy/side
    icon_state = "floortile15"

/turf/simulated/floor/forerunner_alloy/side/two
    icon_state = "floortile17"

/turf/simulated/floor/forerunner_alloy/side/three
    icon_state = "floortile18"

/turf/simulated/floor/forerunner_alloy/side/four
    icon_state = "floortile21"

/turf/simulated/floor/forerunner_alloy/old
    name = "Alloy Flooring"
    desc = "Floor made of an advanced alien alloy."
    icon = 'code/modules/halo/forerunner/turfs/floors.dmi'
    icon_state = "floortile_old"
    initial_flooring = /decl/flooring/forerunner_alloy/old

/decl/flooring/forerunner_alloy/old
    name = "Alloy Flooring"
    desc = "Floor made of an advanced alien alloy."
    icon = 'code/modules/halo/forerunner/turfs/floors.dmi'
    icon_base = "floortile_old"
    flags = TURF_ACID_IMMUNE
    build_type = null
    build_cost = 2
    build_time = 30
    apply_thermal_conductivity = 0.025
    apply_heat_capacity = 325000