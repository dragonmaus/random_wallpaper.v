module main

import os
import os.cmdline
import rand.util
import x.json2

fn main() {
	mut files := []string{cap: 1024}
	quiet := '-q' in os.args

	mut dirs := cmdline.only_non_options(os.args[1..])
	if dirs.len == 0 {
		dirs << '.'
	}
	for dir in dirs {
		os.walk_with_context(dir, files, fn (mut files []string, path string) {
			if os.is_file(path) {
				files << os.real_path(path)
			}
		})
	}

	current := json2.raw_decode(os.execute('painter get').output) ? as string

	for selected in util.sample_nr(files, 2) {
		if selected != current {
			if !quiet {
				print('Setting wallpaper to "$selected"…')
			}
			if os.execute('painter set "$selected"').exit_code == 0 {
				if !quiet {
					println(' OK!')
				}
			} else {
				if !quiet {
					println(' Error!')
				}
			}
			break
		}
	}
}
