path = require 'path'
proc = require 'child_process'
temp = require 'temp'
fs = require 'fs'

ARG_COMPILE_SCRIPT = path.join(__dirname, 'post_compile')
ARG_BOARD = 'atmega328p'
ARG_TOOLS = 'foo'
ARG_PATH = __dirname
ARG_FILE = 'test'

module.exports =

class PostCompile

  @execute: (sketch, sketchHex) ->
    # Call this after the BCC compile is successful

    console.log "Executing post compile step..."

    temp.cleanupSync()

    temp.mkdir 'bcc-tmp', (err, dirPath) =>
      if err
        console.log "Failed to open temp dir: #{err}"
      else
        console.log "Opened temp dir..."
        inputPath =  path.join(dirPath, sketch.base)
        fs.writeFile inputPath, sketchHex, (err)=>
          if err
            console.log "Writing temp file failed: #{err}"
          else
            console.log "Spawning child process..."
            tmpSketch = path.parse(inputPath)
            console.log "Saved temp sketch file: #{tmpSketch.dir}/#{tmpSketch.base}"
            cmd = "#{ARG_COMPILE_SCRIPT} -board=#{ARG_BOARD} -tools=#{ARG_TOOLS} -path=#{tmpSketch.dir} -file=#{tmpSketch.name}"
            proc.execSync(cmd)
