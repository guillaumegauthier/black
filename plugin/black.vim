" black.vim
" Author: Łukasz Langa
" Created: Mon Mar 26 23:27:53 2018 -0700
" Requires: Vim Ver7.0+
" Version:  1.1
"
" Documentation:
"   This plugin formats Python files.
"
" History:
"  1.0:
"    - initial version
"  1.1:
"    - restore cursor/window position after formatting

if v:version < 700 || !has('python3')
    echo "This script requires vim7.0+ with Python 3.6 support."
    finish
endif

if exists("g:load_black")
   finish
endif

let g:load_black = "py1.0"
if !exists("g:black_fast")
  let g:black_fast = 0
endif
if !exists("g:black_linelength")
  let g:black_linelength = 88
endif
if !exists("g:black_skip_string_normalization")
  let g:black_skip_string_normalization = 0
endif

python3 << endpython3
import sys
import vim
import black
import time

def Black():
  start = time.time()
  fast = bool(int(vim.eval("g:black_fast")))
  line_length = int(vim.eval("g:black_linelength"))
  mode = black.FileMode.AUTO_DETECT
  if bool(int(vim.eval("g:black_skip_string_normalization"))):
    mode |= black.FileMode.NO_STRING_NORMALIZATION
  buffer_str = '\n'.join(vim.current.buffer) + '\n'
  try:
    new_buffer_str = black.format_file_contents(buffer_str, line_length=line_length, fast=fast, mode=mode)
  except black.NothingChanged:
    print(f'Already well formatted, good job. (took {time.time() - start:.4f}s)')
  except Exception as exc:
    print(exc)
  else:
    cursor = vim.current.window.cursor
    vim.current.buffer[:] = new_buffer_str.split('\n')[:-1]
    vim.current.window.cursor = cursor
    print(f'Reformatted in {time.time() - start:.4f}s.')

def BlackUpgrade():
  _initialize_black_env(upgrade=True)

def BlackVersion():
  print(f'Black, version {black.__version__} on Python {sys.version}.')

endpython3

command! Black :py3 Black()
command! BlackUpgrade :py3 BlackUpgrade()
command! BlackVersion :py3 BlackVersion()
