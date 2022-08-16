let s:lang = 'cpp'
let s:ext = 'cpp'
let s:Makefile = [
      \'CXX=clang++',
      \'DEBUG_FLAGS=-fsanitize=address -fsanitize=undefined -fno-sanitize-recover=all -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fno-sanitize=null -fno-sanitize=alignment -g',
      \'CXX_FLAGS=-std=c++20',
      \'',
      \'all: *.cpp',
      \'	$(CXX) $(CXX_FLAGS) $< -lgtest -lpthread -o soln',
      \'',
      \'debug: *.cpp',
      \'	$(CXX) $(DEBUG_FLAGS) $< -lgtest -lpthread -o soln_debug',
      \'',
      \'clean: ',
      \'	rm -f soln soln_debug',]

let s:dependencies = [
      \'/*** [' .g:leetcode_name .'] For Local Syntax Checking ***/',
      \'#define DEPENDENCIES', '#ifdef DEPENDENCIES',
      \'#include <iostream>', '#include <iomanip>',
      \'#include <istream>', '#include <ostream>',  
      \'#include <sstream>',  '#include <stdio.h>',  
      \'#include <vector>',  '#include <stack>',
      \'#include <map>',  '#include <unordered_map>',  
      \'#include <set>',  '#include <unordered_set>',
      \'#include <list>',  '#include <forward_list>', 
      \'#include <array>', '#include <deque>',  
      \'#include <queue>',  '#include <bitset>', 
      \'#include <utility>',  '#include <algorithm>',  
      \'#include <string>', '#include <limits>',  
      \'#include <gtest/gtest.h>',  
      \'using namespace std;', '#endif', '']

let s:driver_code = [
      \'', '#ifdef DEPENDENCIES',
      \'TEST(SolnComp, SolnOutput) {',
      \'    // Change method arguments to test inputs',
      \'    // Change output to expected output',
      \'    Solution sln;',
      \'}',
      \'int main(int argc, char **argv) {',
      \'    ::testing::InitGoogleTest(&argc, argv);',
      \'    return RUN_ALL_TESTS();',
      \'}', '#endif',]
let s:depend_location = '/\mclass\s\+solution\c\s\+{/-' 
let s:code_begin_location = '?\m)\s*{?+'

fu! leetcode#lang#cpp#locateLeetcodeCliComment(topmost_line)
  exe 'keepj norm! ' .(a:topmost_line - 1) .'G'
  let comment_first_line = search('\/\*')
  let comment_last_line = searchpair('\/\*', '', '\*\/', 'W')
  return [comment_first_line, comment_last_line]
endfu

"" DEVELOPED BASED ON A LIMITED NUMBER OF KNOWN QUESTIONS WITH CUSTOM DEPENDENCIES
fu! leetcode#lang#cpp#getCustomDependencies()
  keepj norm! gg
  let lc_code_start_line = search('@\s*lc\s*code\s*=\s*start')
  let [comment_first_line, comment_last_line] = leetcode#lang#cpp#locateLeetcodeCliComment(lc_code_start_line + 1)
  exe 'keepj norm! ' .comment_first_line .'G'
  let definition_comment_line = search('\cdefinition for')
  if definition_comment_line == 0
    retu []
  endif
  let custom_depend = []
  let custom_depend_line = definition_comment_line + 1
  while custom_depend_line < comment_last_line
    exe 'keepj norm! ' .custom_depend_line .'G'
    cal add(custom_depend, getline(custom_depend_line))
    let custom_depend_line += 1
  endwhile
  cal map(custom_depend, {key, val -> matchstr(val, '\s*\*\+\s*\zs.*')})
  retu custom_depend
endfu

