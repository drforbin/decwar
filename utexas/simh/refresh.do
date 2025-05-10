; Define structures
expect -p "Do you want to initialize the HOME blocks on this unit?\r\n" send -t after=200k "yes\r"; continue
expect -p "Do you want a list of bad regions?\r\n" send -t after=500k "no\r" ; continue
expect -p "Do you want to initialize the BAT blocks on this unit?\r\n" send -t after=200k "yes\r"; continue
expect -p "Not normally done, are you sure?\r\n" send -t after=500k "yes\r" ; continue
expect "Type structure name for a list of its parameters (<CR> if none, ALL if all)" send -t after=1000k "\r"; continue
expect "Type physical unit name to list its parameters (<CR> if none, ALL if all)" send -t after=500k "\r"; continue
expect "Do you want to change any disk parameters? (<CR> if no)" send -t after=500k "yes\r"; continue
expect "Type structure name to be defined (<CR> if none)" send -t after=500k "dskb\r"; continue
expect "Type names of physical units in structure" send -t after=900k delay=90000 "rpa0\rrpa1\r\r" ; continue
expect "Type structure name to change its parameters (<CR> if none, ALL if all)" ; send -t after=500k "dskb\r"; continue
expect "Number of consecutive blocks tried for on output ="; send -t after=500k "\r"; continue
expect "Number of blocks allowed for overdraw per user = "; send -t after=500k "\r"; continue
expect "Is this a private structure? (Type Y if private, N if no access restrictions)"; send -t after=50k "n\r"; continue
expect "Do you want to change the owner PPN? (<CR> if no)"; send -t after=50k "\r"; continue
expect "Number of K for CRASH.EXE ="; send -t after=50k "\r"; continue
expect "Blocks per cluster = "; send -t after=50k "10\r"; continue
expect "Bits per cluster count = "; send -t after=50k "\r"; continue
expect "Type structure name to change its parameters (<CR> if none, ALL if all)" ; send -t after=500k "\r"; continue
expect "Type physical unit name to change its parameters (<CR> if none, ALL if all)" send -t after=1000k "all\r"; continue
expect -p "Number of SAT blocks on unit =" send -t after=600k "8\r"; continue
expect -p "Number of K for swapping on unit = " send -t after=600k "2048\r"; continue
expect -p "The first logical block for swapping =" send -t after=200k "\r"; continue
expect "Zero unit ID - New ID needed" send -t after=600k "dkb001\r"; continue
expect "Zero unit ID - New ID needed" send -t after=600k "dkb002\r"; continue
expect "Zero unit ID - New ID needed" send -t after=600k "dkb003\r"; continue
expect "Zero unit ID - New ID needed" send -t after=600k "dkb004\r"; continue
expect -p "Number of SAT blocks in core =" send -t after=600k "\r"; continue
expect "Do you want to change the active swapping list?" send -t after=800k "yes\r"; continue
expect "Class 0" send -t after=800k delay=990k "rpa0\rrpa1\r\r" ; continue
expect "Class 1" send -t after=500k  "\r" ; continue
expect "Do you want to change the system search list?" ; send -t after=800k "yes\r"; continue
expect "Type structure names for system search list" send -t after=800k delay=800000 "dskb\r\r" ; continue
expect "Do you want to change the system dump list?" send -t after=600k "y\r"; continue
expect "Type structure names for system dump list" send -t after=800k delay=990000 "dskb\r\r" ; continue
expect "Type structure name to be defined (<CR> if none)" send -t after=500k "\r"; continue
expect "Type structure name for a list of its parameters (<CR> if none, ALL if all)" send -t after=1000k "\r"; continue
expect "Type physical unit name to list its parameters (<CR> if none, ALL if all)" send -t after=500k "\r"; continue
expect "Do you want to change any disk parameters? (<CR> if no)" send -t after=500k "\r"; continue
expect "Type physical units on which to write HOME blocks (Extra <CR> when through)" send -t after=500k "all\r"; continue
expect "Type structure names for system dump list" send -t after=800k delay=990000 "dskb\r\r" ; continue
expect "Type structure name for a list of its parameters (<CR> if none, ALL if all)" send -t after=1000k "\r"; continue
expect "Type physical unit name to list its parameters (<CR> if none, ALL if all)" send -t after=500k "\r"; continue
expect "Do you want to change any disk parameters? (<CR> if no)" send -t after=500k "\r"; continue
expect "Type structure name to be refreshed (<CR> if none)" send -t after=500k "dskb\r"; continue
expect "Type structure name to be refreshed (<CR> if none)" send -t after=500k "\r"; continue
