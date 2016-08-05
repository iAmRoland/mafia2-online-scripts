/*******************************************
    CLIENT SIDE
********************************************/

local SCREEN = getScreenSize();

// Text that will be displayed
local TIME = "12:00";

local TIME_X = 120.0;
local TIME_Y = 32.0;


addEventHandler( "onClientFrameRender", function ( post ) {
    if( post ) {
        // Draw the TIME on screen
        dxDrawText(TIME, (SCREEN[0] - TIME_X).tofloat(), TIME_Y.tofloat(), 0xAAFFFFFF, true, "arial", 2.0);
    }
});

// Server sends time to this event
addEventHandler("setTime", function (text) {
    TIME = text.tostring();
});


