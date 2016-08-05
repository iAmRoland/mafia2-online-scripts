/*******************************************
    SERVER SIDE
********************************************/
 
// First three will hold our time
GLOBAL_HOURS <- 12;
GLOBAL_MINUTES <- 0;
GLOBAL_SECONDS <- 0;
// This will hold a formated version of time
// which will be sent to client with triggerClientEvent
GLOBAL_TIME <- "12:00";
 
// Set the in-game time speed
SERVER_TIME_SPEED <- 500;
// Set if it's summer of winter on server
SERVER_IS_SUMMER <- true;
// Holds our current weather
SERVER_WEATHER <- "DT_RTRclear_day_noon";

// With this we check when its time to change the weather,
// pretty much random but at the same time fits the hour
WEATHER_CHANGE_TRIGGER <- 10;
 
 
/**
 * This array contains all the weathers and are ordered to fit the hour
 * Layout:
 *      [HOUR_START, HOUR_END, ["LIST", "OF", "WEATHERS", ...] ]
 *
 * So if time is between HOUR_START and HOUR_END, then it will pick one of the
 * weathers that exist in the same slot.
 * You can recheck and reorder the weathers, if you have atleast one weather in
 * a slot then it should not break, since the code checks how many weathers the
 * slot contains.
 */
WEATHERS <- {
    SUMMER = [
        // This is between the hours of 00:00 and 02:00 (night)
        [0, 2, ["DT_RTRclear_day_nigh", "DT07part04night_bordel", "DTFreerideNight", "DT14part11", "DT11part05", "DT_RTRrainy_day_night", "DT10part03Subquest", "DT_RTRfoggy_day_night"] ],
        
        // This is between the hours of 03:00 and 05:00 (night / early morning)
        [3, 5, ["DT_RTRclear_day_early_morn1", "DT_RTRfoggy_day_early_morn1", "DT_RTRrainy_day_early_morn"] ],
       
        // This is between the hours of 06:00 and 08:00 (morning) etc.
        [6, 9, ["DT_RTRclear_day_early_morn2", "DT_RTRclear_day_morning", "DT_RTRrainy_day_morning", "DT_RTRfoggy_day_morning"] ],

        [10, 10, ["DTFreeRideDay", "DT06part03", "DTFreeRideDayRain", "DT11part01", "DT_RTRfoggy_day_noon"] ],
        [11, 11, ["DT07part01fromprison", "DT13part01death", "DT09part1VitosFlat", "DT_RTRclear_day_noon", "DT06part01", "DT06part02", "DT11part02"] ],
        [12, 12, ["DT07part02dereksubquest", "DT08part01cigarettesriver", "DT09part2MalteseFalcone", "DT14part1_6", "DT_RTRrainy_day_noon", "DT_RTRfoggy_day_afternoon"] ],
        [13, 13, ["DT_RTRclear_day_afternoon", "DT10part02Roof", "DT09part3SlaughterHouseAfter", "DT_RTRrainy_day_afternoon", "DT_RTRfoggy_day_afternoon"] ],
        [14, 15, ["DT09part4MalteseFalcone2", "DT08part02cigarettesmill", "DT12_part_all", "DT15", "DT15end", "DT15_interier"] ],
        [16, 17, ["DT13part02", "DT_RTRclear_day_late_afternoon", "DT_RTRrainy_day_late_afternoon", "DT11part03", "DT_RTRfoggy_day_late_afternoon"] ],
        [18, 18, ["DT08part03crazyhorse", "DT07part03prepadrestaurcie", "DT_RTRrainy_day_evening", "DT_RTRfoggy_day_late_afternoon"] ],
        [19, 19, ["DT05part06Francesca", "DT10part03Evening", "DT14part7_10", "DT11part04", "DT_RTRfoggy_day_evening"] ],
        [20, 23, ["DT_RTRclear_day_evening", "DT08part04subquestwarning", "DT_RTRclear_day_late_even", "DT_RTRrainy_day_late_even", "DT_RTRfoggy_day_late_even"] ],
    ],

    WINTER = [
        [0, 7, ["DTFreeRideNightSnow", "DT04part02"] ],
        [8, 11, ["DT05part01JoesFlat", "DT03part01JoesFlat", "DTFreeRideDaySnow"] ],
        [12, 13, ["DT05part02FreddysBar", "DTFreeRideDayWinter", "DT05part04Distillery", "DT04part01JoesFlat"] ],
        [14, 15, ["DT02part01Railwaystation", "DT05part03HarrysGunshop", "DT05part05ElGreco"] ],
        [16, 17, ["DT02part02JoesFlat", "DT02part04Giuseppe", "DT01part01sicily_svit", "DT03part02FreddysBar"] ],
        [18, 20, ["DT05Distillery_inside", "DT02part05Derek", "DT02part03Charlie"] ],
        [21, 23, ["DT02NewStart1", "DT03part03MariaAgnelo", "DT02NewStart2", "DT03part04PriceOffice", "DT01part02sicily"] ],
    ]
};
 
 
// This will hold the weather that the player has
playerWeather <- array(MAX_PLAYERS, 0);

 
function scriptInit() {
    log("Script initialized!");
    
    // Set summer state
    setSummer(SERVER_IS_SUMMER);

    // Create timer to call function Time with duration of 1 second indefinitely
    timer(Time, SERVER_TIME_SPEED, -1);
}
addEventHandler("onScriptInit", scriptInit);
 
 
 
