global function movementhelper_Init

float lastSpaceTime = -1.0
float lastAltTime   = -1.0

const float INPUT_WINDOW   = 0.2
const float SUCCESS_WINDOW = 0.008
const frameRate = 0

int wallrunFrameTime = -1

global int lurchInputCount = 0


void function movementhelper_Init()
{    
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
    if (wallrunFrameTime > 50 ) //Slightly half then half a second, haven't found a way to make this fps dependent. if you know one *please* let me know
        return

    float newestTime = max(lastSpaceTime, lastAltTime)

    if (wallrunFrameTime > 5) 
    {
        //printt("failure " + wallrunFrameTime + "f")
        RuiPrint("failure - " + wallrunFrameTime + "f", 0, 0.5, <1,0,0>)
        return
    }

    float delta = fabs(lastSpaceTime - lastAltTime)

    if (delta <= SUCCESS_WINDOW)
    {
        //printt("success CK")
        RuiPrint("success CK - " + wallrunFrameTime + "f", 0, 0.5, <0,1,0>)
        return
    }
    else
    {
        //printt("success WK")
        RuiPrint("success WK - " + wallrunFrameTime + "f", 0, 0.5, <0,1,0>)
    }
}

void function Lurchtimer(){
    thread Lurchthread()
}
void function Lurchthread(){
    RuiPrint("Lurch active", 2, 0.5, <0,0,1>)
    AddCallback_OnForwardInput( CountTabs )
    AddCallback_OnBackInput( CountTabs )
    AddCallback_OnLeftInput( CountTabs )
    AddCallback_OnLeftInput( CountTabs )
    AddCallback_OnRightInput( CountTabs )
    wait 0.5 //the lurch time
    RemoveCallback_OnForwardInput( CountTabs )
    RemoveCallback_OnBackInput( CountTabs )
    RemoveCallback_OnLeftInput( CountTabs )
    RemoveCallback_OnRightInput( CountTabs )
    RuiPrint(lurchInputCount + " Lurches", 3, 0.5, <0,1,1>)
    lurchInputCount = 0
}

void function CountTabs(){
    lurchInputCount++
    
}


void function OnWallrunStart()
{
    entity player = GetLocalClientPlayer()

    wallrunFrameTime = 0
    RuiPrint("WR START", 1, 0.2, <0,0,1>)
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
    float startime = Time()
    while(Time() < (startime + 1.0)){
        frameRate++
        WaitFrame()
    }
    printt(frameRate)
}