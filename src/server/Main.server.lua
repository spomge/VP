local Screen = require(script.Parent.Screen)


local Screen1 = Screen:CreateScreen({80,60},10)

Screen1:ForceRender()
Screen1:LoadImage(script.Parent.Images.FoggyForest)

wait(5)

Screen1:RenderImage()






