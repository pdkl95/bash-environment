if [[ "$TERM" =~ 256color ]] ; then
    LS_COLORS='bd=48;5;214;38;5;055;1:ca=38;5;017:cd=48;5;149;38;5;089;1:di=48;5;232;38;5;004;1:do=38;5;201:ex=38;5;010;1:pi=48;5;061;38;5;200;1:fi=38;5;253:ln=38;5;051;1;4:no=38;5;254:mh=48;5;233;38;5;221;1;4:or=48;5;196;38;5;232;1:ow=38;5;033;1:sg=48;5;124;38;5;252;1:su=48;5;124;38;5;253:so=38;5;200:st=48;5;235;38;5;118;1:tw=48;5;235;38;5;139;1:*.lck=48;5;124;38;5;15;3;4:*.lock=48;5;124;38;5;15;3;4:*.tar.gz=48;5;52;38;5;124:*.tar.bz1=48;5;52;38;5;160:*.tgz=48;5;232;38;5;124:*.tbz2=48;5;232;38;5;169:*.tar=38;5;120:*.gz=48;5;16;38;5;203:*.bz2=48;5;16;38;5;204:*.rar=48;5;333;38;5;160:*.zip=48;5;234;38;5;161:*.jar=48;5;235;38;5;162:*.7z=48;5;333;38;5;160:*.rz=48;5;333;38;5;160:*.cpio=48;5;333;38;5;160:*.deb=48;5;233;38;5;89:*.rpm=48;5;235;38;5;53:*.arj=48;5;234;38;5;88:*.taz=48;5;234;38;5;88:*.lzh=48;5;234;38;5;88:*.lzma=48;5;234;38;5;88:*.z=48;5;234;38;5;88:*.Z=48;5;234;38;5;88:*.dz=48;5;234;38;5;88:*.bz=48;5;234;38;5;88:*.tz=48;5;234;38;5;88:*.ace=48;5;236;38;5;88:*.zoo=48;5;234;38;5;88:*.jpg=38;5;005:*.jpeg=38;5;005:*.gif=38;5;005:*.bmp=38;5;005:*.pbm=38;5;005:*.pgm=38;5;005:*.ppm=38;5;005:*.tga=38;5;005:*.xbm=38;5;005:*.xpm=38;5;005:*.tif=38;5;005:*.tiff=38;5;005:*.png=38;5;005:*.mng=38;5;005:*.pcx=38;5;005:*.mkv=48;5;16;38;5;135:*.webm=48;5;16;38;5;134:*.mpg=48;5;234;38;5;097:*.mp4=48;5;232;38;5;140:*.m4v=48;5;232;38;5;140:*.mp4v=48;5;232;38;5;140:*.ogm=48;5;232;38;5;141:*.avi=48;5;232;38;5;134:*.mpeg=48;5;234;38;5;097:*.vob=48;5;233;38;5;098:*.m2v=48;5;233;38;5;098:*.flv=48;5;235;38;5;097:*.mov=48;5;235;38;5;135:*.wmv=48;5;235;38;5;176:*.asf=48;5;236;38;5;176:*.rm=48;5;071;38;5;169:*.rmvb=48;5;071;38;5;169:*.qt=38;5;005:*.nuv=38;5;005:*.flc=38;5;005:*.fli=38;5;005:*.gl=38;5;005:*.dl=38;5;005:*.xcf=38;5;005:*.xwd=38;5;005:*.yuv=38;5;005:*.au=38;5;006:*.flac=38;5;006:*.mp3=38;5;006:*.aac=38;5;006:*.ogg=38;5;006:*.mid=38;5;006:*.midi=38;5;006:*.wav=38;5;006:*.mka=38;5;006:*.mpc=38;5;006:*.ra=38;5;006:*.ssa=48;5;23;38;5;192:*.ass=48;5;23;38;5;192:*.srt=48;5;23;38;5;191:*.sub=48;5;23;38;5;157:*.cfg=48;5;235;38;5;222:*.conf=48;5;235;38;5;222:*.config=48;5;235;38;5;222:*.nfo=48;5;58;38;5;194;3:*.html=48;5;16;38;5;187:*.htm=48;5;16;38;5;185:*.js=48;5;16;38;5;182:*.json=48;5;16;38;5;186:*.css=48;5;16;38;5;229:*.svg=48;5;16;38;5;175:*.svgz=48;5;16;38;5;162:*.shaml=48;5;232;38;5;209:*.haml=48;5;232;38;5;216:*.coffee=48;5;232;38;5;217:*.sass=48;5;232;38;5;228:*.scss=48;5;232;38;5;228:*.less=48;5;232;38;5;228:*.md=48;5;232;38;5;218:*.markdown=48;5;232;38;5;218:*.bash=38;5;002:*.sh=38;5;002:*.csh=38;5;002:*.bak=48;5;17;38;5;249;3:*.backup=48;5;17;38;5;249;3:*.o=48;5;16;38;5;236;1:*.orig=48;5;16;38;5;81;3:*.log=48;5;56;38;5;228:*.exe=48;5;238;38;5;40:*.dmg=48;5;236;38;5;48:*.dircolors=48;5;57;38;5;49:';
export LS_COLORS

else
    LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
fi

export LS_COLORS
