#!/usr/bin/ruby
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

$:.unshift File.expand_path('../', __FILE__)
require 'test_helper'
require 'iconv'

module SmartlingTests
  class SmartlingScreenshotApiTest < Test::Unit::TestCase

    TEST_FILE_YAML = 'tests/upload.yaml'
    TEST_FILE_SCREENSHOT = 'tests/logo.png'

    def setup
      @config = SmartlingTests.server_config
      @log = SmartlingTests.logger
    end

    def yaml_file(encoding = nil)
      data = <<-EOL
hello: world
we have: cookies
      EOL
      data = Iconv.conv(encoding, 'US-ASCII', data) if encoding
      f = Tempfile.new('smartling_tests')
      f.write(data)
      f.flush
      f.pos = 0
      return f
    end

    def test_1_upload
      @log.debug '<- FileAPI:upload'
      sl = Smartling::File.new(@config)

      res = nil
      assert_nothing_raised do
        res = sl.upload(yaml_file, TEST_FILE_YAML, 'YAML')
      end
      @log.debug res.inspect

      @log.debug '<- ScreenshotAPI:upload'
      s2 = Smartling::Screenshot.new(@config)
      
      res = nil
      assert_nothing_raised do
        res = s2.upload(['world'], TEST_FILE_SCREENSHOT, TEST_FILE_SCREENSHOT, 'IOS')
      end
      @log.debug res.inspect
    end
  end
end