function playerConnect(playerid, name, ip, serial) {
    // Just set it to an empty string
    playerWeather[playerid] = "";
}
addEventHandler("onPlayerConnect", playerConnect);


// Need a random function to select a new weather
function random (min = 0, max = RAND_MAX) {
    srand((getTickCount() * rand()));
    return (rand() % ((max.tointeger() + 1) - min.tointeger())) + min.tointeger();
}
 
 
// Our timer function, called from scriptInit
function Time() {
    // This decreases slowly until it reaches 0
    WEATHER_CHANGE_TRIGGER--;
 
    // Increment seconds
    GLOBAL_SECONDS++;
 
    // When seconds go above 60,
    // increment minutes and reset seconds
    if(GLOBAL_SECONDS >= 60){
        GLOBAL_MINUTES++;
        GLOBAL_SECONDS = 0;
    }
    // Same for minutes but increment hours
    // and reset minutes
    if (GLOBAL_MINUTES >= 60) {
        GLOBAL_HOURS++;
        GLOBAL_MINUTES = 0;
    }
    // Almost the same for hours but
    // resets both hours and minutes
    if (GLOBAL_HOURS >= 24) {
        GLOBAL_HOURS = 0;
        GLOBAL_MINUTES = 0;
    }

    // Use format to structure the time string, looks more cleaner than loads of if statements.
    // "%02i" makes sure that at least two integers are present.  Result:  HH:MM
    GLOBAL_TIME = format("%02i:%02i", GLOBAL_HOURS, GLOBAL_MINUTES);

 

    // First we check if weather count has reached 0
    if (WEATHER_CHANGE_TRIGGER <= 0) {
        local weathers = (SERVER_IS_SUMMER) ? WEATHERS.SUMMER : WEATHERS.WINTER;
 
        // Go through the WEATHERS array
        for (local i = 0; i < weathers.len(); i++) {
            // Check and compare current hour with the hours in array
            // So it checks if current hour is between HOUR_START and HOUR_END
            if (GLOBAL_HOURS >= weathers[i][0] && GLOBAL_HOURS <= weathers[i][1]) {
                // Select a random weather between start slot 2 and last slot
                local randWeather = weathers[i][2][random(0, weathers[i][2].len()-1)];
                // Set the random weather for all players
                setWeather( randWeather );
                // Change SERVER_WEATHER string
                SERVER_WEATHER = randWeather;
                // Loop through players and set their weather as well
                for (local p = 0; p < MAX_PLAYERS; p++) {
                    if (isPlayerConnected(p)) {
                        playerWeather[p] = SERVER_WEATHER;
                    }
                }
                // Generate a new random number when to change weather
                // New count is between 20 and 60 in-game minutes.
                WEATHER_CHANGE_TRIGGER = random(20*60, 60*60);

                // Break out of the loop
                break;
            }
        }
    }
 
 

    // Loop through players
    for (local i = 0; i < MAX_PLAYERS; i++) {
        // Must check if a player is connected
        if (isPlayerConnected(i)) {
            // First check if player does not have the current weather
            if (playerWeather[i] != SERVER_WEATHER) {
                // Set weather in player variable
                playerWeather[i] = SERVER_WEATHER;

                // Set weather server wide again
                setWeather(SERVER_WEATHER);
            }
 
            // Then we trigger to set time on client side
            // We pass in the playerid, what event to call and what to
            // send to that event
            triggerClientEvent(i, "setTime", GLOBAL_TIME);  
        }
    }
}
