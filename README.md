# Zram-swap-config
Like zram-config-0.5

zram-config-0.5 is a broken package that for many reasons should not be used.
Zram-swap-config is an interim package until zram-config-0.5 is fixed in deploy and operation

Usefull for IoT / maker projects for reducing SD, Nand and Emmc block wear via write operations.
Check the Swapiness-load-balancer branch for dynamic swappiness control.


_____
## Menu
1. [Install](#install)
2. [Upgrade](#upgrade)
3. [Customize](#customize)
4. [It is working ?](#it-is-working)
5. [Uninstall](#uninstall-)

## Install

    git clone https://github.com/StuartIanNaylor/zram-swap-config
    cd zram-swap-config
    chmod +x install.sh && sudo ./install.sh
    cd ..
    rm -r zram-swap-config

## Upgrade

Run zram-swap-config-uninstall.sh from /usr/local/bin/ and start then start the new [install](#install).

## Customize
#### variables :
In the file `/etc/zram-swap-config.conf`:

- MEM_FACTOR = Percentage of available ram to allocate to all zram swap devices which is divided equally by swap_devices number
- DRIVE_FACTOR = Virtual uncompressed zram drive size estimate approx alg compression ratio 
- COMP_ALG lz4 is faster than lzo but some distro's show compile and operational difference and in use lzo depending on binary may be faster. Compression rates list below are minimums and generally far bigger in operation but dependent on content.
- SWAP_DEVICES = number of indivial drives sharing memeory provided by MEM_FACTOR each device support multiple streams 1 large drive is generally better
- SWAP_PRI = swap_priority for each drive 75 is a high order preference and should be well above other swap drives
- PAGE_CLUSTER default page cluster is 3 which caches fetches in batches of 8 and helps with HDD paging, with zram mem 0 forces single page fetches
This can help reduce latency and increase performance
- SWAPPINESS default swappiness is 60 but with increased performance of zram swap 80 garners overall performance gain without excessive load
Because zram uses compression load is created and even if minimal at intense load periods such as boot any extra load is unwanted
Unfortunately there is no dynamic load balancing of swappiness as with zram in general operation SWAPINESS=100 will garner performance benefit
If the overall load is reasonable at high load it will cause load to accumulate. 
If you check my repo there will also be a simple dynamic load based SWAPPINESS governor that will get of the hurdle of a static compromise on swappiness


### It is working?
You can now check the mount folder in ram with (You will see lines with zram if working)
```
# zramctl
…
NAME       ALGORITHM DISKSIZE  DATA  COMPR TOTAL STREAMS MOUNTPOINT
/dev/zram0 lz4         455.1M    4K    65B    4K       1 [SWAP]
/dev/zram1               140M 17.7M 432.4K  680K       1 /var/log
…

# swapon
…
NAME       TYPE        SIZE USED PRIO
/dev/zram0 partition 455.1M   0B   75
/var/swap  file        100M   0B   -2
…
# free -m
…
              total        used        free      shared  buff/cache   available
Mem:            433          31         329           3          72         351
Swap:           555           0         555
…
# cat /proc/sys/vm/swappiness
…
80
…
# cat /proc/sys/vm/page-cluster
…
0
…
# sudo apt-get install stress
# stress --vm 3 --vm-bytes 256M --timeout 60s
…
stress: info: [861] dispatching hogs: 0 cpu, 0 io, 3 vm, 0 hdd
stress: info: [861] successful run completed in 60s
```
Any comp alg can be used for zram, zramctl unfortunately only has the text strings for lzo/lz4 so blank space is displayed.
zstd kernel inclusion seems to have some politics attached.
Check /proc/crypto for available.

| Compressor name	     | Ratio	| Compression | Decompress. |
|------------------------|----------|-------------|-------------|
|zstd 1.3.4 -1	         | 2.877	| 470 MB/s	  | 1380 MB/s   |
|zlib 1.2.11 -1	         | 2.743    | 110 MB/s    | 400 MB/s    |
|brotli 1.0.2 -0	     | 2.701	| 410 MB/s	  | 430 MB/s    |
|quicklz 1.5.0 -1	     | 2.238	| 550 MB/s	  | 710 MB/s    |
|lzo1x 2.09 -1	         | 2.108	| 650 MB/s	  | 830 MB/s    |
|lz4 1.8.1	             | 2.101    | 750 MB/s    | 3700 MB/s   |
|snappy 1.1.4	         | 2.091	| 530 MB/s	  | 1800 MB/s   |
|lzf 3.6 -1	             | 2.077	| 400 MB/s	  | 860 MB/s    |

You may wish to uninstall raspbian file swap services
```
sudo apt-get remove dphys-swapfile
or
disable
sudo systemctl disable dphys-swapfile
```


## Uninstall 

```
chmod +x /usr/local/bin/zram-swap-config-uninstall.sh && sudo /usr/local/bin/zram-swap-config-uninstall.sh
```
