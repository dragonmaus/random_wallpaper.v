module main

import os
import os.cmdline
import rand
import regex

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

	mut re := regex.regex_opt(r'\\(.)')!
	current := re.replace(os.execute('painter get').output
		.trim_string_left('"').trim_string_right('"'), '\0')

	for selected in rand.sample(files, 2) {
		if selected != current {
			if !quiet {
				print('Setting wallpaper to "${selected}"...')
			}
			if os.execute('painter set "${selected}"').exit_code == 0 {
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
