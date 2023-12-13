-- CONFIG PARAMS --
-- Copyright (C) 2023 BestariwebTV
-- https://www.youtube.com/@BestariwebTV


local barujalan = 0;
local lastRunTS = 0;
local INTERVAL = 50;

local RXBAT_ID = -1;

local VBAT = 0;
local saycount = 0;
local VFileName = { [10] = "010.wav" , [11] = "011.wav", [12] = "012.wav", [13] = "013.wav",
                            [14] = "014.wav" , [15] = "015.wav", [16] = "016.wav" };
local AngkaFileName = { [0] = "0nol.wav" , [1] = "0satu.wav", [2] = "0dua.wav", [3] = "0tiga.wav",
                        [4] = "0empat.wav" , [5] = "0lima.wav", [6] = "0enam.wav", [7] = "0tjh.wav",
                        [8] = "0dlpn.wav" , [9] = "0smbln.wav" };
local SoundFilesPath = "/SCRIPTS/TELEMETRY/SND/";

local function getTelemetryId(name)
     local field = getFieldInfo(name)
     if field then
       local fieldId = field['id'];
       if fieldId ~= nil then
         return fieldId;
       else
        return -1;
       end
     else
       return -1
     end
 end

local function sayV(nilaiV)
  local tanpapecahan = math.floor(nilaiV);
  local pecahan1 = math.floor((nilaiV - tanpapecahan) * 10);
  local pecahan2 = math.floor((nilaiV - tanpapecahan) * 100)-(pecahan1*10);
  local VFile1 = VFileName[tanpapecahan];
  if VFile1 ~= nil then
    VFile1 = SoundFilesPath..VFile1;
  end
  local VFile2 = AngkaFileName[pecahan1];
  if VFile2 ~= nil then
    VFile2 = SoundFilesPath..VFile2;
  end
  local VFile3 = AngkaFileName[pecahan2];
  if VFile3 ~= nil then
    VFile3 = SoundFilesPath..VFile3;
  end
  if VFile1 ~= nil and VFile2 ~= nil and VFile3 ~= nil then
    playFile(SoundFilesPath.."0Rxbat.wav");
    playFile(VFile1);
    playFile(SoundFilesPath.."0point.wav");
    playFile(VFile2);
    playFile(VFile3);
    playFile(SoundFilesPath.."0Volt.wav");
  end
end
local function init()
  lastRunTS = 0;
end
local function run()
  lcd.clear();
  lcd.drawScreenTitle("NOTIF BATRE", 1, 1);
  lcd.drawText(3, 24,"V Bat : "..string.format("%.2f",VBAT).." Volt");
end
local function bg()
  if lastRunTS == 0 or lastRunTS + INTERVAL < getTime() then

   
  -- Ambil Nilai Tegangan batre drone
    if RXBAT_ID < 0 then
      RXBAT_ID = getTelemetryId("RxBt");
    end

      VBAT = getValue(RXBAT_ID);
      if saycount > 20 or barujalan == 0 then
        saycount = 0;
        barujalan = 1;
        sayV(VBAT);
      end
      saycount = saycount + 1;
      
    lastRunTS = getTime();
  end
end
return { init=init, run=run, background=bg }
