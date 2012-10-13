# Copyright 2012 Smartling, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'smartling/api'

module Smartling
  module Services
    SCREENSHOT_UPLOAD = 'service/context/screenshot/upload'
  end

  class Screenshot < Api
    def upload(strings, screenshot, name, type, params = nil)
      keys = { :'resStrings[0]' => strings, :uri => name, :fileType => type }
      uri = uri(Services::SCREENSHOT_UPLOAD, keys, {:apiVersion => 0}).require(:'resStrings[0]', :uri, :fileType)
      file = ::File.open(screenshot, 'rb') if screenshot.is_a?(String)
      return post(uri.to_s, :screenshot => file)
    end
  end
end