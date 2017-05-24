script "kickstarter"
local sInitialized
local sConfA

on libraryStack
   if not sInitialized then
      kickstarter_startApplication
   end if
end libraryStack

private command kickstarter_startApplication
   put true into sInitialized
   kickstarter_loadConfiguration
   kickstarter_loadAllLibraries
   kickstarter_launch
end kickstarter_startApplication

private command kickstarter_loadConfiguration
   if there is not a file "conf/conf.json" then
      answer error "Missing configuration"
      if the environment is not "development" then
         quit 1
      else
         exit to top
      end if
   end if
   
   put url ("file:conf/conf.json") into tJson
   put jsonimport(tJson) into sConfA
end kickstarter_loadConfiguration

private command kickstarter_loadAllLibraries
   if sConfA["libraries"] is an array  then
      repeat with x = 1 to the number of lines in the keys of sConfA["libraries"]
         start using sConfA["libraries"][x]
      end repeat
   end if
end kickstarter_loadAllLibraries

private command kickstarter_launch
   if there is not a file sConfA["launch"] then
      answer error "Could not find launch stack"
      exit to top
   end if
   
   go stack sConfA["launch"]
end kickstarter_launch

function app_getConfiguration
   return sConfA
end app_getConfiguration
