untyped 
global function movementhelper_Init

float lastSpaceTime = -1.0
float lastAltTime   = -1.0
float inputWindow   = 0.2 // seconds allowed between inputs
float successWindow = 0.008 // 8 ms

void function movementhelper_Init()
{
    RegisterButtonPressedCallback(KEY_SPACE, OnSpace)
    RegisterButtonPressedCallback(KEY_LALT, OnAlt)
    printt( "movementhelper loaded" )
}

void function OnSpace(var button)
{
    lastSpaceTime = Time()

    // check if ALT was pressed recently
    if (lastAltTime >= 0)
    {
        float delta = lastSpaceTime - lastAltTime
        if (delta <= inputWindow)
        {
            printt("Time between inputs = " + delta + " seconds")
            if(delta <= successWindow) {
                printt("success")
            }
        }
    }
}

void function OnAlt(var button)
{
    lastAltTime = Time()

    // check if SPACE was pressed recently
    if (lastSpaceTime >= 0)
    {
        float delta = lastAltTime - lastSpaceTime
        if (delta <= inputWindow)
        {
            printt("Time between inputs = " + delta + " seconds")
            if(delta <= successWindow) {
                printt("success")
            }
        }
    }
}