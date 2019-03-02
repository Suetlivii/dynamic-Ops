local lfs = require('lfs')
LUA_PATH = "?;?.lua;"..lfs.currentdir().."/Scripts/?.lua"

package.path  = package.path..";"..lfs.currentdir().."/LuaSocket/?.lua"
package.cpath = package.cpath..";"..lfs.currentdir().."/LuaSocket/?.dll"
  
socket = require("socket")

local ok, statusCode, headers, statusText = http.request 
{
  method = "POST",
  url = "http://httpbin.org/post",
  sink = collect
}

tasksReportController:Debug(ok, statusCode, headers, statusText)