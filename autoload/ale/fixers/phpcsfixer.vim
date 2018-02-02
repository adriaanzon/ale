call ale#Set('php_phpcsfixer_executable', 'php-cs-fixer')
call ale#Set('php_phpcsfixer_options', '')

function! ale#fixers#phpcsfixer#GetExecutable(buffer) abort
    return ale#Var(a:buffer, 'php_phpcsfixer_executable')
endfunction

function! ale#fixers#phpcsfixer#Fix(buffer) abort
    let l:executable = ale#fixers#phpcsfixer#GetExecutable(a:buffer)

    let l:command = ale#semver#HasVersion(l:executable)
    \   ? ''
    \   : ale#Escape(l:executable) . ' --version'

    return {
    \   'command': l:command,
    \   'chain_with': 'ale#fixers#phpcsfixer#ApplyFixForVersion',
    \}
endfunction

function! ale#fixers#phpcsfixer#ApplyFixForVersion(buffer, version_output) abort
    let l:options = ale#Var(a:buffer, 'php_phpcsfixer_options')
    let l:executable = ale#fixers#prettier_eslint#GetExecutable(a:buffer)
    let l:version = ale#semver#GetVersion(l:executable, a:version_output)

    if !ale#semver#GTE(l:version, [2, 0, 0])
        return 0
    endif

    return {
    \   'command': ale#Escape(ale#fixers#phpcsfixer#GetExecutable(a:buffer))
    \       . ' fix %t ' . l:options,
    \   'read_temporary_file': 1,
    \}
endfunction
