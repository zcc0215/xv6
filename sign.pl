#!/usr/bin/perl

open(SIG, $ARGV[0]) || die "open $ARGV[0]: $!"; #打开命令行指定文件

$n = sysread(SIG, $buf, 1000);#读取1000字节到buf

if($n > 510){
  print STDERR "boot block too large: $n bytes (max 510)\n"; #读取超过510则提示超出一个扇区
  exit 1;
}

print STDERR "boot block is $n bytes (max 510)\n";#打印启动扇区有效字节

$buf .= "\0" x (510-$n);
$buf .= "\x55\xAA";#末尾填写0x55,0xaa

open(SIG, ">$ARGV[0]") || die "open >$ARGV[0]: $!";
print SIG $buf;#将缓冲区写回文件
close SIG;
