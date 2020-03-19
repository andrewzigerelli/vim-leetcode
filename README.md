# vim-leetcode

A Leetcode question and code file manager in Vim.

![Video demo][video-demo]

This plugin provides a file structure as shown in the demo. It also keeps track of your cursor position, provides a necessary assistance in making syntax checking plugins such as "syntastic" works, etc. Though this plugin moves around in and edits your leetcode code files, the undo history, search history, change list and jump list are not polluted. Therefore, built-in mappings such as `g;`, `<C-o>` and `u` still work great.

_This is [an example repository][vim-leetcode-example] in which the files are managed using this plugin._

## Requirement

- POSIX shell commands. Windows users may need to install tools such as [cygwin].
- Have [leetcode-cli][leetcode-cli-repo] installed and sign in.
    - ["skygragon/leetcode-cli"][leetcode-cli-obsolete-repo] is no longer in maintenance. Please fetch ["leetcode-tools/leetcode-cli"][leetcode-cli-repo].
    - If encountering problems in using it, check the status of its plugins. Please be reminded that cookie plugin is required for logging in a leetcode account.

## Installation

### Without plugin manager

For your reference, in an Unix-like system:

```bash
mkdir -p ~/.vim/plugged
cd ~/.vim/plugged
git clone https://github.com/8ooo8/leetcode.git
```

In ~/.vimrc, add below statement.

```vim
set runtimepath^=~/.vim/plugged/leetcode
```

### With plugin manager

For example, with manager "vim-plug":

```vim
Plug '8ooo8/leetcode'
```

## Commands

### The `LdoQ` command

```
:LdoQ [Question ID or Name] [Code Filename]
```

- **Load the (specified) leetcode code file, depending on the value of [`g:leetcode_view_Q`](#the-gleetcode_view_q-option) possibly also its corresponding question file in a split window, inside "Root Directory" whose path is indicated by [`g:leetcode_root_dir`](#the-gleetcode_root_dir-option).**
- File structure:
  - Under "Root Directory", there is a list of directories with names "[Question-ID] Question-Name", each storing its corresponding code and question files.
  - One such directory, one question and one or more code files.
  - Question files all are named as "Q.txt".
  - Code files may have custom names.
- Usages:
  - (1) `LdoQ`
    - **Load the last downloaded code file** (and its corresponding question file in a split window).
  - (2) `LdoQ Question-ID-or-Name`
    - **Load the last code file being opened by command `LdoQ`** for the specified question (and its corresponding question file in a split window).
    - **If no such file, download the question file and its code template** to open. The code file will have the default code template name given by [leetcode-cli][leetcode-cli-repo].
  - (3) `LdoQ Question-ID-or-Name Code-Filename`
    - **Load the specified code file** (and its corresponding question file in a split window).
    - **If no such file, download the question file and its code template** to open. The code file will be named as `[Code Filename]`.
  - Press **`<Tab>` to auto complete the parameters by the existing question and code files**; **`<C-d>` to list the available options** for the parameters.
  - `[Question ID or Name]` in either 1 of the following 3 forms.
    - "ID", "Name" and "[Question-ID] Question-Name".
    - Case-insensitive.
- This command edits the newly downloaded code files to make syntax checking apps, such as ["syntastic"][syntastic-repo], work.
- This command closes all other windows in the current tab.
- This command changes the present working directory of the window(s), in which the leetcode file(s) load(s), into the directory of the leetcode file(s).
- This command moves the cursor to the position of the last change made to the loaded code file. If it is a newly downloaded code file, move the cursor to where users' code starts. Afterwards, depending on the value of [`g:leetcode_auto_insert`](#the-gleetcode_auto_insert-option) possibly automatically enter Insert mode.
- This command does not pollute the change list, jump list, search history and undo history. Hence, built-in mappings such as `g;`, `<C-O>` and `u` are not affected.

### The `Lrename` command

```
:LrenameCodeFile {New Name}
```

- **Rename the code file in the current window** with `{New Name}`.
- If needed, update record of the name of the last downloaded code file, etc.

### The `Ltest` command

```
:Ltest [Test Case]
```

- **Test the code file in the current window** with the `[Test Case]`; with default test case if `[Test Case]` omitted.
- Before submitting the code to test, the code inserted for syntax check by [`LdoQ`](#the-ldoq-command) is commented to avoid an influence to the test. Upon the finish of the test, the code is uncommented and the code file is saved. Change list, jump list, search history and undo history are unpolluted. Hence, built-in mappings such as `g;`, `<C-O>` and `u` are not affected.

### The `Lsumbit` command

```
:Lsubmit
```

- **Sumbit the code file in the current window**.
- Before submitting the code, the code inserted for syntax check by [`LdoQ`](#the-ldoq-command) is commented to avoid an influence to the submission. Upon the finish of the submission, the code is uncommented and the code file is saved. Change list, jump list, search history and undo history are unpolluted. Hence, built-in mappings such as `g;`, `<C-O>` and `u` are not affected.

### The `LprintLastRunResult` command

```
:LprintLastRunResult
```
- **Show the last successful [`test`](#the-ltest-command) or successful [`submit`](#the-lsumbit-command) result**.

### The `LupdateREADME` command

```
:LupdateREADME
```

- **Update the table of content(see below) in README.md**; if no table found, append a table to README.md.
  ![Table of content in README.md][README-table-img]
- The items in the "Question" column are linked to the official web pages showing the same questions and the items in the "Solution" column are linked to their corresponding solution files.
- The items in the columns "Question", "Difficulty", "Acceptance" and "Solution" are automatically generated, while the rest needs to be input manually.
- Check this [example][vim-leetcode-example] for a clearer view of this command.

## Options

### The `g:leetcode_root_dir` option

```vim
let g:leetcode_root_dir = 'the_root_directory_of_leetcode_files'
```

- Set this to **determine where to store the leetcode code and question files, as well as where to search for the existing leetcode files**.
- If this variable does not exist, the present working directory of the current window in Vim will be used.

### The `g:leetcode_lang` option

```vim
let g:leetcode_lang = 'cpp'
```

- Set this to **determine which language to be used in doing leetcode questions**.
- Default value: 'cpp'
- Currently supported language(s): 'cpp'

### The `g:leetcode_view_Q` option

```vim
let g:leetcode_view_Q = 1
```

- Set **1 to open a vertical split window for the question file** when [`LdoQ`](#the-ldoq-command) command is used to load a code file; 0 to turn this off.
- Default value: 1

### The `g:leetcode_auto_insert` option

```vim
let g:leetcode_auto_insert = 1
```

- Set **1 to automatically enter insert mode after loading a code file** using command `LdoQ` (like auto pressing `a` to enter insert mode); 0 to turn this off.
- Default value: 1


## License
[MIT][MIT-license]

[MIT-license]: LICENSE
[README-table-img]: docs/screenshots/v0.3.0/README_table.png
[video-demo]: docs/screenshots/v0.1.0/demo.gif

[cygwin]: https://www.cygwin.com/
[leetcode-cli-obsolete-repo]: https://github.com/skygragon/leetcode-cli
[leetcode-cli-plugin-tutorial]: https://skygragon.github.io/leetcode-cli/commands#plugin
[leetcode-cli-repo]: https://github.com/leetcode-tools/leetcode-cli/
[syntastic-repo]: https://github.com/vim-syntastic/syntastic
[vim-leetcode-example]: https://github.com/8ooo8/algo-practices/tree/master/leetcode

