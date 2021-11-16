module main

import os
import rand.util
import x.json2

fn main() {
	mut files := []string{cap: 256}

	mut dirs := os.args.clone()
	dirs.delete(0)
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
			print('Setting wallpaper to "$selected"…')
			if os.execute('painter set "$selected"').exit_code == 0 {
				println(' OK!')
			} else {
				println(' Error!')
			}
			break
		}
	}
}
