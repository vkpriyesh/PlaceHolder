import cv2
import os

def save_frames(video_path, output_dir):
    # Ensure output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Initialize video capture
    cap = cv2.VideoCapture(video_path)
    frame_count = 0

    while cap.isOpened():
        # Read a frame from the video
        ret, frame = cap.read()

        # Break the loop if we reach the end of the video
        if not ret:
            break

        # Save the frame as an image
        output_file = os.path.join(output_dir, f"frame_{frame_count:04d}.png")
        cv2.imwrite(output_file, frame)
        frame_count += 1

    # Release video capture and close all windows
    cap.release()
    cv2.destroyAllWindows()

# Example usage:
video_path = "path/to/your/video.mp4"
output_dir = "path/to/output/directory"
save_frames(video_path, output_dir)
