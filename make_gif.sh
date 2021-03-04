for i in {0..18}
do
   ffmpeg -framerate 5 -i "$1sequence$i/andrew01_%d.png" -vf "drawtext=fontfile=Arial.ttf: text='%{frame_num}': start_number=1: x=(w-tw)/2: y=h-(2*lh): fontcolor=black: fontsize=20: box=1: boxcolor=white: boxborderw=5" "./Results/rae_256_512_8dy/$i.gif" -y
done

