module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    uglify: {
      dist: {
        files: {
          'dist/rsc.min.js': ['dist/rsc.js']
        }
      }
    },

    coffee: {
      compileJoined: {
        options: {
          join: true
        },
        files: {
          'dist/rsc.js': 'lib/**/**.coffee'
        }
      }
    },

    sass: {
      nested: {
        options: {
          sourcemap: 'none',
          style: 'nested'
        },
        files: {
          'dist/rsc.css': 'stylesheets/application.scss'
        }
      },

      compressed: {
        options: {
          sourcemap: 'none',
          style: 'compressed'
        },
        files: {
          'dist/rsc.min.css': 'dist/rsc.css'
        }
      }
    },

    copy: {
      main: {
        files: [{
          expand: true,
          src: ['images/*'],
          dest: 'dist/images/',
          filter: 'isFile'
        }]
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-copy');

  grunt.registerTask('default', [
    'coffee', 'uglify', 'sass:nested', 'sass:compressed', 'copy'
  ]);
};