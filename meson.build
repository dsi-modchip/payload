project('dsi-modchip-payload', 'c',
  version: '0.1.0',
  license: 'GPL3',
  meson_version: '>=0.59.0',
  default_options: ['warning_level=2', 'c_std=gnu11'])

subdir('subprojects/libdawn/build/')

cflags = cflags_base
ldflags = ldflags_base

has_nano = cc.find_library('c_nano', required: false).found()

if has_nano
  ldflags += '-specs=nano.specs'
endif

add_project_arguments(cflags, language: 'c')
add_project_link_arguments(ldflags, language: 'c')

libdawn_proj = subproject('libdawn', default_options: [
  'arm7mem_layout=wram',
  'enable_kernel=true'
])

libdawn = libdawn_proj.get_variable('libdawn_dep')
libdawn_hw = libdawn_proj.get_variable('libdawn_hw_dep')
libdawn_baremetalrt = libdawn_proj.get_variable('libdawn_baremetalrt_dep')

subdir('exploit')
#subdir('bootloader')
