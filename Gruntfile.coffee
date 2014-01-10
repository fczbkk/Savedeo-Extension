module.exports = (grunt) ->

  grunt.initConfig
  
    pkg: grunt.file.readJSON 'package.json'
    
    coffeelint:
      app: ['src/coffee/**/*.coffee']
    
    coffee:
      default:
        options:
          bare: true
        files:
          # Firefox
          'extension/firefox/lib/main.js' : [
            'src/coffee/general/utilities.coffee'
            'src/coffee/firefox/main.coffee'
          ]
          # Chrome
          'extension/chrome/background.js' : [
            'src/coffee/general/utilities.coffee'
            'src/coffee/chrome/background.coffee'
          ]
          'extension/chrome/content.js' : [
            'src/coffee/chrome/content.coffee'
          ]
          # Node
          'crawler/server.js' : [
            'src/coffee/node/server.coffee'
          ]
    
    watch:
      default:
        options:
          atStart: true
        files: ['src/coffee/**/*.coffee']
        tasks: ['dev']
    
    'mozilla-addon-sdk':
      '1_15':
        options:
          revision: '1.15'
      master:
        options:
          revision: 'master'
          github: true

    'mozilla-cfx-xpi':
      stable:
        options:
          'mozilla-addon-sdk': '1_15'
          extension_dir: 'extension/firefox'
          dist_dir: 'build/firefox/stable'
      experimental:
        options:
          'mozilla-addon-sdk': 'master'
          extension_dir: 'extension/firefox'
          dist_dir: 'build/firefox/experimental'

    'mozilla-cfx':
      run_stable:
        options:
          'mozilla-addon-sdk': '1_15'
          extension_dir: 'extension/firefox'
          command: 'run'
      run_experimental:
        options:
          'mozilla-addon-sdk': 'master'
          extension_dir: 'extension/firefox'
          command: 'run'
    
    compress:
      chrome:
        options:
          archive: 'build/chrome/<%= pkg.name %>.zip'
        expand: true
        cwd: 'extension/chrome/'
        src: ['**/*']
    
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-mozilla-addon-sdk'
  grunt.loadNpmTasks 'grunt-contrib-compress'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  
  grunt.registerTask 'default', ['watch:default']
  grunt.registerTask 'dev', [
    'coffeelint'
    'coffee:default'
  ]

  grunt.registerTask 'build', (target = 'build') ->
    grunt.task.run [
      'dev'
      "bump:#{target}"
      'updateInfo'
      'mozilla-cfx-xpi'
      'compress:chrome'
    ]
  
  grunt.registerTask 'updateInfo', 'Update manifest and package files.', ->
    pkg = grunt.config 'pkg'
    # Chrome manifest.json
    chrome_manifest_json_path = 'extension/chrome/manifest.json'
    file = grunt.file.readJSON chrome_manifest_json_path
    grunt.log.write "Updating Chrome manifest.json from #{file.version} to #{pkg.version}.\n"
    file.name = pkg.title
    file.description = pkg.description
    file.version = pkg.version
    grunt.file.write chrome_manifest_json_path, (JSON.stringify file, null, '  ')
    # Firefox package.json
    firefox_package_json_path = 'extension/firefox/package.json'
    file = grunt.file.readJSON firefox_package_json_path
    grunt.log.write "Updating Firefox package.json from #{file.version} to #{pkg.version}.\n"
    file.fullName = pkg.title
    file.description = pkg.description
    file.version = pkg.version
    grunt.file.write firefox_package_json_path, (JSON.stringify file, null, '  ')
  
  # TODO: Replace this task with grunt-contrib-bump when it becomes available.
  # https://github.com/gruntjs/grunt-contrib-bump
  grunt.registerTask 'bump', 'Update version number.', (target) ->
    
    # get and validate version
    version = (grunt.config 'pkg').version.split '.'
    if not version
      grunt.log.error 'Version is not defined in package.json.'
    if version.length < 3
      grunt.log.error 'Version string is in wrong format. Use "x.y.z".'
    
    # set the version index based on provided target
    switch target
      when 'major' then versionIndex = 0
      when 'minor' then versionIndex = 1
      else versionIndex = 2
    
    # update version numbers
    for i, j of version
      i = parseInt i, 10
      j = parseInt j, 10
      version[i] = j + 1 if i is versionIndex
      version[i] = 0 if i > versionIndex
    
    # write new version number into package.json
    packagePath = 'package.json'
    pkg = grunt.file.readJSON packagePath
    pkg.version = version.join '.'
    grunt.log.write 'Bumping version to:', pkg.version
    grunt.file.write packagePath, JSON.stringify pkg, null, '  '
    
    # update grunt pkg to notify subsequent tasks
    grunt.config 'pkg', pkg