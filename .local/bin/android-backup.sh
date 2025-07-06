#!/bin/sh

TARGET_DIRECTORY="/mnt/ssd/android-backup"
COPY_DIRECTORIES="Aegis GCam Download Pictures Documents SwiftBackup DCIM"
COPY_PREFIX="/sdcard"
CIPHER_ALGO="AES-256"

check_adb() {
    if ! type adb > /dev/null 2>&1; then
        echo "ADB is not available"
        exit 1
    fi
}

check_device() {
    NUM_DEVICES=$(adb devices | grep -c "device$")
    if [ "$NUM_DEVICES" -ne 1 ]; then
        echo "Number of devices is $NUM_DEVICES instead of 1"
        exit 1
    fi
    echo "Device: $(adb devices | grep 'device$' | sed 's/\s.*//')"
}

create_target() {
    if ! test -d "$TARGET_DIRECTORY"; then
        mkdir "$TARGET_DIRECTORY" || ( echo "Failed to create target directory" 1>&2 && exit 1 )
    fi
    echo "Target directory: $TARGET_DIRECTORY"
}

copy_directories() {
    for dir in $COPY_DIRECTORIES; do
        adb pull "${COPY_PREFIX}/${dir}" "$TARGET_DIRECTORY"
    done
}

encrypt_apps() {
    cd "$TARGET_DIRECTORY"
    find . -type d -regex ".*/apps/local" -exec cp -r {} "apps" \;
    tar -cf - "apps" | pv | pigz > "apps.tar.gz"
    gpg --cipher-algo "$CIPHER_ALGO" -c "apps.tar.gz"
}

delete_unencrypted() {
    cd "$TARGET_DIRECTORY"
    find . -type d -regex ".*/apps/local" -exec rm -rf {} \;
    rm -rf "apps"
    rm -rf "apps.tar.gz"
}

main() {
    check_adb
    check_device
    create_target
    copy_directories
    encrypt_apps
    delete_unencrypted
}

main
