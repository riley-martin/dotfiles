function webcam
    gphoto2 --stdout --capture-movie | ffmpeg -i - -f video4linux2 -pix_fmt yuv420p /dev/video0
end

