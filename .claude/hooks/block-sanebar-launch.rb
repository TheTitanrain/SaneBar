#!/usr/bin/env ruby
# frozen_string_literal: true

# CRITICAL HOOK: Block launching SaneBar locally
# Reason: Debug builds cause windows to appear offscreen (unfixable bug)
# Only building and testing (headless) are allowed

require 'json'

begin
  input = JSON.parse($stdin.read)
rescue JSON::ParserError, Errno::ENOENT
  exit 0
end

tool_name = input['tool_name']
tool_input = input['tool_input'] || {}

# Only check Bash commands
exit 0 unless tool_name == 'Bash'

command = tool_input['command'].to_s.downcase

# Patterns that would launch SaneBar
launch_patterns = [
  /open\s+.*sanebar\.app/i,
  /open\s+.*\/debug\/sanebar/i,
  /open\s+.*\/release\/sanebar/i,
  /sanebar\.app\/contents\/macos\/sanebar/i,
  /build_run_macos.*sanebar/i,
  /test_mode/i,  # SaneMaster.rb test_mode launches the app
  /xcodebuild.*-destination.*run/i,
]

# Check if command matches any launch pattern
launch_patterns.each do |pattern|
  if command.match?(pattern)
    warn '🛑 BLOCKED: Cannot launch SaneBar locally'
    warn ''
    warn '   Debug builds cause windows to appear OFFSCREEN.'
    warn '   This is a known unfixable bug with local builds.'
    warn ''
    warn '   ✅ ALLOWED: xcodebuild build (compile only)'
    warn '   ✅ ALLOWED: xcodebuild test (headless)'
    warn '   ✅ ALLOWED: grep/read code files'
    warn '   ❌ BLOCKED: open SaneBar.app'
    warn '   ❌ BLOCKED: test_mode (launches app)'
    warn '   ❌ BLOCKED: build_run_macos'
    warn ''
    warn '   To verify changes, use code review or unit tests.'
    exit 2
  end
end

exit 0
