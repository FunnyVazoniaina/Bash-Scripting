# ytd-mp3

A simple Bash script to download audio from a YouTube video in high-quality MP3 format using `yt-dlp` and `ffmpeg`.

This tool is designed for Linux users who want to automate audio extraction from YouTube URLs directly from the terminal.

---

## Dependencies

Before using this script, ensure the following tools are installed:

- `yt-dlp` — a powerful YouTube downloader  
  Install with pip:
  ```bash
  pip3 install yt-dlp --user
  ```

- `ffmpeg` — required for audio conversion  
  Install on Fedora:
  ```bash
  sudo dnf install ffmpeg
  ```

---

## Features

- Extracts audio from any YouTube video
- Converts the audio to high-quality MP3 format
- Checks for required dependencies before starting
- Provides clear error messages and guidance
- Lightweight and easy to install

---

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/ytd-mp3.git
   cd ytd-mp3
   ```

2. Make the script executable:
   ```bash
   chmod +x ytd-mp3.sh
   ```

3. (Optional) Move it to your personal binaries folder:
   ```bash
   mkdir -p ~/.local/bin
   cp ytd-mp3.sh ~/.local/bin/ytd-mp3
   ```

4. Ensure `~/.local/bin` is in your `$PATH`:

   For Bash:
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

   For Fish:
   ```fish
   set -gx PATH $HOME/.local/bin $PATH
   ```

---

## Usage

```bash
ytd-mp3 <YouTube URL>
```

Example:
```bash
ytd-mp3 https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

The script will:
- Check for the presence of `yt-dlp` and `ffmpeg`
- Download the YouTube video
- Extract and save the audio in MP3 format

---

## Script Overview

This script is written in Bash and contains the following logic:

- Verify that the user provides a YouTube URL
- Check if `yt-dlp` is installed
- Check if `ffmpeg` is installed
- Run the command to extract MP3 audio from the video

---

## Future Improvements

- Add playlist support
- Allow setting output directories via options
- Provide user prompts or flags for advanced use

---

## License

This project is released under the MIT License.  
You are free to use, modify, and share this script.

---

## Author

Vazoniaina  
