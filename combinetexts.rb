#!/usr/bin/env ruby

CHAPTER_SIZES =
%w{7 286 200 176 120 165 206 75 129 109 123 111 43 52 99 128 111 110 98 135 112 78
118 64 77 227 93 88 69 60 34 30 73 54 45 83 182 88 75 85 54 53 89 59 37 35 38 29
18 45 60 49 62 55 78 96 29 22 24 13 14 11 11 18 12 12 30 52 52 44 28 28 20 56 40
31 50 40 46 42 29 19 36 25 22 17 19 26 30 20 15 21 11 8 8 19 5 8 8 11 11 8 3 9 5
4 7 3 6 3 5 4 5 6}.map(&:to_i)

def load_to_a(fn); open(fn, 'r:bom|utf-8').read.gsub("\xEF\xBB\xBF", '').split("\n"); end

text_a = load_to_a 'texts/ar.yuksel/ar.yuksel.txt'
text_l = load_to_a 'texts/en.yuksel/en.yuksel.txt'
text_c = load_to_a 'texts/nl.leemhuis/nl.leemhuis.txt'
text_r = load_to_a 'texts/nl.siregar/nl.siregar.txt'

r = ''  # to contain the resulting text
l = 0   # the line number in the files
@q = {} # the qoute state like: {:text_l => true}
@c = 0  # remember last chapter nr

def fix_q(txt, scope, line_nr, c)
  txt[line_nr].strip.gsub('"', "''")
end

def fix_Q(txt, scope, line_nr, c)
  if @c != c  # check for unbalanced qoutes on chapter ends
    if @q.values.reduce { |x,y| x or y }  # any trues?
      puts "UNBALANCED QUOTES in chapter #{c-1}; #{@q.inspect}"
    end
    @q = {}  # reset quotation states
    @c = c
  end
  r = txt[line_nr].strip
  q_nrs = (1..r.scan(/"/).size)  # size 0 gives empty array
  if @q[scope]  # quotation still open
    q_nrs = q_nrs.map { |n| n + 1 }  # switch odds and evens
  end
  @q[scope] = q_nrs.last.odd? if q_nrs.last
  q_nrs.each do |n|
    r.sub!('"', (n.odd? ? '``' : "''"))
  end
  r
end

c = 0
(ARGV[0] == 'q' ? [7, 50] : CHAPTER_SIZES).each do |v_count|
  c += 1
  p [c, v_count, r.length]
  r << "\\midrule\\\\nopagebreak\n" unless c == 1
  r << "\\bsm\n" unless (c == 1 || c == 9)
  v_count.times do |v|
    bsm = (v == 0 && c != 1 && c != 9)  # true if bismallah should be added
    r << "\\ara{#{c}:#{v+1}}{#{text_a[l].strip}}\n"
    r << "\\eng{#{text_l[0].strip}}\\newline\n" if bsm
    r << "\\eng{#{fix_q text_l, :l, l, c}} &\n"
    r << "#{text_c[0].strip}\\newline\n" if bsm
    r << "#{fix_q text_c, :c, l, c} &\n"
    r << "#{text_r[0].strip}\\newline\n" if bsm
    r << "#{fix_q text_r, :r, l, c} \\\\\\\\\n"
    l += 1
  end
end

new_txt = open('study-quran.tex').read.gsub(/^% BEGIN TEXTS.*% END TEXTS/m, "% BEGIN TEXTS\n#{r}\n% END TEXTS")
open('study-quran.tex', 'w') { |f| f.puts new_txt }


