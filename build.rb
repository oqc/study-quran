#!/usr/bin/env ruby

require 'fileutils'

fn = ARGV[0]

puts `xelatex -output-dir=output #{fn}`
FileUtils.mv "build/#{fn}.pdf", '.'
