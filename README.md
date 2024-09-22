vim-puppet
==========

[![Build
Status](https://secure.travis-ci.org/rodjek/vim-puppet.png)](http://travis-ci.org/rodjek/vim-puppet)

Make vim more Puppet friendly!

Provides
--------

* Formatting based on the latest Puppetlabs Style Guide
* Syntax highlighting compatible with puppet 4.x
  * by default, highlights errors: mixing spaces and tabs and bad names. If you
    don't want this highlighting, add `let g:puppet_display_errors = 0` to your
    vimrc.
* Automatic => alignment
  * If you don't like that, add `let g:puppet_align_hashes = 0` to your vimrc.
* Ctags support
  * gutentags integration
    * You can enable loading tags with gutentags by setting
      `g:gutentags_dont_load = 1` in your vimrc
* Doesn't require a bloated JRE
* Doesn't take minutes to open

Additional useful plugins
-------------------------

* [vim-yardoc](https://github.com/noprompt/vim-yardoc) Syntax coloration for
  YARD tags and directives. It can also colorize the tags and directives in
  puppet files.
* [syntastic](https://github.com/scrooloose/syntastic) plugin for automatic
   syntax checking while in vim.
* [vim-snippets](https://github.com/honza/vim-snippets) is a library of
  snippets for multiple languages, including Puppet. Works with both
  [snipmate](https://github.com/garbas/vim-snipmate) and
  [ultisnips](https://github.com/SirVer/ultisnips).
* [Tagbar](https://github.com/majutsushi/tagbar) plugin for Ctags support.

Installation
------------

With [Vim 8 packages](http://vimhelp.appspot.com/repeat.txt.html#packages):

    git clone https://github.com/rodjek/vim-puppet.git ~/.vim/pack/plugins/start/vim-puppet

With [Pathogen](https://github.com/tpope/vim-pathogen):

If you're using [pathogen](https://github.com/tpope/vim-pathogen) to manage
your vim modules (and if you're not, why aren't you), you can simply add this
as a submodule in your `~/.vim/bundle/` directory.

My entire home directory is a git repository, so for me it's simply a case of

    git submodule add -f git://github.com/rodjek/vim-puppet.git .vim/bundle/puppet

If you're not using pathogen, you can just manually place the files in the
appropriate places under `~/.vim/`

With [Plug](https://github.com/junegunn/vim-plug)

In your ~/.vimrc (or stdpath('config') . '/init.vim' for Neovim)

```vim
 call plug#begin()
   Plug 'rodjek/vim-puppet'
 call plug#end()
```

if you want to load only for puppet type use (pay attention to the * for epupet type)

```vim
 call plug#begin()
   Plug 'rodjek/vim-puppet', { 'for': ['puppet', '*epuppet'] }
 call plug#end()
```

Testing
-------

Testing is based on vader.vim testing framework, see:
<https://github.com/junegunn/vader.vim> . To run full test suit use
`./test/run-tests.sh`, this will also download vader.vim plugin to project's
folder.
