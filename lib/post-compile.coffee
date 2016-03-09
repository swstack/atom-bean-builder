path = require 'path'
proc = require 'child_process'
temp = require 'temp'
fs = require 'fs'

ARG_COMPILE_SCRIPT = path.join(__dirname, 'post_compile')
ARG_BOARD = 'atmega328p'
ARG_TOOLS = 'foo'
ARG_PATH = __dirname
ARG_FILE = 'test'

temp.track()

module.exports =

class PostCompile

  @execute: (sketchHex) ->
    # Call this after the BCC compile is successful

    console.log "Executing post compile step..."

    temp.open 'bcc-tmp', (err, info) =>
      if err
        console.log "Failed to open temp file: #{err}"
      else
        fs.write info.fd, sketchHex
        fs.close info.fd, (err) =>
          if err
            console.log "Failed to close file: #{err}"
          else
            console.log "Here!!!"
            tmpSketch = path.parse(info.path)
            console.log "#{path}"
            cmd = "#{ARG_COMPILE_SCRIPT} -board=#{ARG_BOARD} -tools=#{ARG_TOOLS} -path=#{tmpSketch.dir} -file=#{tmpSketch.base}"
            proc.execSync(cmd)
