local kong = kong
local http = require "resty.http"
local cjson = require "cjson.safe"

local CustomAuthHandler = {
  PRIORITY = 1000,
  VERSION = "1.0",
}

function CustomAuthHandler:access(config)
  -- Use the auth_service_url from the configuration
  local auth_service_url = config.auth_service_url

  -- Call auth service
  local httpc = http.new()
  local res, err = httpc:request_uri(auth_service_url, {
    method = "GET",
    headers = {
      ["Authorization"] = kong.request.get_header("Authorization"),
    }
  })

  if not res then
    kong.log.err("Failed to call auth service: ", err)
    return kong.response.exit(500, { message = "Internal Server Error" })
  end

  if res.status ~= 200 then
    return kong.response.exit(res.status, { message = "Unauthorized" })
  end

  -- Parse the JSON response and extract userId
  local response_data = cjson.decode(res.body)
  
  if response_data and response_data.userId then
    kong.service.request.set_header("X-User-ID", response_data.userId)
  else
    kong.log.err("Invalid response from auth service: Missing userId")
    return kong.response.exit(500, { message = "Invalid Auth Service Response" })
  end
end

return CustomAuthHandler
