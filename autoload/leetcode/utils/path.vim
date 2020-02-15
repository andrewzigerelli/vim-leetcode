let g:leetcode_plugin_path = expand('<sfile>:p:h:h:h:h')

fu! leetcode#utils#path#init()
  if has('win32unix') || has('win16') || has('win32') || has('win64')
    let g:leetcode_path_delimit = '\'
  el
    let g:leetcode_path_delimit = '/'
  en
  let g:leetcode_data_path = g:leetcode_plugin_path .g:leetcode_path_delimit .'data'
  let g:leetcode_last_down_Q_data_path = g:leetcode_data_path .g:leetcode_path_delimit .'last_down_Q'
  let g:leetcode_undo_history_path = g:leetcode_data_path .g:leetcode_path_delimit .'tmp_undo_history'
endfu

fu! leetcode#utils#path#getRootDir()
  if exists('g:leetcode_root_dir')
    retu g:leetcode_root_dir
  el
    "" have the preceding blank line removed before returning
    retu split(execute('pwd'), '\n')[0]
  endif
endfu
