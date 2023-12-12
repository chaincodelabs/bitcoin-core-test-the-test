sudo mkdir -p /mnt/tmp
sudo mount -t tmpfs -o size=4g tmpfs /mnt/tmp/
python3 bitcoin/build/test/functional/test_runner.py --cachedir=/mnt/tmp/cache --tmpdir=/mnt/tmp -r results.csv || echo "test_runner completed with non-zero exit code"