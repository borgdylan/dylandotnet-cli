var gulp = require('gulp');
var uglify = require('gulp-uglify');
var rename = require('gulp-rename');
var less = require('gulp-less');
var cssmin = require('gulp-cssmin');
var util  = require('util'),
    spawn = require('child_process').spawn;
var stripAnsi = require('strip-ansi');

gulp.task('run', function(cb) {
	var ls = spawn('sh', ['-c', 'dotnet run -f net461']);
	ls.stdout.on('data', function (data) {
		process.stdout.write(data);
	});

	ls.stderr.on('data', function (data) {
		process.stdout.write(data);
	});

	ls.on('exit', function (code) {
		process.stdout.write('child process exited with code ' + code);
	});
});

gulp.task('restore', function(cb) {
	var ls = spawn('sh', ['-c', 'dotnet restore']);
	ls.stdout.on('data', function (data) {
		process.stdout.write(data);
	});

	ls.stderr.on('data', function (data) {
		process.stdout.write(data);
	});

	ls.on('exit', function (code) {
		process.stdout.write('child process exited with code ' + code);
	});
});

gulp.task('build', function(cb) {
	var ls = spawn('sh', ['-c', 'dotnet build -c Debug']);
	ls.stdout.on('data', function (data) {
		process.stdout.write(stripAnsi(String(data)));
	});

	ls.stderr.on('data', function (data) {
		process.stdout.write(stripAnsi(String(data)));
	});

	ls.on('exit', function (code) {
		process.stdout.write('child process exited with code ' + code);
	});
});
