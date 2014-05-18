module.exports = function(grunt) {
  'use strict';
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      all: ['Gruntfile.js', 'src/*.js']
    },
    concat: {
      dist: {
        src: ['src/JsonML.js', 'src/WaveDrom.js', 'src/Save.js'],
        dest: 'build/build.js',
      },
    },
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      build: {
        src: 'build/build.js',
        dest: 'build/WaveDrom.js'
      }
    },
    nodewebkit: {
      options: {
        build_dir: './nw_builds',
        mac: true,
        win: true,
        linux32: true,
        linux64: true
      },
      src: ['./WaveDromEditor/*']
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-node-webkit-builder');

  // Default task(s).
  grunt.registerTask('default', ['jshint', 'concat', 'uglify', 'nodewebkit']);
};
