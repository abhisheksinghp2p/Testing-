
# 1. The --help Option
Most commands support --help for quick reference.

```bash
ls --help
cp --help
find --help
grep --help
```


## 2. Man Pages (Manual)
The most comprehensive built-in documentation.

**Basic usage:**
```
man ls                          # Manual for ls
man 5 passwd                    # Section 5 of passwd
man -k keyword                  # Search for keyword
man -f command                  # Short description (like whatis)
```

## Documentation in /usr/share/doc
Many packages include additional documentation.
```bash
ls /usr/share/doc/
ls /usr/share/doc/bash/
cat /usr/share/doc/sudo/README
```

**Common files found:**
- README
- CHANGELOG
- COPYING (license)
- INSTALL
- Configuration examples
- Sample files

### Getting Help
| Method     | Usage                | Example        |
| :--------- | :------------------- | :------------- |
| **--help** | Quick help           | `ls --help`    |
| **man**    | Full manual          | `man ls`       |
| **info**   | Detailed info        | `info ls`      |
| **whatis** | One-line description | `whatis ls`    |
| **which**  | Command location     | `which python` |
| **type**   | Command type         | `type cd`      |
