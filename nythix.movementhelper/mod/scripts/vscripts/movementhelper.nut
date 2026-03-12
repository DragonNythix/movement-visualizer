global function movementhelper_Init

float lastSpaceTime = -1.0
float lastAltTime   = -1.0

const float INPUT_WINDOW   = 0.2
const float SUCCESS_WINDOW = 0.008

int wallrunFrameTime = -1


void function movementhelper_Init()
{    
    AddCallback_OnJump(OnJump)
    AddCallback_OnCrouch(OnCrouch)
    AddCallback_OnWallrunStart(OnWallrunStart)
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
    if (wallrunFrameTime > 50 ) //if we take 50 frames it can be assumed it wasnt an attempt in the first place
        return

    float newestTime = max(lastSpaceTime, lastAltTime)

    if (wallrunFrameTime > 5) 
    {
        //printt("failure " + wallrunFrameTime + "f")
        RuiPrint("failure - " + wallrunFrameTime + "f", 0)
        return
    }

    float delta = fabs(lastSpaceTime - lastAltTime)

    if (delta <= SUCCESS_WINDOW)
    {
        //printt("success CK")
        RuiPrint("success CK - " + wallrunFrameTime + "f", 0)
        return
    }
    else
    {
        //printt("success WK")
        RuiPrint("success WK - " + wallrunFrameTime + "f", 0)
    }
}


void function OnWallrunStart()
{
    entity player = GetLocalClientPlayer()

    wallrunFrameTime = 0
    RuiPrint("WR START", 1)
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