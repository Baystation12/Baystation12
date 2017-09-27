#define TRADER_THIS_TYPE     1
#define TRADER_SUBTYPES_ONLY 2
#define TRADER_ALL           3
#define TRADER_BLACKLIST     4
#define TRADER_BLACKLIST_SUB 8
#define TRADER_BLACKLIST_ALL 12

#define TRADER_WANTED_ONLY   1 //Do they only trade for wanted goods?
#define TRADER_MONEY         2 //Do they only accept money in return for goods.
#define TRADER_GOODS         4 //Do they accept goods in return for other goods.
#define TRADER_WANTED_ALL    8 //Like TRADER_WANTED_ONLY but they buy all possible wanted goods rather than a subset.

//Possible response defines for when offering an item for something
#define TRADER_NO_MONEY       "trade_no_money"
#define TRADER_NO_GOODS       "trade_no_goods"
#define TRADER_NOT_ENOUGH     "trade_not_enough"
#define TRADER_NO_BLACKLISTED "trade_blacklist"
#define TRADER_FOUND_UNWANTED "trade_found_unwanted"

#define TRADER_DEFAULT_NAME "Default" //Whether to just generate a name from the premade lists.