#!/bin/sh

# 1. Check if a dynamic image URL is provided
if [ -n "$IMAGE_URL" ]; then
    echo "IMAGE_URL detected: $IMAGE_URL"
    echo "Downloading new image..."
    # Download the image and overwrite the default /image.jpg
    # -L follows redirects, -s is silent, -f fails on 404/500 errors
    if curl -L -s -f -o /tmp/downloaded_image.jpg "$IMAGE_URL"; then
        mv /tmp/downloaded_image.jpg /image.jpg
        echo "Download successful. Using new image."
    else
        echo "Download failed or URL invalid. Falling back to default image."
    fi
else
    echo "No IMAGE_URL provided. Using default /image.jpg"
fi

# 2. Start MediaMTX in the background (logs redirected to a file)
/usr/local/bin/mediamtx > /var/log/mediamtx.log 2>&1 &

# 3. Wait until the RTSP server is ready
while ! nc -z 127.0.0.1 8554; do
  sleep 0.5
done

# 4. Start FFmpeg in the background (logs redirected to a file)
# We use a subshell loop so it auto-restarts if it ever crashes
(while true; do
  ffmpeg -re -loop 1 -framerate 25 -i /image.jpg \
    -c:v libx264 -preset ultrafast -tune zerolatency \
    -pix_fmt yuv420p \
    -f rtsp -rtsp_transport tcp rtsp://127.0.0.1:8554/mystream
  sleep 2
done) > /var/log/ffmpeg.log 2>&1 &

echo "------------------------------------------------"
echo " RTSP Stream: rtsp://<container_ip>:8554/mystream"
echo " Stream logs: tail -f /var/log/ffmpeg.log"
echo " Server logs: tail -f /var/log/mediamtx.log"
echo "------------------------------------------------"

# 5. Start an interactive shell
exec /bin/sh