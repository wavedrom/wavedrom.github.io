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
      src: ['./WaveDromEditor_build/*']
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-copy');
//  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-node-webkit-builder');

  // Default task(s).
  grunt.registerTask('default', ['jshint', 'copy', 'nodewebkit']);
};
