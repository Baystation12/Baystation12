/*** RuBaystation... ***/
//#define DEBUG_CYRILLIC     //расскоментить для вывода дебаг-информации, связанной с sanitize текста и исправления "я"
//#define ALLOW_CALLPROC     //расскоментить, если требуется Advanced ProcCall. Не рекомендую делать это на "живых" серверах с количеством админов больше, чем 1

#define JA         "я"
#define JA_TEMP    "¶"       //техническая замена "я"
#define JA_CHAT    "&#255;"  //ascii(windows-1251) код, используется в чате игры
#define JA_POPUP   "&#1103;" //unicode вариант для вплывающих окон

//ja_mode для sanitize()
#define TEMP       0
#define CHAT       1
#define POPUP      2

/*** ...RuBaystation ***/