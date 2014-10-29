module.exports = function(grunt) {
  'use strict';
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    eslint: {
      all: ['Gruntfile.js', 'editor.js']
    },
    copy: {
      editor: {
        files: [
          {expand: true, src: [
            'WaveDrom.js', 'editor.js',
            'editor.html', 'tutorial.html',
            'images/ic_*.png', 'images/favicon.ico', 'images/logo.png',
            'skins/*', 'css/*', 'scripts/*'
          ], dest: 'WaveDromEditor_build/', filter: 'isFile'},
          {expand: true, flatten: true, src: ['WaveDromEditor/package.json'], dest: 'WaveDromEditor_build/', filter: 'isFile'}
        ]
      }
    },
    nodewebkit: {
      options: {
        // version: '0.10.5',
        buildDir: './nw_builds',
        platforms: ['win', 'osx', 'linux32', 'linux64'],
        keep_nw: true
      },
      src: ['./WaveDromEditor_build/**']
    },
    compress: {
      win: {
        options: {archive: 'nw_builds/<%= pkg.name %>-v<%= pkg.version %>-win-ia32.zip'},
        files: [{expand: true, cwd: 'nw_builds/WaveDromEditor/win/', src: ['**'], dest: '.'}]
      },
      linux32: {
        options: {archive: 'nw_builds/<%= pkg.name %>-v<%= pkg.version %>-linux-ia32.tar.gz'},
        files: [{expand: true, cwd: 'nw_builds/', src: ['WaveDromEditor/linux32/**'], dest: '.'}]
      },
      linux64: {
        options: {archive: 'nw_builds/<%= pkg.name %>-v<%= pkg.version %>-linux-x64.tar.gz'},
        files: [{expand: true, cwd: 'nw_builds/', src: ['WaveDromEditor/linux64/**'], dest: '.'}]
      },
      osx: {
        options: {archive: 'nw_builds/<%= pkg.name %>-v<%= pkg.version %>-osx-ia32.zip'},
        files: [{expand: true, cwd: 'nw_builds/WaveDromEditor/osx/', src: ['**'], dest: '.'}]
      },
      nw: {
        options: {archive: 'nw_builds/<%= pkg.name %>-v<%= pkg.version %>.nw', mode: 'zip'},
        files: [{expand: true, cwd: 'WaveDromEditor_build/', src: ['**'], dest: '.'}]
      }
    },
    clean: {
        nw_builds: ['nw_builds'],
        build: ['build'],
        node: ['node_modules'],
        WaveDromEditor_build: ['WaveDromEditor_build'],
        cache: ['cache']
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-eslint');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-node-webkit-builder');
  grunt.loadNpmTasks('grunt-contrib-compress');
  grunt.loadNpmTasks('grunt-contrib-clean');

  // Default task(s).
  grunt.registerTask('build', ['eslint', 'copy:editor', 'nodewebkit']);
  grunt.registerTask('default', ['build', 'compress']);
};
