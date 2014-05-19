module.exports = function(grunt) {
  'use strict';
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      all: ['Gruntfile.js']
    },
    copy: {
      editor: {
        files: [
          {expand: true, src: [
            'WaveDrom.js',
            'editor.html', 'tutorial.html',
            'images/ic_*.png', 'images/favicon.ico', 'logo.png',
            'skins/*', 'css/*', 'scripts/*'
          ], dest: 'WaveDromEditor_build/', filter: 'isFile'},
          {expand: true, flatten: true, src:['WaveDromEditor/package.json'], dest: 'WaveDromEditor_build/', filter: 'isFile'},
        ]
      }
    },
    nodewebkit: {
      options: {
        build_dir: './nw_builds',
        keep_nw: true,
        mac: true,
        win: true,
        linux32: true,
        linux64: true
      },
      src: ['./WaveDromEditor_build/**']
    },
    compress: {
      win: {
        options: {archive: 'nw_builds/<%= pkg.name %>-v<%= pkg.version %>-win-ia32.zip'},
        files: [{expand: true, cwd: 'nw_builds/releases/WaveDromEditor/win/', src: ['**'], dest: '.'}]
      },
      linux32: {
        options: {archive: 'nw_builds/<%= pkg.name %>-v<%= pkg.version %>-linux-ia32.tar.gz'},
        files: [{expand: true, cwd: 'nw_builds/releases/WaveDromEditor/linux32/', src: ['**'], dest: '.'}]
      },
      linux64: {
        options: {archive: 'nw_builds/<%= pkg.name %>-v<%= pkg.version %>-linux-x64.tar.gz'},
        files: [{expand: true, cwd: 'nw_builds/releases/WaveDromEditor/linux64/', src: ['**'], dest: '.'}]
      },
      mac: {
        options: {archive: 'nw_builds/<%= pkg.name %>-v<%= pkg.version %>-osx-ia32.zip'},
        files: [{expand: true, cwd: 'nw_builds/releases/WaveDromEditor/mac/', src: ['**'], dest: '.'}]
      },
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-node-webkit-builder');
  grunt.loadNpmTasks('grunt-contrib-compress');

  // Default task(s).
  grunt.registerTask('default', ['jshint', 'copy', 'nodewebkit', 'compress']);
};
