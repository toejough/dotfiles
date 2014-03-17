'''Sort bash history'''

#  [ Imports ]
#  [ -Python- ]
import sys
import os.path

#  [ Argument Parsing ]
hist_file_path = sys.argv[-1]


#  [ Helpers ]
def is_timestamp_line(line):
    if line.startswith('#'):
        try:
            int(line[1:])
            return True
        except [TypeError, ValueError]:
            pass
    return False


#  [ Main ]
#  Safety check
if not os.path.isfile(hist_file_path):
    print("{} cannot sort {}: it is not a regular file.".format(sys.argv[0], hist_file_path))
    exit(1)

#  Save off modification time
mtime = os.path.getmtime(hist_file_path)
#  Get the current history
with open(hist_file_path) as hist_file:
    lines = hist_file.readlines()
#  Build sortable history list
sortable = []
for index, line in enumerate(lines):
    if not is_timestamp_line(line):
        timestamp_index = index - 1
        if timestamp_index >= 0 and is_timestamp_line(lines[timestamp_index]):
            #  preceeded by a timestamp line.  Make a new object.
            sortable.append({
                "ts": lines[timestamp_index],
                "commands": [line]
            })
        elif sortable:
            #  no timestamp, but a prior command had one
            sortable[-1]["commands"].append(line)
        else:
            #  no timestamp, first command in history
            sortable.append({
                "ts": "#0\n",
                "commands": [line]
            })
#  Sort
sortable.sort(key=lambda i: i["ts"])
#  Build new string
new_lines = []
for item in sortable:
    new_lines.append(item["ts"])
    for command in item["commands"]:
        new_lines.append(command)
#  Guard a little against file access issues:
new_mtime = os.path.getmtime(hist_file_path)
if mtime == new_mtime:
    with open(hist_file_path, 'w') as hist_file:
        hist_file.write(''.join(new_lines))
else:
    print("{} cannot sort {}: file has changed since last read.".format(sys.argv[0], hist_file_path))
    exit(1)
