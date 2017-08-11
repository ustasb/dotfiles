#!/usr/bin/env ruby

# Adds a 6 GB FAT32 partition to a USB. The rest becomes an EXFAT partition.
# usage: `./partition_usb_for_tails.rb disk2`
# inspiration: https://www.reddit.com/r/applehelp/comments/4egve5/unmountable_external_drive/

# ==== helpers

def log(msg)
  puts "==> #{msg}"
end

def run_cmd(cmd)
  log(cmd)

  unless system(cmd)
    puts "Command failed! Exiting..."
    exit
  end

  puts "\n"
end

# ==== vars

usb_disk = "/dev/"

case ARGV.length
when 0
  puts "Provide the disk to reformat. e.g. disk2"
  exit
when 1
  usb_disk += ARGV.first
else
  puts "Too many arguments!"
  exit
end

tails = "Tails"
tails_volume = tails.upcase # https://superuser.com/a/1031899

# ==== commands

run_cmd("sudo diskutil unmountDisk force #{usb_disk}")

# Prevents the drive from attempting to mount when you attach it.
# It also effectively stops diskutil from working.
run_cmd('sudo killall -SIGSTOP diskarbitrationd')

# Clean the disk.
run_cmd("sudo dd if=/dev/zero of=#{usb_disk} bs=1024 count=1024")

# This should allow your drive to automatically initialize, and be formatted with
# the Disk Utility GUI.
run_cmd('sudo killall -SIGCONT diskarbitrationd')

# Partition the disk.
# GPT: GUID Partition Table - Intel Macs can only boot from GUID partitions.
run_cmd("diskutil partitionDisk #{usb_disk} GPT \"MS-DOS FAT32\" #{tails_volume} 6g ExFAT storage 0b")

# Customize the volume name in the EFI boot menu.
run_cmd("sudo bless --folder /Volumes/#{tails_volume} -label #{tails}")

run_cmd("diskutil eject #{usb_disk}")

log("Done!")
