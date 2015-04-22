'''Deduplicate bash history'''

# [ Imports ]
# [ -Python- ]
import sys
import os.path

# [ Argument Parsing ]
hist_file_path = sys.argv[-1]


# [ Helpers ]
def is_timestamp_line(line):
    if line.startswith('#'):
        try:
            int(line[1:])
            return True
        except (TypeError, ValueError):
            pass
    return False


# [ Main ]
# Safety check
if not os.path.isfile(hist_file_path):
    sys.stderr.write("{} cannot deduplicate {}: it is not a regular file.\n".format(sys.argv[0], hist_file_path))
    exit(1)

# Save off modification time
mtime = os.path.getmtime(hist_file_path)
# Get the current history
with open(hist_file_path) as hist_file:
    lines = hist_file.readlines()
# Build new, deduped history
new_lines = []
deduplicated = []
for line in lines:
    # Remove old line
    if line in new_lines and not is_timestamp_line(line):
        old_index = new_lines.index(line)
        del new_lines[old_index]
        # Check for and remove old timestamp line
        timestamp_index = old_index - 1
        if timestamp_index >= 0 and is_timestamp_line(new_lines[timestamp_index]):
            del new_lines[timestamp_index]
        deduplicated.append(line)
    new_lines.append(line)
# Lines are getting lost and I don't know where.  Guard against that here.
for line in lines:
    if not is_timestamp_line(line):
        if line not in new_lines:
            sys.stderr.write("{} deduplicated {} incorrectly.  New file is missing '{}'.  Not writing new file.\n".format(
                    sys.argv[0], hist_file_path, line
            ))
            exit(1)
# Guard a little against file access issues:
new_mtime = os.path.getmtime(hist_file_path)
if mtime == new_mtime:
    with open(hist_file_path, 'w') as hist_file:
        hist_file.write(''.join(new_lines))
else:
    sys.stderr.write("{} cannot deduplicate {}: file has changed since last read.\n".format(sys.argv[0], hist_file_path))
    exit(1)

# Report
deduplicated_count = len(deduplicated)
plural = 'entries' if deduplicated_count != 1 else 'entry'
end = '.' if deduplicated_count == 0 else ':'
print("  Deduplicated {} global history {}{}".format(deduplicated_count, plural, end))
if deduplicated_count:
    print('    ' + '    '.join(deduplicated)[:-1])
