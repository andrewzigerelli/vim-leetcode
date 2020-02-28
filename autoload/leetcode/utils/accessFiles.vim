"" Data Storage {{{1
fu! leetcode#utils#accessFiles#buildDataContainer()
  if !isdirectory(g:leetcode_data_path)
    cal system('mkdir -p "' . g:leetcode_data_path .'"')
  endif
endfu

"" Last Test/Submit result {{{2
fu! leetcode#utils#accessFiles#buildLastRunResultStorage()
  if !filereadable(g:leetcode_last_run_result_path)
    cal system('touch "' .g:leetcode_last_down_Q_data_path .'"')
  endif
endfu

fu! leetcode#utils#accessFiles#appendTextToLastRunResultStorage(text)
  cal leetcode#utils#accessFiles#buildLastRunResultStorage()
  "" Append text in this way but not in a Vim way to avoid pollution to buffer, jumplist, etc
  cal system('echo "' .escape(a:text, '"') .'" >> "' .g:leetcode_last_run_result_path .'"')
endfu

fu! leetcode#utils#accessFiles#clearLastRunResultStorage()
  cal leetcode#utils#accessFiles#buildLastRunResultStorage()
  "" clear in this way but not in a Vim way to avoid pollution to buffer, jumplist, etc
  cal system(' > "' .g:leetcode_last_run_result_path .'"')
endfu

"" Last Did Code Files for Diff Qs {{{2
fu! leetcode#utils#accessFiles#buildLastDidCodeFilesDir()
  cal leetcode#utils#accessFiles#buildDataContainer()
  if !isdirectory(g:leetcode_last_did_code_files_dir_path)
    cal system('mkdir "' .g:leetcode_last_did_code_files_dir_path .'"')
  endif
endfu

fu! leetcode#utils#accessFiles#getLastDidCodeFilePath(Q_fullname)
  retu g:leetcode_last_did_code_files_dir_path .g:leetcode_path_delimit .a:Q_fullname
endfu

fu! leetcode#utils#accessFiles#lastDidCodeFileStorageExists(Q_fullname)
  retu filereadable(leetcode#utils#accessFiles#getLastDidCodeFilePath(a:Q_fullname))
endfu

fu! leetcode#utils#accessFiles#buildLastDidCodeFileStorage(Q_fullname)
  cal leetcode#utils#accessFiles#buildLastDidCodeFilesDir()
  let storage_path = g:leetcode_last_did_code_files_dir_path .g:leetcode_path_delimit .a:Q_fullname
  if !filereadable(storage_path)
    cal system('touch "' .storage_path .'"')
  endif
  retu storage_path
endfu

fu! leetcode#utils#accessFiles#appendTextToLastDidCodeFileStorage(Q_fullname, text)
  let storage_path = leetcode#utils#accessFiles#buildLastDidCodeFileStorage(a:Q_fullname)
  "" Append text in this way but not in a Vim way to avoid pollution to buffer, jumplist, etc
  cal system('echo "' .escape(a:text, '"') .'" >> "' .storage_path .'"')
endfu

fu! leetcode#utils#accessFiles#clearLastDidCodeFileStorage(Q_fullname)
  let storage_path = leetcode#utils#accessFiles#buildLastDidCodeFileStorage(a:Q_fullname)
  "" clear in this way but not in a Vim way to avoid pollution to buffer, jumplist, etc
  cal system(' > "' .storage_path .'"')
endfu

fu! leetcode#utils#accessFiles#writeLastDidCodeFileInfo(Q_fullname, destination_dir_path, Q_filepath, code_filename, code_filepath)
  cal leetcode#utils#accessFiles#clearLastDidCodeFileStorage(a:Q_fullname)
  cal leetcode#utils#accessFiles#appendTextToLastDidCodeFileStorage(a:Q_fullname, 'destination_dir_path: "' .a:destination_dir_path .'"')
  cal leetcode#utils#accessFiles#appendTextToLastDidCodeFileStorage(a:Q_fullname, 'Q_filepath: "' .a:Q_filepath .'"')
  cal leetcode#utils#accessFiles#appendTextToLastDidCodeFileStorage(a:Q_fullname, 'code_filename: "' .a:code_filename .'"')
  cal leetcode#utils#accessFiles#appendTextToLastDidCodeFileStorage(a:Q_fullname, 'code_filepath: "' .a:code_filepath .'"')
endfu

"" @return  [destination_dir_path, Q_filepath, code_filename, code_filepath]
fu! leetcode#utils#accessFiles#readLastDidCodeFileInfo(Q_fullname)
  let info = []
  exe 'sil e! ' .leetcode#utils#accessFiles#getLastDidCodeFilePath(a:Q_fullname)
  cal add(info, substitute(getline(search('destination_dir_path: "')), 'destination_dir_path: "\|"$', '', 'g'))
  cal add(info, substitute(getline(search('Q_filepath: "')), 'Q_filepath: "\|"$', '', 'g'))
  cal add(info, substitute(getline(search('code_filename: "')), 'code_filename: "\|"$', '', 'g'))
  cal add(info, substitute(getline(search('code_filepath: "')), 'code_filepath: "\|"$', '', 'g'))
  b #
  bd! #
  retu info
endfu

"" Last Downloaded Question {{{2
fu! leetcode#utils#accessFiles#buildLastDownQStorage()
  cal leetcode#utils#accessFiles#buildDataContainer()
  if !filereadable(g:leetcode_last_down_Q_data_path)
    cal system('touch "' .g:leetcode_last_down_Q_data_path .'"')
  endif
endfu

fu! leetcode#utils#accessFiles#appendTextToLastDownQStorage(text)
  cal leetcode#utils#accessFiles#buildLastDownQStorage()
  "" Append text in this way but not in a Vim way to avoid pollution to buffer, jumplist, etc
  cal system('echo "' .escape(a:text, '"') .'" >> "' .g:leetcode_last_down_Q_data_path .'"')
endfu

fu! leetcode#utils#accessFiles#clearLastDownQStorage()
  cal leetcode#utils#accessFiles#buildLastDownQStorage()
  "" clear in this way but not in a Vim way to avoid pollution to buffer, jumplist, etc
  cal system(' > "' .g:leetcode_last_down_Q_data_path .'"')
endfu

fu! leetcode#utils#accessFiles#writeLastDownQInfo(Q_fullname, destination_dir_path, Q_filepath, code_filename, code_filepath)
  cal leetcode#utils#accessFiles#clearLastDownQStorage()
  cal leetcode#utils#accessFiles#appendTextToLastDownQStorage('Q_fullname: "' .a:Q_fullname .'"')
  cal leetcode#utils#accessFiles#appendTextToLastDownQStorage('destination_dir_path: "' .a:destination_dir_path .'"')
  cal leetcode#utils#accessFiles#appendTextToLastDownQStorage('Q_filepath: "' .a:Q_filepath .'"')
  cal leetcode#utils#accessFiles#appendTextToLastDownQStorage('code_filename: "' .a:code_filename .'"')
  cal leetcode#utils#accessFiles#appendTextToLastDownQStorage('code_filepath: "' .a:code_filepath .'"')
endfu

"" @return  [Q_fullname, destination_dir_path, Q_filepath, code_filename, code_filepath]
fu! leetcode#utils#accessFiles#readLastDownQInfo()
  let info = []
  exe 'sil e! ' .g:leetcode_last_down_Q_data_path
  cal add(info, substitute(getline(search('Q_fullname: "')), 'Q_fullname: "\|"$', '', 'g'))
  cal add(info, substitute(getline(search('destination_dir_path: "')), 'destination_dir_path: "\|"$', '', 'g'))
  cal add(info, substitute(getline(search('Q_filepath: "')), 'Q_filepath: "\|"$', '', 'g'))
  cal add(info, substitute(getline(search('code_filename: "')), 'code_filename: "\|"$', '', 'g'))
  cal add(info, substitute(getline(search('code_filepath: "')), 'code_filepath: "\|"$', '', 'g'))
  b #
  bd! #
  retu info
endfu

"" Did questions & solutions {{{1
"" @return  a Vim list of all existing code filenames for the specified question
fu! leetcode#utils#accessFiles#allCodeFiles(Q_fullname)
  let root_path = leetcode#utils#path#getRootDir()
  let code_dir_path = root_path .g:leetcode_path_delimit .a:Q_fullname
  let all_code_filenames = split(globpath(fnameescape(code_dir_path), '*\.' .leetcode#lang#utils#getExt()), '\n')
  cal map(all_code_filenames, {key, val -> matchstr(val, g:leetcode_path_delimit .'\zs[^\' .g:leetcode_path_delimit .']*\ze$')})
  retu all_code_filenames
endfu

"" @return  a Vim list of all did questions
fu! leetcode#utils#accessFiles#allDidQ()
  let root_path = leetcode#utils#path#getRootDir()
  let all_did_Q = split(globpath(root_path, '*' .g:leetcode_path_delimit), '\n')
  cal map(all_did_Q, {key, val -> matchstr(val, g:leetcode_path_delimit
        \.'\zs[^\' .g:leetcode_path_delimit .']*\ze' .g:leetcode_path_delimit .'$')})
  retu all_did_Q
endfu
