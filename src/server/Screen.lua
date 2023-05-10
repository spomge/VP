local Screen = {}
Screen.__index = Screen

-- The Default Pixel when Render is called
local function DefPixel(MainScreenFrame : Frame)
    local Pixel = Instance.new("Frame",MainScreenFrame)
    Pixel.Name = "Pixel"
    Pixel.Size = UDim2.fromOffset(10,10)
    Pixel.BorderSizePixel = 0
    Pixel.BackgroundColor3 = Color3.fromRGB(243, 84, 4)
    Pixel.Position = UDim2.fromOffset(-10,-10)
    return Pixel
end

-- Create a Screen GUI with a X and Y
local function CreateScreen(SizeX,SizeY)
    local BasePart = Instance.new("Part",workspace)
    BasePart.Size = Vector3.new(SizeX,SizeY,1)
    BasePart.Position = Vector3.new(0,SizeY/2 + 2,75)
    BasePart.Anchored = true
    local SurfaceGui = Instance.new("SurfaceGui",BasePart)
    local MainScreenFrame = Instance.new("Frame",SurfaceGui)
    MainScreenFrame.ClipsDescendants = true
    MainScreenFrame.Size = UDim2.fromOffset(SizeX * 10,SizeY * 10)
    MainScreenFrame.BorderColor3 = Color3.fromRGB(37, 38, 40)
    MainScreenFrame.BorderSizePixel = 5
    MainScreenFrame.Name = "MainScreen"
    return MainScreenFrame
end

-- Checks if the fps is vaild
local function CheckFPS(fps)
    if fps == nil then
        warn("FPS = Nil , Set FPS to 10.")
        fps = 10
    end
    if fps <= 60 then
        warn("Changed FPS to "..fps)
    end
    return fps
end

-- Create Screen class
function Screen:CreateScreen(Size : {}, FPS : number)
    
    local self = setmetatable({},Screen)

    self.SizeX = Size[1]
    self.SizeY = Size[2]

    self.FPS = CheckFPS(FPS)
    self.MainScreenFrame = CreateScreen(Size[1] , Size[2])

    self.Rendering = false
    self.RenderSections = 1
    self.FrameTemplate = DefPixel(self.MainScreenFrame)

    self.CurrentLoadedVideo = nil
    self.CurrentLoadedImage = nil

    return self

end  

function Screen:ChangeFrameRate(fps : number)
    self.FPS = CheckFPS(fps)
end 

function Screen:StopRender()
    self.Rendering = false
    warn("Stoped Render")
end

function Screen:StartRender()
    warn("Started Render")
    self.Rendering = true
    local PixelIndex = 1
    for X = 0,self.SizeX - 1 do task.wait()
        for Y = 0,self.SizeY - 1 do task.wait()
            if self.Rendering == false then return end
            local Pixel = self.FrameTemplate:Clone()
            Pixel.Parent = self.MainScreenFrame
            Pixel.Name = PixelIndex
            Pixel.Position = UDim2.fromOffset(X * 10,Y * 10)
            PixelIndex += 1
        end
    end
end

function Screen:ForceRender()
    warn("Started Forced Render")
    task.spawn(function()
        warn(self.SizeY,self.SizeX)
        self.Rendering = true
        local PixelIndex = 1
        for X = 0,self.SizeX - 1 do task.wait()
            for Y = 0,self.SizeY - 1 do 
                local Pixel = self.FrameTemplate:Clone()
                Pixel.Parent = self.MainScreenFrame
                Pixel.Name = PixelIndex
                Pixel.Position = UDim2.fromOffset((X * 10),(Y * 10))
                PixelIndex += 1
            end
        end
    end)
end

function Screen:Reset()
    warn("Screen Reset")
    self.MainScreenFrame:ClearAllChildren()
end

function Screen:ChangeTemplate(Frame : Frame)
    self.FrameTemplate = Frame
end

function Screen:LoadImage(ModuleScript : ModuleScript)
    if ModuleScript.ClassName ~= "ModuleScript" then warn("Not a vaild Image (Not a vaild ModuleScript)") return  end
    local Image = require(ModuleScript)
    self.CurrentLoadedImage = Image
    warn("Got image "..ModuleScript.Name)
end

function Screen:RenderImage()
    local Image = self.CurrentLoadedImage
    print(self.SizeX * self.SizeY) 
    for FrameIndex = 1,self.SizeX * self.SizeY do
        self.MainScreenFrame:WaitForChild(FrameIndex).BackgroundColor3 = Color3.fromHex(Image[FrameIndex])
    end
end

function Screen:LoadVideo(VideoFolder : Folder)
    if VideoFolder.ClassName ~= "Folder" or self.CurrentLoadedVideo == VideoFolder.Name then warn("Not a vaild Video (Not a vaild Folder)") return  end
    local VideoFolder = VideoFolder
    local TotalSquence = {}
    for i,Value : ModuleScript in VideoFolder:GetChildren() do
        if Value.ClassName == "ModuleScript" then
            local Module = require(Value)
            table.insert(TotalSquence,Module)
        end
    end
    self.CurrentLoadedVideo = TotalSquence
    warn("Got "..VideoFolder.Name.." sequences ( "..#TotalSquence.." )")
end

function Screen:MakeVideoSections(Divide)
    local SectionSizeX = self.SizeX / Divide 
    local SectionSizeY = self.SizeY / Divide
    if SectionSizeX == math.round(SectionSizeX) and SectionSizeY == math.round(SectionSizeY) then
        self.RenderSections = Divide^Divide
    else
        warn(Divide^Divide.." is not vaild section length, \n"..SectionSizeY.."\n"..SectionSizeX)
    end
end



return Screen