#!/usr/bin/env ruby

CHAPTER_SIZES = { 1 => 7, 2 => 286, 3 => 200, 4 => 176, 5 => 120, 6 => 165, 7 => 206, 8 => 75, 9 => 129, 10 => 109, 11 => 123, 12 => 111, 13 => 43, 14 => 52, 15 => 99, 16 => 128, 17 => 111, 18 => 110, 19 => 98, 20 => 135, 21 => 112, 22 => 78, 23 => 118, 24 => 64, 25 => 77, 26 => 227, 27 => 93, 28 => 88, 29 => 69, 30 => 60, 31 => 34, 32 => 30, 33 => 73, 34 => 54, 35 => 45, 36 => 83, 37 => 182, 38 => 88, 39 => 75, 40 => 85, 41 => 54, 42 => 53, 43 => 89, 44 => 59, 45 => 37, 46 => 35, 47 => 38, 48 => 29, 49 => 18, 50 => 45, 51 => 60, 52 => 49, 53 => 62, 54 => 55, 55 => 78, 56 => 96, 57 => 29, 58 => 22, 59 => 24, 60 => 13, 61 => 14, 62 => 11, 63 => 11, 64 => 18, 65 => 12, 66 => 12, 67 => 30, 68 => 52, 69 => 52, 70 => 44, 71 => 28, 72 => 28, 73 => 20, 74 => 56, 75 => 40, 76 => 31, 77 => 50, 78 => 40, 79 => 46, 80 => 42, 81 => 29, 82 => 19, 83 => 36, 84 => 25, 85 => 22, 86 => 17, 87 => 19, 88 => 26, 89 => 30, 90 => 20, 91 => 15, 92 => 21, 93 => 11, 94 => 8, 95 => 8, 96 => 19, 97 => 5, 98 => 8, 99 => 8, 100 => 11, 101 => 11, 102 => 8, 103 => 3, 104 => 9, 105 => 5, 106 => 4, 107 => 7, 108 => 3, 109 => 6, 110 => 3, 111 => 5, 112 => 4, 113 => 5, 114 => 6 }

def load_to_a(fn); open(fn, 'r:bom|utf-8').read.split("\n"); end

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

((ARGV[0] || [])[0] == 'q' ? {1 => 7, 2 => 50} : CHAPTER_SIZES).each_pair do |c, v_count|
  r << "\\midrule\\\\nopagebreak\n" unless c == 1
  r << "\\bsm\n" unless (c == 1 || c == 9)
  v_count.times do |v|
    bsm = (v == 0 && c != 1 && c != 9)  # true is bismallah should be added
    r << "\\ara{#{c}:#{v+1}}{#{text_a[l]}}\n"
    r << "\\eng{#{text_l[0]}}\\newline\n" if bsm
    r << "\\eng{#{fix_q text_l, :l, l, c}} &\n"
    r << "#{text_c[0]}\\newline\n" if bsm
    r << "#{fix_q text_c, :c, l, c} &\n"
    r << "#{text_r[0]}\\newline\n" if bsm
    r << "#{fix_q text_r, :r, l, c} \\\\\\\\\n"
    l += 1
  end
end
#r << "\\midrule\n"


new_txt = open('study-quran.tex').read.gsub(/^% BEGIN TEXTS.*^% END TEXTS/m, "% BEGIN TEXTS\n#{r}% END TEXTS")
open('study-quran.tex', 'w') { |f| f.puts new_txt }


