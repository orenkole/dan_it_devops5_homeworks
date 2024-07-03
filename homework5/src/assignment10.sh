#!/bin/bash
# Write script which watching directory "~/watch". 
# If it sees that there appeared a new file, it prints files content and rename it to *.back
# Write SystemD service for this script and make it running

# change file perimisson:
# chmod +x assignment10.sh

# Create assignment10.service is /etc/systemd/system
# content is in assignment10.service
# run:
# systemctl daemon-reload
# systemctl start assignment10.service
# systemctl stop assignment10.service

# add service to bootup:
# systemctl enable assignment10.service

watch_dir="$HOME/watch"

mkdir -p "$watch_dir"

monitor_directory() {
    declare -A seen_files
    echo $files
    while true; do
        files=("$watch_dir"/*)
        if [ ${#files[@]} -eq 0 ]; then
            echo "No new files detected. Waiting..."
            sleep 5
            continue
        fi
        for file in "${files[@]}"; do
            if [[ -f "$file" && ! "$file" =~ \.back$ && -z "${seen_files["$file"]}" ]]; then
                echo "New file detected: $(basename "$file")"
                cat "$file"
                mv "$file" "$file.back"
                seen_files["$file"]=1
            fi
        done
        sleep 5
    done
}

monitor_directory