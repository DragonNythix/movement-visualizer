global function movementhelper_Init

float lastSpaceTime = -1.0
float lastAltTime   = -1.0

const float INPUT_WINDOW   = 0.2
const float SUCCESS_WINDOW = 0.008
int frameRate = 0

int wallrunFrameTime = -1

global int lurchInputCount = 0


void function movementhelper_Init()
{    
    #if HAS_uCKF
        // put the ck stuff init in here or somthing
    #else
        //debugPrint( "Missing dependency: FromWau.CrouchKickFix" )
        //make a pop up informing players they should install it
    #endif
    AddCallback_OnJump(OnJump)
    AddCallback_OnCrouch(OnCrouch)
    AddCallback_OnWallrunStart(OnWallrunStart)
    AddCallback_OnJump(Lurchtimer)
    thread mesureframe()

}


void function OnJump()
{
    lastSpaceTime = Time()
    CheckInputTiming()
}


void function OnCrouch()
{
    lastAltTime = Time()
    CheckInputTiming()
}



void function CheckInputTiming()
{
    if (wallrunFrameTime == -1)
        return
    if (wallrunFrameTime > 50 ) //Slightly less then half a second, haven't found a way to make this fps dependent. if you know one *please* let me know
        return

    float newestTime = max(lastSpaceTime, lastAltTime)

    if (wallrunFrameTime > 5) 
    {
        //printt("failure " + wallrunFrameTime + "f")
        return
    }

    float delta = fabs(lastSpaceTime - lastAltTime)

    if (delta <= SUCCESS_WINDOW)
    {
        //printt("success CK")
        return
    }
    else
    {
        //printt("success WK")
    }
}

void function Lurchtimer(){
    thread Lurchthread()
}
void function Lurchthread(){
    AddCallback_OnForwardInput( CountTabs )
    AddCallback_OnBackInput( CountTabs )
    AddCallback_OnLeftInput( CountTabs )
    AddCallback_OnRightInput( CountTabs )
    wait 0.5 //the lurch time
    RemoveCallback_OnForwardInput( CountTabs )
    RemoveCallback_OnBackInput( CountTabs )
    RemoveCallback_OnLeftInput( CountTabs )
    RemoveCallback_OnRightInput( CountTabs )
    lurchInputCount = 0
}

void function CountTabs(){
    lurchInputCount++
    
}


void function OnWallrunStart()
{
    entity player = GetLocalClientPlayer()

    wallrunFrameTime = 0
    thread TrackWallrunFrames(player)
}


void function TrackWallrunFrames(entity player)
{
    while (player.IsWallRunning())
    {
        wallrunFrameTime++
        WaitFrame() // prevents thread lock
    }

    wallrunFrameTime = -1
}

void function mesureframe(){
    //it does a lot but working isnt one of them
    frameRate = int(1.0 / (FrameTime() / 1000.0))
    printt("framerate: " + frameRate)
}