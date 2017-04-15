#define CORE_STRENGTH 20 // How much strength it sends to nodes per tick, higher = blob is stronger
#define NODE_COST 12 // How much it costs to make a new node, lower = blob is stronger
#define SHIELD_COST 10 // How much it costs to turn a node into a shield, lower = blob is stronger
#define SECONDARY_CORE_STRENGTH 4 // How much extra the blob gets from factories, higher = blob is stronger
#define SECONDARY_CORE_COST 5 // How much it costs to start making a factories, lower = blob is stronger
#define SECONDARY_CORE_TOTAL_COST 100 // How much it costs to fully develop a factory, lower = blob is stronger
#define SECONDARY_CORE_SPEED 4 // How quickly factories are built, higher = factories built faster but more vulnerable
#define REGEN_COST 1 // How much it costs to regen one node, lower = blob is stronger
#define STRENGTH_DISTANCE_LOSS 2 // How much is lost for every tile the pulse passes, lower = blob is stronger
#define BLOB_MAX_SIZE 10 // How big it can grow; shouldn't be higher than CORE_STRENGTH / STRENGTH_DISTANCE_LOSS
#define BLOB_FACTORY_CORE_DIST 2 // How far the factory can be from the core
#define BLOB_FACTORY_FACTORY_DIST 5 // How far factories can be from each other
#define NODE_STARTING_HEALTH 10 // How much health nodes start with, higher = blob is stronger
#define BLOB_LASER_RESIST 5
