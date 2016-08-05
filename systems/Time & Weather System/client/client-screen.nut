/*******************************************
    CLIENT SIDE
********************************************/

// This displays the time
local TIME = "12:00";
local TIME_X = 120.0;
local TIME_Y = 32.0;

local SCREEN = getScreenSize();

addEventHandler( "onClientFrameRender", function ( post ) {
    if( post ) {
        // Draw it on screen
        dxDrawText(TIME, (SCREEN[0] - TIME_X).tofloat(), TIME_Y.tofloat(), 0xAAFFFFFF, true, "arial", 2.0);
    }
});


addEventHandler("setTime", function (text) {
    TIME = text.tostring();
});


