#/bin/bash
#  Attribute codes:
# # 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# # Text color codes:
# # 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# # Background color codes:
# # 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
# #NORMAL 00 # no color code at all
# #FILE 00 # regular file: use no color at all
# RESET 0 # reset to "normal" color
#  MULTIHARDLINK 00 # regular file with more than one link
#  FIFO 40;33 # pipe
#  SOCK 01;35 # socket
#  DOOR 01;35 # door
#  BLK 40;33;01 # block device driver
#  CHR 40;33;01 # character device driver
#  ORPHAN 40;31;01 # symlink to nonexistent file, or non-stat'able file ...
#  MISSING 00 # ... and the files they point to
#  SETUID 37;41 # file that is setuid (u+s)
#  SETGID 30;43 # file that is setgid (g+s)
#  CAPABILITY 30;41 # file with capability
#  STICKY_OTHER_WRITABLE 30;42 # dir that is sticky and other-writable (+t,o+w)
#  OTHER_WRITABLE 34;42 # dir that is other-writable (o+w) and not sticky
#  STICKY 37;44 # dir with the sticky bit set (+t) and not other-writable
#  # This is for files with execute permission:
#  EXEC 01;32

LS_COLORS=''
LS_COLORS=$LS_COLORS:'no=36'          # Normal text       = Default foreground
# LS_COLORS=$LS_COLORS:'fi=35'        # Regular file      = Default foreground
LS_COLORS=$LS_COLORS:'di=33;1'        # Directory         = Bold, Blue

                                      # stiky
LS_COLORS=$LS_COLORS:'tw=34;4'
LS_COLORS=$LS_COLORS:'ow=34;4'

                                      # 行末的注释是错的，别看
LS_COLORS=$LS_COLORS:'ln=37;4'        # Symbolic link     = Bold, Cyan
LS_COLORS=$LS_COLORS:'or=01;05;31'    # broken  link      = Bold, Red, Flashing
LS_COLORS=$LS_COLORS:'pi=34;4'        # Named pipe        = Yellow
LS_COLORS=$LS_COLORS:'so=34;4'        # Socket            = Bold, Magenta
LS_COLORS=$LS_COLORS:'do=34;4'        # DO                = Bold, Magenta
LS_COLORS=$LS_COLORS:'bd=34;4'        # Block device      = Bold, Grey
LS_COLORS=$LS_COLORS:'cd=34;4'        # Character device  = Bold, Grey
LS_COLORS=$LS_COLORS:'ex=35'          # Executable file   = Light, Blue
LS_COLORS=$LS_COLORS:'*.sh=47;31'     # Shell-Scripts     = Foreground White, Background Red
LS_COLORS=$LS_COLORS:'*.vim=34'       # Vim-"Scripts"     = Purple
LS_COLORS=$LS_COLORS:'*.swp=00;44;37' # Swapfiles (Vim)   = Foreground Blue, Background White
LS_COLORS=$LS_COLORS:'*,v=5;34;93'    # Versioncontrols   = Bold, Yellow
LS_COLORS=$LS_COLORS:'*.c=1;33'       # Sources           = Bold, Yellow
LS_COLORS=$LS_COLORS:'*.C=1;33'       # Sources           = Bold, Yellow
LS_COLORS=$LS_COLORS:'*.h=1;33'       # Sources           = Bold, Yellow
LS_COLORS=$LS_COLORS:'*.jpg=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.jpeg=1;32'    # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.JPG=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.gif=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.png=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.jpeg=1;32'    # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.tar=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.tgz=1;31'     # Archive           = Red
LS_COLORS=$LS_COLORS:'*.gz=1;31'      # Archive           = Red
LS_COLORS=$LS_COLORS:'*.xz=1;31'      # Archive           = Red
LS_COLORS=$LS_COLORS:'*.zip=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.bz2=1;31'     # Archive           = Red
LS_COLORS=$LS_COLORS:'*.jpeg=1;32'    # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.tar=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.tgz=1;31'     # Archive           = Red
LS_COLORS=$LS_COLORS:'*.gz=1;31'      # Archive           = Red
LS_COLORS=$LS_COLORS:'*.xz=1;31'      # Archive           = Red
LS_COLORS=$LS_COLORS:'*.zip=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.bz2=1;31'     # Archive           = Red
LS_COLORS=$LS_COLORS:'*.html=36'      # HTML              = Cyan
LS_COLORS=$LS_COLORS:'*.htm=1;34'     # HTML              = Bold, Blue
LS_COLORS=$LS_COLORS:'*.txt=0'        # Plain/Text        = Default Foreground
export LS_COLORS
