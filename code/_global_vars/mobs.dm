GLOBAL_LIST_EMPTY(clients)   //all clients
GLOBAL_LIST_EMPTY(admins)    //all clients whom are admins
GLOBAL_PROTECT(admins)
GLOBAL_LIST_EMPTY(ckey_directory) //all ckeys with associated client


GLOBAL_LIST_EMPTY(player_list)      //List of all mobs **with clients attached**. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(mob_list)         //List of all mobs, including clientless
GLOBAL_LIST_EMPTY(human_mob_list)   //List of all human mobs and sub-types, including clientless
GLOBAL_LIST_EMPTY(silicon_mob_list) //List of all silicon mobs, including clientless
GLOBAL_LIST_EMPTY(living_mob_list_) //List of all alive mobs, including clientless. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(dead_mob_list_)   //List of all dead mobs, including clientless. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(ghost_mob_list)   //List of all ghosts, including clientless. Excludes /mob/new_player
