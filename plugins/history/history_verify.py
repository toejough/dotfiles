import os.path


old_path = os.path.expanduser('~/.bash_history.old')
current_path = os.path.expanduser('~/.bash_history')
truncated_history_path = os.path.expanduser('~/.bash_history.trunc')


if os.path.exists(old_path):
    # get line-by-line contents
    old_history = []
    current_history = []
    with open(old_path) as of:
        old_history = of.readlines()
    with open(current_path) as cf:
        current_history = cf.readlines()
    # get any missing lines
    missing_lines = []
    for line in old_history:
        if line not in current_history:
            missing_lines.append(line)
    # Emit an error
    if missing_lines:
        print "  ERROR: history is missing lines!"
        for line in missing_lines:
            print "    " + line,
        # save the current history file off
        with open(truncated_history_path, 'w') as tf:
            tf.write(''.join(current_history))
        print "  Saved truncated history to {}".format(truncated_history_path)
        # add them back in
        current_history = missing_lines + current_history
        with open(current_path, 'w') as cf:
            cf.write(''.join(current_history))
        print "  Added lines back into {}".format(current_path)
    else:
        print "  No lost history detected"
else:
    print "  No old history file found"