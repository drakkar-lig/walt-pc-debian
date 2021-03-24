Caution:
* debootstrap may create /bin as a symlink to /usr/bin
  thus trying to apply a dockerfile COPY operation with
  customize1/bin or customize2/bin being a directory would
  fail. Use customize<X>/usr/bin instead.
* the same is true for /sbin.
