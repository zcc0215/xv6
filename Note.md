##Makefile
###$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $^  
-N 代码节和数据节可读可写，无需页边距对其  
-e main 指定运行时第一条指令  
-Ttext 指定代码内存起始位置，后续代码内偏移量以此为基准，如不指定则默认值为分段分页后虚拟地址  
$@ 输出目标  
$^ 依赖文件  
###$(CC) $(CFLAGS) -fno-pic -O -nostdinc -I. -c bootmain.c
-fno-pic 代码与位置无关  
-0 默认-01优化  
-nostdinc 不使用linux系统c代码库  
-I. 在当前目录查找头文件  
-c 生成目标文件.o   
###$(OBJCOPY) -S -O binary -j .text bootblock.o bootblock
-S 不从源文件中拷贝重定位信息和符号信息  
-O binary  指定使用二进制格式生成目标文件  
-j .text 选择指定节  
###$(LD) $(LDFLAGS) -T kernel.ld -o kernel entry.o $(OBJS) -b binary initcode entryother
-T 指定链接脚本  
-b binary 使用二进制安排布局 合并拼接至最后位置
###dd if=/dev/zero of=xv6.img count=10000
/dev/zero 使用0x00 填充
###dd if=bootblock of=xv6.img conv=notrunc
conv=notrunc 不截断输出文件
###dd if=kernelmemfs of=xv6memfs.img seek=1 conv=notrunc
seek=1 从开头跳过1个块再开始复制
##X86.h
输入部分：输出部分：描述部分  
%0 占位符指代表达式，按出现顺序排序  
%%gs 代表gs寄存器  
"=a" (data) 表示data与寄存器eax关联 返回值保存在data中, =代表只读（输出） +代表可读可写（输入输出）  
cld; 使标志方向为DF = 0,即内存向高地址位增加  
rep 重复指令，重复次数保存在eac中  
“0” 指代表达式%0中寄存器  
描述符 memory : 此汇编指令不重新排序,不将变量缓存到寄存器  
描述符 cc: 汇编指令可修改标志寄存器
lgdt 设置段描述符表基址寄存器  
lidt 设置中断向量表基址寄存器  
ltr  设置任务状态段基址寄存器  
CR0  启用分段分页模式  
CR1  保留未用  
CR2  缺页地址寄存器
CR3  页表基址寄存器  
CR4  启用4MB大页模式
##.gdbinit
target remote localhost:1234 设置远程调试端口  
调试内核命令：  
make qemu-gdb  
gdb gdb -silent kernel  
gdb Auto-loading safe path      
symbol-file kernel 加载文件符号表,用于调试,同时可用gdb启动后执行 file bootblock.o加载指定文件符号表  
-monitor stdio  启用qemu调试,使用qemu info registers 查看全部寄存器中值
##entry.S
.comm stack, KSTACKSIZE 声明未初始化数据，含符号和长度两项  
jmp *%eax * 直接寻址   
不带 * 是按偏移量寻址,偏移范围 -128~127
##mp.c
Mp table 相关参考 MPsper.pdf 第四章 
BDA 相关参考https://wiki.osdev.org/BDA#BIOS_Data_Area_.28BDA.29
##lapicstartap
启动AP 相关参考https://wiki.osdev.org/Symmetric_Multiprocessing