fu! leetcode#lang#cpp#appendDriverCode()
  let old_ul = &ul
  setl ul=-1
  "" Add basic driver code
  keepj norm! gg
  let lc_code_end_line = search('@\s*lc\s*code\s*=\s*end')
  keepj cal append(lc_code_end_line - 1, s:driver_code)

  "" Get method args
  let public_start = search('public:')
  let method = getline(public_start + 1)
  let method_split = split(method)
  let meth_return_type = method_split[0]
  let func_no_return_val = join(method_split[1:])
  let meth_args = matchstr(method, '(.*)')
  let meth_args_no_paren = substitute(meth_args, '\((\|)\)', '', 'g')
  let args_no_space = substitute(meth_args_no_paren, ', ', ',', 'g')
  let args = split(args_no_space, ',')

  "" add function return value
  let soln_line = search('Solution sln;')
  let output_str = '    ' .  meth_return_type . ' output;'
  keepj cal append(soln_line, output_str)

  "" Add method args & clean for method call later
  let meth_vars_line = search('Solution sln;')
  let i = 0
  for a in args
      let cur_arg = '    ' . args[i] . ';'
      keepj cal append(meth_vars_line + i, cur_arg)
      ""clean for later
      let args[i]= split(args[i])[1]
      let i += 1
  endfor


  "" Clean up func_no_return val and create TEST 
  let func_ = substitute(func_no_return_val, ' *{','', 'g')
  let func_name = matchstr(func_, '.*(')
  let arguments = join(args, ',')
  let meth_call = 'sln.' . func_name . arguments . ')'
  let meth_call = substitute(meth_call, ',', ', ', 'g')
  let meth_call = '    EXPECT_EQ (output, ' . meth_call . ');'

  "" Append method call
  let output_line = search(output_str)
  keepj cal append(output_line, meth_call)
  exe 'setlocal ul='.old_ul
endfu

fu! leetcode#lang#cpp#addMakefile()
    cal writefile(s:Makefile, "Makefile")
endfu

fu! leetcode#lang#cpp#addDependencies()
  keepj norm! gg   
  try | exe 'keepp sil ' .s:depend_location
  cat /E486/ 
    throw 'Error in locating the position to add dependencies'
  endt
  "" Add dependencies and make it non-undoable
  let old_ul = &ul
  setl ul=-1
  keepj cal append(line('.'), s:dependencies)
  let custom_depend = leetcode#lang#cpp#getCustomDependencies()
  let custom_depend_begin_line = search(s:dependencies[len(s:dependencies) - 3])
  keepj cal append(custom_depend_begin_line, custom_depend)
  exe 'setlocal ul='.old_ul
  retu 1
endfu

fu! leetcode#lang#cpp#foldDependencies()
  setl foldmethod=manual
  try 
    keepj norm! gg
    let first_fold_line = search(escape(s:dependencies[0], '/*[]'))
    if foldclosed(first_fold_line) == -1
      exe 'keepj keepp sil /\m\C\s*\/\{-,2}\s*' .s:dependencies[2] .'\s*$'
      let last_fold_line = searchpair('\C\s*#ifdef\>', '', '\C\s*endif\>', 'W')
      exe 'keepj norm! ' .first_fold_line .'G' .(last_fold_line - first_fold_line + 1) .'zF'
    en
    retu 1
  cat /E486/
    throw 'Error in locating the dependencies to fold'
  endt
endfu

fu! leetcode#lang#cpp#goToWhereCodeBegins()
  keepj keepp sil /\m\%$/
  try 
    exe 'sil ' .s:code_begin_location
  cat /E486/
    throw 'Error in locating where to start code writing.'
  endt
endfu

fu! leetcode#lang#cpp#commentDependencies()
  exe 'keepj keepp sil %sm@\C^\(.*' .s:dependencies[1] .'.*\)$@//\1@'
endfu

fu! leetcode#lang#cpp#uncommentDependencies()
  exe 'keepj keepp sil %sm@\C\s*\zs/*\ze.*' .s:dependencies[1] .'.*$@@'
endfu

fu! leetcode#lang#cpp#getExt()
  retu s:ext
endfu
