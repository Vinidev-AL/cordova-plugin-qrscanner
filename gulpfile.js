'use strict';

const { src, dest, series, parallel } = require('gulp');
const insert = require('gulp-insert');
const fs = require('fs');
const exec = require('child_process').exec;

const remap = fs.readFileSync('src/common/src/cordova-remap.js', 'utf-8');

function runWebpack(config) {
  return function(cb) {
    exec(`${__dirname}/node_modules/.bin/webpack --config ${config}`, (error, stdout, stderr) => {
      console.log(stdout);
      console.error(stderr);
      cb(error);
    });
  };
}

const prepack = runWebpack('webpack.prepack.config.js');
const webpackCordova = series(prepack, runWebpack('webpack.cordova.config.js'));
const dist = series(prepack, runWebpack('webpack.library.config.js'));

function remapTask() {
  return src(['dist/plugin.min.js', 'dist/www.min.js'])
    .pipe(insert.prepend(remap))
    .pipe(dest('dist'));
}

function plugin() {
  return src('dist/plugin.min.js')
    .pipe(dest('src/browser'));
}

function www() {
  return src('dist/www.min.js')
    .pipe(dest('www'));
}

exports.prepack = prepack;
exports['webpack-cordova'] = webpackCordova;
exports.dist = dist;
exports.remap = series(webpackCordova, remapTask);
exports.plugin = series(exports.remap, plugin);
exports.www = series(exports.remap, www);
exports.default = series(dist, exports.plugin, exports.www);