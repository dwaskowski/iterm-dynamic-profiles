# Bash script for generate dynamic profiles for iTerm2

`actual version: 1.0.0`

## Command
```
profiles.sh -l <hosts_file_name> [-s <settings_file_name>] [-t <template_file_name>] [-o <output_file_name>]
```
* -l host's list file, required
* -s settings file, optional, default use `settings.cfg`
* -t template file, optional, default use `template.cfg`
* -o output file, optional, default use `<name_of_host_file>.json`

## List file
List file should have 2 or 3 parameters where:
* domain name
* ip
* display name into profiles(if not exist will take first part from `domain name`)
```
domain.com 127.0.0.1 ProfileName
```

## Template file patterns
* `__SERVER_COMMAND__` - used for full command
* `__SERVER_GROUP__` - used for `tag`
* `__SERVER_NAME__` - used for `display name` and `tag`
* `__SERVER_INITIAL_TEXT__` - used for initial text
