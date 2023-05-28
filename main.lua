local frame_count = 5300
local framerate = 35
local speed = 4

local timeOffset = 0

local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local decoder = dfpwm.make_decoder()

local function audio()
    for chunk in io.lines("rickroll/audio.dfpwm", 16 * 1024) do
        local buffer = decoder(chunk)

        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end
    end
end

local function videoDebug()
    term.native().write(os.clock() .. " - " .. 1/(framerate / speed) .. " - " .. timeOffset)
    term.native().scroll(1)
end

local function video()
    local start = os.clock()

    for i = 1, frame_count / speed do
        offset = math.floor(math.log10(i * speed)+1)
    
        local name = ""
        for o = offset, 5 do
            name = name .. "0"
        end
        name = name .. (i * speed)
    
        data = paintutils.loadImage("rickroll/images/nggyu_" .. name .. ".nfp")
        paintutils.drawImage(data,0,0)
        --videoDebug()

        timeOffset = os.clock() - start
        start = os.clock()

        sleep((1/(framerate / speed)) - (timeOffset / speed))    
    end
end

parallel.waitForAny(video, audio)
